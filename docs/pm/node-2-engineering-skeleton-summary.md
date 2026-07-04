# 节点 2 工程骨架交付摘要

状态：已完成

冻结路线引用：[node-roadmap-freeze.md](node-roadmap-freeze.md)

## 目标

建立 Flutter monorepo 基础工程，完成主 App 与基础 packages 的工程骨架，使后续代码型 Agent 可以基于稳定目录和包边界并行开发。

## 已交付目录

```text
apps/list_monster_app/
packages/core/
packages/task_domain/
packages/monster_domain/
packages/local_store/
packages/sync_domain/
packages/companion_contract/
packages/sprite_runtime/
packages/ui_kit/
```

## 当前工程边界

1. `apps/list_monster_app/`：主 Flutter App，包含 今日 / 清单 / 怪兽 / 我的 4 Tab 骨架。
2. `packages/core/`：通用领域事件外壳。
3. `packages/task_domain/`：任务类型、任务状态、任务草稿边界。
4. `packages/monster_domain/`：怪兽情绪与 XP 授予边界。
5. `packages/local_store/`：本地存储模块占位边界。
6. `packages/sync_domain/`：同步队列与去重键边界。
7. `packages/companion_contract/`：桌宠与 Widget 读取的统一快照边界。
8. `packages/sprite_runtime/`：怪兽表现层运行时占位。
9. `packages/ui_kit/`：清单怪兽主题与基础 UI 组件。

## 验收结果

通过：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tool\verify_node2.ps1
```

覆盖内容：

1. Flutter / Dart 版本检查。
2. 主 App `flutter pub get`、`dart analyze`、`flutter test`。
3. 6 个 Dart package 的 `dart pub get`、`dart analyze`、`dart test`。
4. 2 个 Flutter package 的 `flutter pub get`、`dart analyze`、`flutter test`。

本地启动验收：

```powershell
flutter build web
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5202
```

结果：Web build 通过；本地 `http://127.0.0.1:5202` 返回 HTTP 200。

## 工具链状态

已可用：

1. Flutter 3.44.4 stable，安装位置为 `C:\Users\huawei\tools\flutter`。
2. Dart 3.12.2。
3. Chrome / Edge Web 运行目标。

当前本机限制：

1. Android SDK 未安装，因此暂不能验 Android 真机 / 模拟器。
2. Visual Studio C++ 桌面工作负载未安装，因此 `flutter build windows --debug` 暂不能完成。

以上限制属于本机工具链缺口，不影响节点 2 的 Web 本地启动、lint 和基础测试验收。

## 节点 3 准入

节点 2 完成后，可以进入节点 3：核心闭环 Alpha。代码型 Agent 可以在初始 commit 之后基于独立 worktree 并行开发，但必须继续遵守冻结节点路线和 `docs/contracts/` 契约。
