# Domain Model v0.1.3

## 通用字段

所有可同步实体建议包含：

| 字段 | 含义 |
|---|---|
| `createdAt` | 本地创建时间，ISO datetime |
| `updatedAt` | 本地最后更新时间，ISO datetime |
| `revision` | 本地递增版本号 |
| `sourceDeviceId` | 操作来源设备 |
| `deletedAt` | 软删除 / tombstone 时间，默认 null；物理删除只用于账号注销或数据清理 |

## User

| 字段 | 类型 | 说明 |
|---|---|---|
| `userId` | string | 用户 ID，游客也有本地 ID |
| `accountMode` | enum | `guest` / `registered` |
| `loginProvider` | enum | `none` / `phone` / `wechat` |
| `genderPreference` | enum | `male` / `female` / `other` / `undisclosed` / `cleared` |
| `styleLine` | enum | `cool` / `soft` / `neutral` |
| `timezoneId` | string | 用户本地时区，IANA ID，例如 `Asia/Shanghai` |
| `notificationEnabled` | boolean | 通知是否开启 |
| `dndEnabled` | boolean | App 内勿扰是否开启 |
| `dndStartTime` | string | 勿扰开始时间，例如 `23:00` |
| `dndEndTime` | string | 勿扰结束时间，例如 `07:00` |
| `dndAllowPriorityOverride` | boolean | 是否允许高优先级提醒穿透勿扰；MVP 默认 false |
| `guestMergePending` | boolean | 是否存在待确认游客数据合并 |
| `guestMergeConfirmedAt` | datetime? | 游客合并确认时间 |
| `accountDeletionStatus` | enum | `active` / `deletion_pending` / `deleted` / `deletion_cancelled` |
| `accountDeletionRequestedAt` | datetime? | 注销申请时间 |
| `accountDeletionEffectiveAt` | datetime? | 15 天冷静期后的生效时间 |
| `accountDeletionCancelledAt` | datetime? | 取消注销时间 |

## Task

`Task` 是今日列表和 XP 的基础单位。长期任务每日拆解项也使用 `Task` 表示。

| 字段 | 类型 | 说明 |
|---|---|---|
| `taskId` | string | 任务 ID |
| `userId` | string | 所属用户 |
| `title` | string | 标题，必填 |
| `note` | string? | 备注 |
| `listId` | string | 所属持久清单，例如收集箱或自建清单 |
| `taskType` | enum | `normal` / `long_term_child` |
| `status` | enum | `active` / `completed` / `cancelled` / `deleted` |
| `priority` | enum | `high` / `medium` / `none` |
| `scheduledDate` | date | 所属日期；无日期输入时默认为今天 |
| `dateSource` | enum | `default_today` / `user_selected` / `longterm_generated` / `natural_language` |
| `dueTime` | string? | 任务时间 |
| `reminderId` | string? | 提醒配置 ID |
| `repeatRuleId` | string? | 重复规则 ID |
| `parentLongTermTaskId` | string? | 长期任务父级 ID |
| `rewardEligible` | boolean | 是否可产生 XP |
| `sortOrder` | number | 排序 |
| `completedAt` | datetime? | 完成时间 |
| `completionSource` | enum? | `user_action` / `onboarding_auto` / `sync_replay` |
| `cancelledAt` | datetime? | 放下 / 取消时间 |
| `restoredAt` | datetime? | 恢复时间 |

规则：

1. 普通任务默认 `rewardEligible = true`。
2. 长期任务每日拆解项 `taskType = long_term_child`，且 `rewardEligible = true`。
3. 取消 / 放下不是完成，不产生 XP。

## SubTask

`SubTask` 独立建模，但 MVP 普通任务 checklist 子项属于 P1，默认不产生 XP。

| 字段 | 类型 | 说明 |
|---|---|---|
| `subTaskId` | string | 子任务 ID |
| `parentTaskId` | string | 所属普通任务 |
| `title` | string | 标题 |
| `status` | enum | `active` / `completed` / `cancelled` |
| `sortOrder` | number | 排序 |
| `rewardEligible` | boolean | 默认 false |
| `createdAt` | datetime | 创建时间 |
| `updatedAt` | datetime | 更新时间 |
| `completedAt` | datetime? | 完成时间 |
| `cancelledAt` | datetime? | 取消时间 |

