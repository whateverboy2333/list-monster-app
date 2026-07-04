# Analytics v0.1.3

## 事件命名

埋点事件使用 `snake_case`，应与业务事件尽量同名。

## MVP 埋点

| 事件 | 用途 |
|---|---|
| `onboarding_step_viewed` | 引导步骤曝光 |
| `gender_preference_selected` | 性别偏好选择 |
| `monster_hatched` | 怪兽孵化 |
| `task_created` | 任务创建 |
| `task_completed` | 任务完成 |
| `task_completion_undone` | 完成撤销 |
| `task_cancelled` | 任务放下 / 取消 |
| `task_deleted` | 任务软删除 |
| `task_restored` | 任务恢复 |
| `task_rescheduled` | 任务改期 |
| `batch_cleanup_applied` | 无压清理批量操作 |
| `longterm_created` | 长期任务创建 |
| `longterm_achieved` | 长期任务达成 |
| `longterm_cancelled` | 长期任务取消 |
| `daily_task_milestone` | 今日任务激励达成 |
| `daily_task_summary` | 前日完成反馈 |
| `cumulative_active_reward` | 累计完成奖励 |
| `xp_granted` | XP 发放 |
| `xp_reverted` | XP 冲正 |
| `level_up` | 升级 |
| `streak_updated` | Streak 更新 |
| `streak_break` | Streak 中断，内部分析用 |
| `monster_pet_reacted` | 怪兽抚摸反应 |
| `monster_state_changed` | 怪兽状态变化 |
| `notification_open` | 通知点击 |
| `desktop_pet_on` | 桌宠打开 |
| `desktop_pet_off` | 桌宠关闭 |
| `widget_added` | Android Widget 添加 |

## 禁止项

1. 不记录惩罚型 `streak_break` 文案曝光，因为产品不得惩罚用户。
2. 不使用 `daily_clear`。
3. 不使用 `desktop_pet_toggle`。

## 事件映射

`monster_pet_reacted` 同时作为业务事件与埋点事件使用，避免怪兽系统和埋点系统命名分叉。
