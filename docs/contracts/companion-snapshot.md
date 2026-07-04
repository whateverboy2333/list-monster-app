# CompanionSnapshot v0.1.3

PC 桌宠与 Android Widget 只能读取统一 `CompanionSnapshot`，不得直接计算任务、XP、Streak 或怪兽状态。

## 技术边界

1. PC 桌宠 MVP 采用主 App 第二窗口形态，类似 Codex floating overlay。
2. PC 桌宠只保留打开 / 关闭两个状态。
3. Android Widget 技术路线优先采用 Glance。
4. Android Widget P0 不做持续动画，不做组件内勾选任务，只展示状态帧和点击回 App。

## Snapshot 字段

| 字段 | 类型 | 说明 |
|---|---|---|
| `schemaVersion` | string | 快照 schema 版本 |
| `snapshotId` | string | 快照 ID |
| `userId` | string | 用户 ID |
| `generatedAt` | datetime | 生成时间 |
| `isStale` | boolean | 是否过期 |
| `staleAfterSeconds` | number | P0 固定 300；超过后外部场域应刷新或显示保守文案 |
| `timezoneId` | string | 用户本地时区，IANA ID，例如 `Asia/Shanghai` |
| `monsterId` | string | 怪兽 ID |
| `monsterName` | string | 怪兽名 |
| `styleLine` | enum | `cool` / `soft` / `neutral` |
| `stage` | enum | `egg` / `child` / `teen` / `adult` |
| `level` | number | 等级 |
| `xpProgressPercent` | number | 当前等级进度 |
| `moodState` | enum | `idle` / `energetic` / `expecting` / `sleeping` / `missing` |
| `actionKey` | string | 当前推荐动作 |
| `spriteAssetId` | string | 状态帧或 sprite key |
| `widgetFrameAssetId` | string | Android Widget 可直接渲染的静态状态帧 |
| `lineText` | string | 当前台词 |
| `todayCompletedTasks` | number | 今日完成任务数 |
| `todayTotalTasks` | number | 今日任务总数 |
| `todayRemainingTasks` | number | 今日剩余任务数 |
| `todayTaskMilestoneKey` | string? | `small_start` / `fruitful_day` |
| `todayTaskMilestoneTitle` | string? | 例如“小试身手” / “收获满满” |
| `previousDaySummaryDate` | date? | 前日反馈对应日期 |
| `previousDayCompletedEligibleTasks` | number? | 前日可奖励完成数，来自 `DailyTaskSummary.rewardableCompletedCount` |
| `previousDayFeedbackTitle` | string? | 前日正向反馈标题 |
| `previousDayFeedbackText` | string? | 前日正向反馈文案 |
| `currentStreakDays` | number | 当前 Streak |
| `bestStreakDays` | number | 历史最佳 |
| `desktopPetState` | enum | `on` / `off` |
| `dndActive` | boolean | 当前是否处于勿扰时段 |
| `hideTaskTitlesOutsideApp` | boolean | 外部场域是否隐藏任务标题 |

## 刷新触发

1. 任务创建 / 完成 / 撤销 / 恢复。
2. XP 发放 / 等级变化 / 怪兽状态变化。
3. 今日任务激励触发。
4. Streak 更新或 `streak_break`。
5. 桌宠打开 / 关闭。
6. 通知提醒到达。

## 禁止

Widget 不得发出任务完成、XP、Streak、怪兽状态变更类事件；只能点击回 App。