## LongTermTask

长期任务是跨天目标容器，不能被直接完成。

| 字段 | 类型 | 说明 |
|---|---|---|
| `longTermTaskId` | string | 长期任务 ID |
| `userId` | string | 所属用户 |
| `title` | string | 名称 |
| `startDate` | date | 开始日 |
| `dueDate` | date | 截止日，必须晚于 `startDate` |
| `status` | enum | `active` / `achieved` / `cancelled` / `deleted` |
| `totalTaskCount` | number | 拆解任务总数 |
| `completedTaskCount` | number | 已完成拆解任务数 |
| `progress` | number | 0-1 |
| `achievedAt` | datetime? | 达成时间 |
| `cancelledAt` | datetime? | 放下 / 取消时间 |

规则：

1. `achieved` 只能由拆解 `Task` 进度汇总触发。
2. `cancelled` 不产生 XP，不触发长期任务达成奖励。

## TaskList

| 字段 | 类型 | 说明 |
|---|---|---|
| `listId` | string | 清单 ID |
| `userId` | string | 所属用户 |
| `listType` | enum | `inbox` / `custom` |
| `name` | string | 清单名 |
| `color` | string | 颜色 token |
| `icon` | string | 图标 key |
| `sortOrder` | number | 排序 |
| `isSystem` | boolean | 是否系统清单 |

## SmartTaskView

`today` 与 `next_7_days` 是智能视图，不是普通任务可归属的持久清单。

| 字段 | 类型 | 说明 |
|---|---|---|
| `viewKey` | enum | `today` / `next_7_days` |
| `filterRule` | string | 派生过滤规则 |

## Monster

| 字段 | 类型 | 说明 |
|---|---|---|
| `monsterId` | string | 怪兽 ID |
| `userId` | string | 所属用户 |
| `name` | string | 默认“小单” |
| `styleLine` | enum | `cool` / `soft` / `neutral` |
| `stage` | enum | `egg` / `child` / `teen` / `adult` |
| `level` | number | 等级 |
| `lifetimeXp` | number | 累计经验 |
| `currentLevelXp` | number | 当前等级经验 |
| `xpToNextLevel` | number | 升级所需经验 |
| `moodState` | enum | `idle` / `energetic` / `expecting` / `sleeping` / `missing` |
| `currentAction` | string | 当前短动作 |
| `lastInteractionAt` | datetime? | 最近互动时间 |
| `sleepPetCount` | number | 当前睡眠窗口内抚摸次数 |
| `sleepPetWindowStartedAt` | datetime? | 睡眠抚摸计数窗口开始时间 |
| `wakeUpThreshold` | number | MVP 固定为 3 |
| `lastWakeUpAt` | datetime? | 最近被唤醒时间 |

## XpLedger

`XpLedger` 是 XP 的唯一账本来源，采用追加写入，不直接删除原记录。

| 字段 | 类型 | 说明 |
|---|---|---|
| `xpLedgerId` | string | XP 账本记录 ID |
| `userId` | string | 用户 ID |
| `sourceEventId` | string | 来源事件 ID；正向 XP 用于幂等去重 |
| `sourceType` | enum | `task_completed` / `longterm_achieved` / `cumulative_active_reward` / `xp_reverted` |
| `originalXpLedgerId` | string? | 冲正时关联的原始正向 XP 记录 |
| `amount` | number | XP 变动值；正向发放为正数，冲正为负数 |
| `localDate` | date | XP 归属的用户本地日期 |
| `timezoneId` | string | IANA 时区 ID |
| `dailyCapApplied` | boolean | 是否受每日正式 XP 上限影响 |
| `dailyTotalAfterGrant` | number | 本地日正式 XP 发放后的累计值；冲正时为冲正后的累计值 |
| `reason` | string? | 冲正或特殊发放原因 |
| `createdAt` | datetime | 账本记录创建时间 |

规则：

