# 清单怪兽 App

清单怪兽是一个围绕“记录任务 -> 完成任务 -> 怪兽成长反馈”的 Flutter monorepo。

## 当前阶段

截至 2026-08-09，冻结路线图中的节点 1 至节点 7 已完成，Flutter 主应用处于 MVP Beta 基线；当前没有已批准的新 Flutter 产品节点。节点 7 之后完成了像素宠物接入，并在独立的 Craft 编辑器中持续验证回响站阶段页与工作区管理能力。这些记录表示本地实现、构建或 QA 基线，不等同于线上发布。

交接状态入口：[docs/pm/current-software-status.md](docs/pm/current-software-status.md)。

宠物、宠物蛋、五阶段界面、Flutter / Craft 派生资产与 QA 证据的唯一索引见交接状态页的[设计物料地图](docs/pm/current-software-status.md#设计物料地图)。

主项目源码、文档、工具、产物、QA 证据，以及主项目 / Craft / 恢复副本边界见交接状态页的[项目内容地图](docs/pm/current-software-status.md#项目内容地图)。

路线图基线：[docs/pm/node-roadmap-freeze.md](docs/pm/node-roadmap-freeze.md)。[PROJECT_BOARD.md](PROJECT_BOARD.md) 是唯一当前全局任务与 QA 裁决看板；产品决策查 [docs/pm/pm-decisions.md](docs/pm/pm-decisions.md)。[docs/pm/wave-0-control-board.md](docs/pm/wave-0-control-board.md) 仅作历史节点与交付参考，[docs/pm/agent-roster.md](docs/pm/agent-roster.md) 仅作旧名册参考，二者不得作为当前任务状态依据。

## 任务接手

按四层顺序接手：本 README → [当前软件状态](docs/pm/current-software-status.md) → [全局任务与 QA 看板](PROJECT_BOARD.md) → [.features 任务记录索引](.features/_registry.md)及目标任务的 `status.md`。完整协议见 [AGENTS.md](AGENTS.md)，合规样例见 [T-DOC-HANDOFF-004/status.md](.features/T-DOC-HANDOFF-004/status.md)。

可复制指令：把改动更新到 `.features/<任务ID>/status.md`，按 `AGENTS.md` 模板记录改动、验证、风险和下一接手点。

## 两套运行环境

| 环境 | 位置 | 用途 | 端口口径 |
|---|---|---|---|
| Flutter 主应用 | `apps/list_monster_app/` | 产品主应用、领域能力与三端构建 | 本 README 的 Web 示例使用 `5202`；历史验收曾使用其他临时端口 |
| Craft 回响站编辑器 | `C:/Users/Administrator/Documents/craft-demo` | 可编辑画板、阶段页和工作区管理验证 | `5173` 仅指该本地 Craft 编辑器，不是 Flutter 预览或已发布产品 |

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
cd ..\..
powershell -NoProfile -ExecutionPolicy Bypass -File .\tool\build_windows.ps1
```

Windows 脚本会在检出路径含非 ASCII 字符时通过 ASCII junction 构建，在 `dist/windows` 生成 Release 包并携带 Visual C++ Release Runtime；Debug 产物仅用于本地开发。

本仓库使用 Flutter App 与 Dart / Flutter package 混合结构。开始工作前请先阅读交接状态页，并以当前工作树为准核对未提交内容。
