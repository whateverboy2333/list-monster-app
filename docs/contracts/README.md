# 清单怪兽契约基线 v0.1.3

状态：v0.1.3 已冻结，作为节点 2“工程骨架 + 初始 commit”的输入基线。`AG-CONTRACT-01` 与 `AG-QA-01` 复审均无阻塞项。

来源：

1. 产品 PRD：`C:\Users\huawei\Desktop\清单怪兽_产品设计文档_PRD_v1.0.md`
2. PM 决策表：`docs/pm/pm-decisions.md`
3. Wave 0 控制面板：`docs/pm/wave-0-control-board.md`

## 命名规则

1. 事件名使用 `snake_case`。
2. 字段名使用 `lowerCamelCase`。
3. 所有跨模块事件必须包含：`eventId`、`userId`、`occurredAt`、`source`。
4. 子 Agent 不得私自新增、改名、删除契约字段；必须经 `AG-PM-00` 裁决。
5. JSON / API / 埋点枚举值统一使用 `snake_case`；客户端内部类型可自行映射。

## 当前契约文件

| 文件 | 内容 |
|---|---|
| `domain-model.md` | 任务、长期任务、XP ledger、怪兽、用户、提醒、同步等核心模型 |
| `events.md` | 跨模块事件及 payload |
| `xp-rules.md` | XP、Streak、今日任务激励、累计奖励规则 |
| `companion-snapshot.md` | PC 桌宠与 Android Widget 统一只读快照 |
| `analytics.md` | MVP 埋点事件 |
| `assets.md` | 怪兽 sprite、动作、音效、资源命名 |

## 已废弃旧口径

`daily_clear` / 今日通关 不进入正式契约。MVP 改为“今日任务激励”：

1. 当日完成 3 次任务：提示“小试身手”。
2. 当日完成 6 次任务：提示“收获满满”。
3. 第二天打开 App：反馈前一天完成情况。
4. 累计完成超过 3 天：第 4 个活跃日一次性给予 +20 XP，计入每日正式 XP 上限。