1. `XpLedger` 只追加，不删除原始正向记录。
2. 同一正向 `sourceEventId` 只能产生一条有效正向 XP 记录。
3. `xp_reverted` 必须写入新的负数账本记录，并通过 `originalXpLedgerId` 指向原记录。
4. 累计活跃第 4 天 +20 计入每日正式 XP 上限；长期任务整体达成 +50 不占每日上限。

## Streak

| 字段 | 类型 | 说明 |
|---|---|---|
| `userId` | string | 用户 ID |
| `currentStreakDays` | number | 当前连续完成任务天数 |
| `bestStreakDays` | number | 历史最佳 |
| `lastActiveDate` | date | 最近活跃日 |
| `timezoneId` | string | 用户本地时区，IANA ID，例如 `Asia/Shanghai` |

## DailyTaskSummary

第二天打开 App 时读取的前日完成反馈读模型。

| 字段 | 类型 | 说明 |
|---|---|---|
| `userId` | string | 用户 ID |
| `summaryForDate` | date | 被总结的本地日期 |
| `timezoneId` | string | IANA 时区 ID |
| `rewardableCompletedCount` | number | 可奖励任务完成数 |
| `todayTaskCompletedCount` | number | 当日计划任务完成数 |
| `completedTaskIds` | string[] | 完成任务 ID |
| `longTermChildCompletedCount` | number | 长期任务拆解项完成数 |
| `cancelledCount` | number | 放下 / 取消数 |
| `restoredCount` | number | 恢复数 |
| `firstCompletedAt` | datetime? | 首次完成时间 |
| `lastCompletedAt` | datetime? | 最后完成时间 |
| `summaryShownAt` | datetime? | 反馈展示时间 |

## Reminder

| 字段 | 类型 | 说明 |
|---|---|---|
| `reminderId` | string | 提醒 ID |
| `taskId` | string | 任务 ID |
| `scheduledAt` | datetime | 计划提醒时间 |
| `offsetMinutes` | number | 提前提醒分钟数 |
| `status` | enum | `scheduled` / `sent` / `snoozed` / `cancelled` |
| `snoozeUntil` | datetime? | 稍后提醒时间 |
| `plannedAt` | datetime | 原计划提醒时间 |
| `deliverAt` | datetime | 实际计划触达时间 |
| `respectDnd` | boolean | 是否遵守 App 勿扰；MVP 默认 true |
| `suppressedByDnd` | boolean | 是否因勿扰被抑制 |
| `dndDeferredFrom` | datetime? | 因勿扰延后前时间 |
| `dndDeferredTo` | datetime? | 因勿扰延后后时间 |

## GuestMergeJob

登录后游客数据与已有云端数据合并必须由用户确认。

| 字段 | 类型 | 说明 |
|---|---|---|
| `mergeJobId` | string | 合并任务 ID |
| `sourceGuestUserId` | string | 本地游客 ID |
| `targetUserId` | string | 注册账号 ID |
| `cloudHasExistingData` | boolean | 云端是否已有数据 |
| `mergeStatus` | enum | `pending_confirmation` / `confirmed` / `merged` / `cancelled` / `failed` |
| `mergeConfirmedAt` | datetime? | 用户确认时间 |
| `createdAt` | datetime | 创建时间 |
| `updatedAt` | datetime | 更新时间 |

## SyncQueueItem

| 字段 | 类型 | 说明 |
|---|---|---|
| `operationId` | string | 同步操作 ID |
| `entityType` | string | 实体类型 |
| `entityId` | string | 实体 ID |
| `eventId` | string | 关联事件 ID，任务生命周期操作必填 |
| `operationType` | enum | `task_complete` / `task_cancel` / `task_restore` / `task_delete` / `task_undo_completion` / `longterm_achieve` / `longterm_cancel` |
| `payload` | object | 变更内容 |
| `dedupeKey` | string | 幂等键 |
| `baseRevision` | number | 操作基于的实体版本 |
| `status` | enum | `pending` / `syncing` / `synced` / `failed` |
| `attemptCount` | number | 重试次数 |
| `lastError` | string? | 最近错误 |
| `createdAt` | datetime | 入队时间 |
| `syncedAt` | datetime? | 同步时间 |
