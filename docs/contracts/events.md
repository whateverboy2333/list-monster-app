# Events v0.1.3

## 通用 Envelope

所有事件必须包含：

| 字段 | 类型 | 说明 |
|---|---|---|
| `eventId` | string | 全局唯一事件 ID |
| `eventName` | string | snake_case 事件名 |
| `userId` | string | 用户 ID |
| `occurredAt` | datetime | 事件发生时间 |
| `source` | enum | `android_app` / `pc_app` / `desktop_pet` / `widget` / `notification` / `system` |
| `payload` | object | 事件内容 |

## 任务事件

### task_created

必填 payload：

`taskId`、`title`、`taskType`、`listId`、`scheduledDate`、`dateSource`、`priority`、`rewardEligible`。

### task_completed

必填 payload：

`taskId`、`taskType`、`completedAt`、`completedLocalDate`、`timezoneId`、`priority`、`scheduledDate`、`parentLongTermTaskId`、`rewardEligible`、`completionSource`、`completionOrderOfDay`、`dailyRewardableCountAfter`、`dailyTodayTaskCountAfter`、`thresholdCrossed`。

规则：

1. 只有 `rewardEligible = true` 的 `task_completed` 可进入 XP 计算。
2. 同一 `eventId` 不得重复发放 XP。

### task_completion_undone

必填 payload：

`taskId`、`undoneAt`、`previousCompletedAt`、`originalCompletedEventId`、`thresholdReverted`。

### task_cancelled

用于普通任务或长期任务拆解任务的“放下 / 取消”。

必填 payload：

`taskId`、`cancelledAt`、`cancelReason`。

规则：不产生 XP，不触发负面反馈。

### task_deleted

用于软删除 / tombstone。账号注销或数据清理后的物理删除不走普通任务恢复流。

必填 payload：

`taskId`、`deletedAt`、`deleteReason`、`previousStatus`。

### task_restored

用于删除 / 放下后的撤销恢复、未来回收站恢复、同步 tombstone 恢复。

必填 payload：

`taskId`、`restoredAt`、`restoreReason`、`restoredFromEventId`、`previousStatus`、`restoredStatus`、`previousDeletedAt`、`previousCancelledAt`、`scheduledDate`、`dateSource`。

规则：不产生 XP。

### task_rescheduled

必填 payload：

`taskId`、`fromScheduledDate`、`toScheduledDate`、`fromDueTime`、`toDueTime`、`rescheduledAt`。

### batch_cleanup_applied

用于无压清理批量操作摘要。

必填 payload：

`batchId`、`action`、`affectedTaskIds`、`affectedCount`、`appliedAt`。

`action` 取值：`let_go` / `move_today` / `move_inbox`。

## 长期任务事件

### longterm_created

必填 payload：

`longTermTaskId`、`title`、`startDate`、`dueDate`。

### longterm_child_task_generated

必填 payload：

`longTermTaskId`、`taskId`、`scheduledDate`、`rewardEligible`。

### longterm_progress_changed

必填 payload：

`longTermTaskId`、`completedTaskCount`、`totalTaskCount`、`progress`。

### longterm_achieved

必填 payload：

`longTermTaskId`、`achievedAt`、`completedTaskCount`、`totalTaskCount`、`sourceCompletedTaskIds`。

规则：只能由拆解任务进度汇总触发。

### longterm_cancelled

必填 payload：

`longTermTaskId`、`cancelledAt`、`cancelReason`。

规则：不产生 XP，不触发长期任务达成奖励。

## 激励与成长事件

### xp_granted

必填 payload：

`xpLedgerId`、`sourceEventId`、`sourceType`、`amount`、`dailyTotalAfterGrant`、`dailyCapApplied`。

### xp_reverted

用于完成撤销后的 XP 冲正。

必填 payload：

`xpLedgerId`、`originalXpLedgerId`、`sourceEventId`、`amount`、`revertedAt`、`reason`。

规则：`amount` 必须为负数；原始正向 XP 保留在 `originalXpLedgerId` 对应 ledger 中，不删除原记录。

### level_up

必填 payload：

`monsterId`、`fromLevel`、`toLevel`、`occurredAt`。

### daily_task_milestone

当日完成任务数达到激励阈值。

必填 payload：

`localDate`、`timezoneId`、`completedEligibleTaskCount`、`milestoneKey`、`title`、`actionKey`。

当前阈值：

| `completedEligibleTaskCount` | `milestoneKey` | `title` |
|---|---|---|
| 3 | `small_start` | 小试身手 |
| 6 | `fruitful_day` | 收获满满 |

### daily_task_summary

第二天打开 App 时，对前一天完成情况做正向反馈。

必填 payload：

`summaryForDate`、`timezoneId`、`completedEligibleTaskCount`、`createdTaskCount`、`feedbackText`。

### cumulative_active_reward

累计完成超过 3 天时发放累计奖励。

必填 payload：

`activeDayCount`、`rewardThreshold`、`xpAmount`、`rewardReason`。

MVP 固定：`rewardThreshold = 4`，`xpAmount = 20`。

规则：该 +20 XP 计入每日正式 XP 上限；只有长期任务整体达成 +50 不占每日上限。

### streak_updated

必填 payload：

`localDate`、`currentStreakDays`、`bestStreakDays`、`timezoneId`。

### streak_break

内部事件，用于记录连续天数中断。

必填 payload：

`missedLocalDate`、`previousStreakDays`、`bestStreakDays`、`timezoneId`、`reason`。

规则：不触发惩罚、羞辱、扣 XP 或怪兽负面状态。

## 怪兽事件

### monster_state_changed

必填 payload：

`monsterId`、`fromMoodState`、`toMoodState`、`reason`。

### monster_action_requested

必填 payload：

`monsterId`、`actionKey`、`reason`、`expiresAt`。

### monster_pet_reacted

必填 payload：

`monsterId`、`reactionKey`、`touchCountInSleep`、`interactedAt`。

## 陪伴场域事件

### desktop_pet_on

必填 payload：

`enabledAt`、`platform`。

### desktop_pet_off

必填 payload：

`disabledAt`、`platform`。

### widget_added

必填 payload：

`widgetId`、`platform`、`widgetSize`、`addedAt`。

## 通知事件

### notification_open

必填 payload：

`notificationId`、`reminderId`、`taskId`、`openedAt`、`action`。

### notification_scheduled

必填 payload：

`notificationId`、`reminderId`、`taskId`、`plannedAt`、`deliverAt`、`respectDnd`。

### notification_sent

必填 payload：

`notificationId`、`reminderId`、`taskId`、`sentAt`。

### notification_snoozed

必填 payload：

`notificationId`、`reminderId`、`taskId`、`snoozeUntil`。

### notification_cancelled

必填 payload：

`notificationId`、`reminderId`、`taskId`、`cancelledAt`、`reason`。

### notification_suppressed_by_dnd

必填 payload：

`notificationId`、`reminderId`、`taskId`、`plannedAt`、`deferredTo`。

### notification_permission_changed

必填 payload：

`permissionStatus`、`changedAt`、`sourcePage`。
