#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  bool is_desktop_pet_window = false;
  for (const auto& argument : command_line_arguments) {
    if (argument == "--desktop-pet-window") {
      is_desktop_pet_window = true;
      break;
    }
  }

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin = is_desktop_pet_window
                                  ? Win32Window::Point(40, 40)
                                  : Win32Window::Point(10, 10);
  Win32Window::Size size = is_desktop_pet_window
                               ? Win32Window::Size(360, 420)
                               : Win32Window::Size(1280, 720);
  const wchar_t* title = is_desktop_pet_window
                             ? L"List Monster Desktop Pet"
                             : L"list_monster_app";
  if (!window.Create(title, origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
