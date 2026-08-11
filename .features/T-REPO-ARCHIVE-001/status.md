---
status: live
type: maintenance
module: repository-archive
last_updated: 2026-08-11
owner: Repo-Beta
---

# T-REPO-ARCHIVE-001 任务交接

## 任务身份

- 任务 ID：`T-REPO-ARCHIVE-001`
- 目标：在主仓与 Craft 均有恢复锚点后，将迁移恢复出的旧项目副本可逆重命名隔离，消除误入旧事实源风险。
- 依赖：`T-REPO-SAFETY-001`、`T-CRAFT-SAFETY-001` 均已完成并通过 QA。
- 记录路径：`.features/T-REPO-ARCHIVE-001/status.md`
- 证据路径：`.features/T-REPO-ARCHIVE-001/archive-manifest.txt`

## 当前状态

`ready_for_qa`

## 变更文件

- 可逆目录移动：`C:/Users/Administrator/Documents/Codex/Recovered_Old_PC/Documents/清单怪兽app` → `C:/Users/Administrator/Documents/Codex/Recovered_Old_PC/Documents/_ARCHIVE_DO_NOT_USE_清单怪兽app-c20254a-20260811`
- 主项目新增：`.features/T-REPO-ARCHIVE-001/status.md`
- 主项目新增：`.features/T-REPO-ARCHIVE-001/archive-manifest.txt`
- 主项目更新：`.features/_registry.md`

## 行为变化

- 恢复旧副本不再位于原项目名路径，后续 Agent 不会把它误认为活跃事实源。
- 旧副本未删除、未清理、未提交、未改写；其完整目录仅在同一父目录内更名。
- 活跃主仓仍为 `C:/Users/Administrator/Documents/清单怪兽app`；Craft 工作区仍为 `C:/Users/Administrator/Documents/craft-demo`。

## 验证证据

### 前置健康与路径门禁

- 主仓分支为 `master`，`HEAD` 与 `origin/master` 跟踪引用均为 `fd41609a7e1ee17daeb9c2f03dc36f66add41b95`；操作前除 PM 的 `PROJECT_BOARD.md` 差异外无异常。
- Craft 分支为 `master`，`HEAD` 为 `c7cf805d03e80361f791ab1a60c43827a5105404`，无 remote，工作树干净。
- 源、目标与父目录均使用绝对路径解析；源和目标都严格位于 `C:/Users/Administrator/Documents/Codex/Recovered_Old_PC/Documents` 内。
- 移动前源存在、目标不存在，旧副本 HEAD 为 `c20254a36645493f220461ae016826685e3488fc`。

### 移动前证据

- 文件总数：4039，包含 `.git`、隐藏文件与构建缓存。
- `git status --short`：4 个 tracked 文档修改与未跟踪 `.codex/`，完整清单见 `archive-manifest.txt`。
- 4 个修改文档及 `.codex/**` 共 8 个文件的 SHA-256、字节数与路径已写入 `archive-manifest.txt`。

### 可逆隔离操作

- 使用同一 PowerShell 的原生 `Move-Item -LiteralPath` 执行精确源目录到精确目标目录的同卷移动。
- 未复制后删除，未移动 `Recovered_Old_PC`、`Documents` 或其他资料，未修改归档目录内容。

### 移动后核对

- 旧路径不存在；目标归档路径存在。
- 归档 `.git` 可读，HEAD 仍为 `c20254a36645493f220461ae016826685e3488fc`。
- `git status --short` 与移动前完全一致；8 个证据文件的 SHA-256 和字节数全部一致。
- 使用 Windows `\\?\` 扩展长度路径递归复核文件总数仍为 4039，且无枚举错误。
- 再次复核主仓锚点与预期差异未变；Craft 仍为 `c7cf805d03e80361f791ab1a60c43827a5105404`、无 remote、工作树干净。

## 风险 / 未决事项

- 归档名称使少量深层 `.git` checkpoint 和 Flutter 构建缓存路径超过传统 Win32 路径长度；普通递归工具可能误报路径缺失，应使用支持长路径的工具或 `\\?\` 前缀读取。
- 归档仍保留 4 个未提交文档修改和未跟踪 `.codex/`，这是移动前原状而非隔离造成；不得在归档内继续开发或清理。
- 归档仍占用本机磁盘且不是远端备份；其用途仅为可逆保留旧资料。

## 下一接手点

由新鲜 QA Inspector 只读复核源路径缺失、归档路径存在、HEAD/status/4039 文件/8 项 SHA-256 与清单一致，并确认主仓与 Craft 未受影响。若需恢复，只能在原路径不存在时，将归档目录用 `Move-Item -LiteralPath` 原样重命名回旧路径；QA 通过前禁止删除、压缩、提交或修改归档内容。

## 维护信息

- 最近更新时间：2026-08-11
- 当前负责人：Repo-Beta

## 更新记录

- 2026-08-11：复核主仓与 Craft 恢复锚点健康，校验源/目标严格位于指定父目录内。
- 2026-08-11：记录旧副本 HEAD、status、4039 文件与 8 项 SHA-256 后，使用精确 `Move-Item -LiteralPath` 完成同父目录可逆重命名。
- 2026-08-11：移动后核对旧路径消失、归档存在，HEAD/status/文件数/哈希保持一致；主仓与 Craft 未变，任务进入 `ready_for_qa`。
