# 清单怪兽 App

清单怪兽是一个围绕“记录任务 -> 完成任务 -> 怪兽成长反馈”的 Flutter monorepo。

当前状态：节点 2，工程骨架 + 初始 commit，已完成。

下一节点：节点 3，核心闭环 Alpha，尚未启动。

节点路线图唯一事实源：[docs/pm/node-roadmap-freeze.md](docs/pm/node-roadmap-freeze.md)。

## 结构

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

## 本地验证

先确保 Flutter 在 PATH 中，然后运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tool\verify_node2.ps1
```

当前本机可用 Web 目标启动主 App：

```powershell
cd .\apps\list_monster_app
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5202
```

当前本机已补齐 Android 与 Windows 构建链路，可运行：

```powershell
cd .\apps\list_monster_app
flutter build apk --debug
flutter build windows --debug
```

本仓库当前使用 Flutter app + Dart/Flutter package 混合结构；节点 3 开始实现核心闭环 Alpha。
