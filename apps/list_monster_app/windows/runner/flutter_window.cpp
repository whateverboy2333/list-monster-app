#include "flutter_window.h"

#include <optional>
#include <string>
#include <variant>
#include <windows.h>

#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"

namespace {

constexpr char kDesktopPetChannelName[] =
    "list_monster_app/desktop_pet_window";
constexpr wchar_t kDesktopPetWindowArgument[] = L"--desktop-pet-window";
constexpr wchar_t kDesktopPetSnapshotArgumentPrefix[] =
    L"--desktop-pet-snapshot=";

PROCESS_INFORMATION g_desktop_pet_process{};
bool g_has_desktop_pet_process = false;

std::wstring WidenAscii(const std::string& value) {
  return std::wstring(value.begin(), value.end());
}

void CloseDesktopPetProcessHandles() {
  if (g_desktop_pet_process.hThread != nullptr) {
    CloseHandle(g_desktop_pet_process.hThread);
    g_desktop_pet_process.hThread = nullptr;
  }
  if (g_desktop_pet_process.hProcess != nullptr) {
    CloseHandle(g_desktop_pet_process.hProcess);
    g_desktop_pet_process.hProcess = nullptr;
  }
  g_desktop_pet_process.dwProcessId = 0;
  g_desktop_pet_process.dwThreadId = 0;
  g_has_desktop_pet_process = false;
}

bool IsDesktopPetProcessRunning() {
  if (!g_has_desktop_pet_process ||
      g_desktop_pet_process.hProcess == nullptr) {
    return false;
  }

  const DWORD wait_result =
      WaitForSingleObject(g_desktop_pet_process.hProcess, 0);
  if (wait_result == WAIT_TIMEOUT) {
    return true;
  }

  CloseDesktopPetProcessHandles();
  return false;
}

BOOL CALLBACK CloseDesktopPetWindowForProcess(HWND hwnd, LPARAM lparam) {
  DWORD window_process_id = 0;
  GetWindowThreadProcessId(hwnd, &window_process_id);

  const auto target_process_id = static_cast<DWORD>(lparam);
  if (window_process_id == target_process_id && IsWindowVisible(hwnd)) {
    PostMessage(hwnd, WM_CLOSE, 0, 0);
  }
  return TRUE;
}

bool OpenDesktopPetWindow(const std::string& encoded_snapshot) {
  if (IsDesktopPetProcessRunning()) {
    return true;
  }

  wchar_t executable_path[MAX_PATH];
  const DWORD path_length =
      GetModuleFileNameW(nullptr, executable_path, MAX_PATH);
  if (path_length == 0 || path_length == MAX_PATH) {
    return false;
  }

  std::wstring command_line = L"\"";
  command_line += executable_path;
  command_line += L"\" ";
  command_line += kDesktopPetWindowArgument;
  if (!encoded_snapshot.empty()) {
    command_line += L" ";
    command_line += kDesktopPetSnapshotArgumentPrefix;
    command_line += WidenAscii(encoded_snapshot);
  }

  STARTUPINFOW startup_info{};
  startup_info.cb = sizeof(startup_info);
  PROCESS_INFORMATION process_information{};
  const BOOL created = CreateProcessW(
      executable_path, command_line.data(), nullptr, nullptr, FALSE, 0, nullptr,
      nullptr, &startup_info, &process_information);
  if (!created) {
    return false;
  }

  g_desktop_pet_process = process_information;
  if (g_desktop_pet_process.hThread != nullptr) {
    CloseHandle(g_desktop_pet_process.hThread);
    g_desktop_pet_process.hThread = nullptr;
  }
  g_has_desktop_pet_process = true;
  return true;
}

bool CloseDesktopPetWindow() {
  if (!IsDesktopPetProcessRunning()) {
    return true;
  }

  EnumWindows(CloseDesktopPetWindowForProcess,
              static_cast<LPARAM>(g_desktop_pet_process.dwProcessId));
  return true;
}

std::string SnapshotPayloadFromArguments(
    const flutter::EncodableValue* arguments) {
  if (arguments == nullptr) {
    return "";
  }

  const auto* map = std::get_if<flutter::EncodableMap>(arguments);
  if (map == nullptr) {
    return "";
  }

  const auto snapshot = map->find(flutter::EncodableValue("snapshot"));
  if (snapshot == map->end()) {
    return "";
  }

  const auto* value = std::get_if<std::string>(&snapshot->second);
  if (value == nullptr) {
    return "";
  }

  return *value;
}

}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  desktop_pet_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), kDesktopPetChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  desktop_pet_channel_->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
             result) {
        if (call.method_name().compare("openDesktopPet") == 0) {
          result->Success(flutter::EncodableValue(
              OpenDesktopPetWindow(SnapshotPayloadFromArguments(
                  call.arguments()))));
          return;
        }
        if (call.method_name().compare("closeDesktopPet") == 0) {
          result->Success(
              flutter::EncodableValue(CloseDesktopPetWindow()));
          return;
        }
        result->NotImplemented();
      });
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }
  desktop_pet_channel_ = nullptr;

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
