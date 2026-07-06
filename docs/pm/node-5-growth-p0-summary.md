# 节点 5 怪兽养成与激励 P0 交付摘要

日期：2026-07-05

分支：`codex/node5-growth-p0`

状态：已实现，经历一次 QA 返工后通过 `QA-N5-002` 复检，进入 PM 验收收口。

## 冻结目标

节点 5 目标是把怪兽养成与激励 P0 做稳定。

冻结范围：

```text
XP 计算
每日上限
高优先级 +15 替代 +10
Streak
streak_break
今日任务激励
前日完成反馈
累计 3 天奖励
睡觉 / 想念 / 期待 / 元气状态机
抚摸与多次唤醒
```

关键验收保持不变：

1. 所有成长都来自真实任务行为。
2. 抚摸、打开 App、教学自动完成不产生正式 XP。
3. `streak_break` 只做内部事件，不惩罚、不羞辱、不扣 XP。
4. 不恢复 `daily_clear` / 今日通关旧口径。

## Agent 团队与审核收敛

1. `AG-MONSTER-01`：主导 XP ledger、Streak、怪兽状态机、睡眠抚摸唤醒规则审核。
2. `AG-TASK-01`：审核任务事件到 XP / Streak 的边界，要求 `sourceEventId` 幂等与撤销冲正。
3. `AG-CLIENT-01`：审核 Today / Monster 最小 UI 承载，要求不做重动画，先可测。
4. `AG-PROD-01`：审核激励体验口径，要求前日反馈、Streak、睡眠互动保持正向无压力。
5. `AG-QA-01`：输出节点 5 QA 矩阵，要求防回归覆盖非真实行为刷 XP。
6. `AG-CONTRACT-01`：确认 v0.1.3 契约足够支撑节点 5，无需新增正式事件或字段。

PM 裁决：

1. 每日正式 XP 上限按契约固定为 125。
2. 累计第 4 个活跃日发放 `cumulative_active_reward +20 XP`，计入每日 125 上限。
3. 长期任务整体达成 `longterm_achieved +50 XP`，不占每日上限，且每个长期任务只发一次。
4. `xp_reverted.sourceEventId` 绑定 `task_completion_undone.eventId`，并通过 `originalXpLedgerId` 防重复冲正。
5. 睡眠时第 1-2 次抚摸不打断睡眠；第 3 次触发 `wake_up`，全程不产 XP。

## 本次交付

1. `monster_domain` 新增节点 5 模型与事件：`StreakSnapshot`、`StreakUpdatedEvent`、`StreakBreakEvent`、`DailyTaskSummary`、`CumulativeActiveRewardEvent`、`MonsterPetReactionEvent`。
2. `XpPolicy` 补齐每日 125 上限、累计活跃奖励阈值与长期任务达成奖励常量。
3. `MonsterSnapshot` 补齐 `currentAction`、`sleepPetCount`、`wakeUpThreshold`，支撑睡眠抚摸和动作承载。
4. `TaskSystemController` 统一 XP 发放入口 `_grantXp`，按 `sourceEventId` 幂等去重并裁剪每日上限。
5. 完成撤销生成负数 `xp_reverted`，原 XP ledger 保留，不删除历史记录；payload 带齐 `originalXpLedgerId`、`revertedAt`、`reason`。
6. Streak 按本地日期活跃日更新；跨日缺口生成内部 `streak_break`。
7. 第二天打开 App 可生成前日 `daily_task_summary`，只做正向反馈，不发 XP。
8. 累计第 4 个活跃日触发累计奖励并写入 XP ledger。
9. 长期任务汇总达成后发放 +50 XP，且不计入今日正式 XP 上限。
10. 升级时追加 `level_up` 事件；XP 总额重建支持跨级，不让 `currentLevelXp` 超过当前等级上限。
11. `daily_task_milestone.actionKey` 使用资产契约中的 `task_milestone`，具体 3 / 6 次差异由 `milestoneKey` 表达。
12. Monster 页新增抚摸入口；睡眠态前两次保持睡眠，第 3 次唤醒。
13. Today 页新增高优先级新任务开关、Streak / 今日 XP 上限承载、前日反馈和累计奖励卡。

## 明确未纳入节点 5

以下内容继续后置，避免范围蔓延：

1. 云同步、游客合并、登录、账号注销。
2. 系统通知调度、勿扰穿透、通知点击回流。
3. PC 第二窗口桌宠、Android Glance Widget、CompanionSnapshot 消费链路。
4. 复杂动画资产、装扮、成就系统、分支进化。
5. AI 拆解、自然语言任务创建、P1 子任务 checklist。

## 验证记录

已通过：

```text
dart test                              # packages/monster_domain
flutter test                           # apps/list_monster_app
dart analyze .                         # apps/list_monster_app
dart analyze                           # packages/monster_domain
```

补充说明：

`flutter analyze` 在本机两次触发 Flutter analysis server 的 LSP JSON 读取崩溃；同一 App 使用 `dart analyze .` 无问题。返工复检中，`flutter test` 已完成 33 个 widget/controller 测试。

QA 收口：

1. `QA-N5-001` 裁决 fail，阻塞项为前日摘要未接入真实打开流程、`flutter test` 失败 1 项、节点 5 防回归测试覆盖不足。
2. `FE-N5-001` 完成返工。
3. `QA-N5-002` 裁决 pass，确认启动摘要、前日 0 完成静默、XP 去重 / 冲正 / 引导规则均已覆盖，测试与 analyze 全绿。

## 节点 5 判定

节点 5：怪兽养成与激励 P0 已达到当前冻结实现口径，QA 复检通过，PM 验收通过。
