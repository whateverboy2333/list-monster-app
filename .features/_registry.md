---
status: live
type: reference
module: task-handoff
last_updated: 2026-08-11
owner: team
---

# 任务交接记录注册表

本目录保存任务级改动与接手记录，不替代全局看板。本页直接给出执行所需的完整字段、状态与更新规则；[AGENTS.md](../AGENTS.md) 是上位协作规则。

## 协议摘要

1. `PROJECT_BOARD.md` 是唯一当前全局任务与 QA 裁决看板；仅 PM 修改。
2. 每个实现任务使用独立 `.features/{任务ID}/status.md`；仅该任务实现 Agent 修改。
3. 任务卡必须把实现文件和本任务记录同时列入允许修改范围；并行任务不得共享记录。
4. QA Inspector 只读，不写本目录；返工由原实现 Agent 续写原任务记录。
5. 任务记录中的最新事实覆盖当前区块，验证证据和更新记录按轮次追加保留。

## 任务状态枚举

| 状态 | 语义 |
|---|---|
| `in_progress` | 实现 Agent 正在实施或补充自测 |
| `ready_for_qa` | 实现和自测完成，等待独立 QA |
| `blocked` | 存在无法由实现 Agent 自行解除的阻塞，等待 PM、用户或外部条件 |
| `rework` | QA 未通过，原实现 Agent 正在同一任务记录中返工 |
| `completed` | QA 已通过，且 PM 已明确要求原实现 Agent 收口记录 |
| `cancelled` | PM 已取消任务，不再继续实施 |

Frontmatter 的 `status` 只表示文档生命周期；任务执行状态必须在正文“当前状态”中使用上述枚举，两者不得混用。

## `status.md` 必填字段

| 区块 | 必填内容 |
|---|---|
| Frontmatter | `status`、`type`、`module`、`last_updated`；建议补 `owner` |
| 任务身份 | 任务 ID、目标、依赖、记录路径 |
| 当前状态 | 状态枚举中的一个值 |
| 变更文件 | 本任务本轮实际修改、创建或删除的完整路径 |
| 行为变化 | 用户、运行时或协作流程可观察变化；无则明确写“无” |
| 验证证据 | 检查动作、结果和可复核证据路径 |
| 风险 / 未决事项 | 已知风险、阻塞及待裁决事项 |
| 下一接手点 | 下一位 Agent 的首个动作、前置条件和禁止触碰边界 |
| 维护信息 | 最近更新时间和当前负责人 |
| 更新记录 | 每轮实现或返工的时间与摘要 |

## 追加与覆盖规则

1. 首次创建时完整填写全部区块；任务身份创建后保持稳定，只在纠正事实错误时修改。
2. 当前状态、变更文件、行为变化、风险、下一接手点、维护时间和负责人覆盖为本轮最新事实。
3. 验证证据与更新记录按轮次追加，保留首轮及所有返工历史，不删除旧证据。
4. QA Inspector 始终只读，只输出裁决；PM 只把全局状态和 QA 裁决写入 `PROJECT_BOARD.md`。
5. QA 失败后，原实现 Agent 将同一记录状态改为 `rework` 并续写；返工自测完成后再改为 `ready_for_qa`。QA 通过后，仅在 PM 明确下发收口指令时由原实现 Agent 改为 `completed`。
6. 并行任务不得共享同一 `status.md`，也不得修改其他任务记录。

## 任务索引

| 任务 ID | 任务记录 | 负责人 | 当前状态 | 最近更新 |
|---|---|---|---|---|
| T-DOC-HANDOFF-004 | [status.md](T-DOC-HANDOFF-004/status.md) | DOC-Alpha | `completed` | 2026-08-09 |
| T-CRAFT-SAVE-001 | [status.md](T-CRAFT-SAVE-001/status.md) | FE-Gamma | `completed` | 2026-08-10 |
| BF-0810-1 | [status.md](BF-0810-1/status.md) | FE-Gamma | `ready_for_qa`（R1 QA通过，待用户验收） | 2026-08-10 |
| T-DOC-CONTENT-005 | [status.md](T-DOC-CONTENT-005/status.md) | DOC-Alpha | `completed` | 2026-08-11 |
| T-REPO-SAFETY-001 | [status.md](T-REPO-SAFETY-001/status.md) | Repo-Beta | `completed` | 2026-08-11 |

可复制指令：把改动更新到 `.features/<任务ID>/status.md`，按 `AGENTS.md` 模板记录改动、验证、风险和下一接手点。
