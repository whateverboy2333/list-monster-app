# 节点 4 任务系统 P0 交付摘要

日期：2026-07-04

分支：`codex/node4-task-system-p0`

状态：已实现并通过本机验证，待 PM 验收与合并确认。

## 冻结目标

节点 4 目标是把清单工具底座做完整。

冻结范围：

```text
快速创建
今日视图
清单分组（底层保留，MVP 用户界面不暴露）
任务完成 / 撤销 / 删除 / 恢复
长期任务拆解
无压清理
重复规则基础能力
提醒意图
```

关键验收保持不变：

1. 取消 / 放下不产生 XP。
2. `task_restored` 能正确恢复任务。
3. 长期任务不能直接完成，只能由拆解任务汇总达成。

## 本次交付

1. `task_domain` 补齐任务生命周期：`task_created`、`task_completed`、`task_completion_undone`、`task_cancelled`、`task_deleted`、`task_restored`、`task_rescheduled`。
2. 补齐 `Task` P0 字段：`listId`、`dueTime`、`reminderId`、`repeatRuleId`、`cancelledAt`、`deletedAt`、`restoredAt`、`completedEventId`。
3. 补齐 `TaskList`、`ReminderIntent`、`BatchCleanupAppliedEvent`、`LongTermTask` 及 `longterm_*` 事件。
4. App 控制器升级为 `TaskSystemController`，保留 `CoreLoopController` 兼容别名。
5. Today 页支持快速创建、完成、撤销完成、放下、删除、提醒意图、重复规则占位。
6. 新任务选项区已明确只作用于下一次新增任务；已有任务行可单独修改重复占位和提醒时间。
7. 用户界面从“清单页”调整为“长期页”；普通任务的无压清理、已放下 / 已删除恢复入口合并到 Today 页。
8. 长期页只承载长期任务创建和长期任务列表，不再展示收集箱 / 生活等文件夹分类。
9. 长期任务创建改为用户自定义：用户填写长期目标、开始日期、截止日期和每日手动拆解项，不再直接创建系统预设“读一本书”，不再限制最多 7 天。
10. 长期任务会生成每日拆解 `Task.long_term_child`；父任务不能直接完成；拆解任务完成汇总后才触发 `longterm_achieved`。
11. 取消 / 放下、删除、恢复不写入 XP ledger；完成撤销通过 `xp_reverted` 冲正，不删除原始 XP 记录。

## 子 Agent 审核收敛

1. `AG-TASK-01`：要求补齐 Task 字段、生命周期事件、长期任务聚合和重复规则占位；已实现并补单测。
2. `AG-CLIENT-01`：要求 List Tab 不再占位，Today/List 能承载撤销、删除、恢复、放下、无压清理、长期任务；已接入 UI 与 widget test。
3. `AG-QA-01`：要求防回归项覆盖取消不产 XP、恢复不产 XP、长期任务不能直接完成；已加入 controller / domain 测试。
4. `AG-PROD-01`：要求无压清理避免惩罚感、提醒只记录意图、不进入真实通知调度；已按“放下 / 无压清理 / 提醒意图”口径处理。

## PM 反馈修正

1. 重复占位不再只存在于新增任务表单；已创建任务可在任务行切换为重复占位任务。
2. 提醒意图不再固定为“今晚 20:00”；新增任务和已有任务都支持输入本地提醒时间。
3. Today 页将这两项统一收敛到“新任务选项”，并在任务行提供对应编辑入口，避免用户误解为全局设置。
4. 取消文件夹分类心智：底部导航由“清单”改为“长期”，Today 页成为普通任务工作台，长期页只保留长期任务能力。
5. `listId` / `TaskList` 暂时作为底层契约保留，但 MVP 用户界面不再展示 `inbox`、`custom`、收集箱、生活等分类。
6. 长期任务拆解分为两条路线：当前节点只实现手动拆解；AI 拆解作为后续路线预留，不在节点 4 接入 API。
7. 长期任务创建口径再次收紧：手动路线必须提供用户填写的每日拆解项；仅输入标题不会创建长期任务或生成默认拆解。
8. 长期任务弹窗增加拆解路线和按阶段提示；提示只辅助用户思考，不预填系统任务，避免再次出现“读一本书”式预设任务。
9. 经 `AG-PROD-01`、`AG-TASK-01`、`AG-CLIENT-01`、`AG-QA-01` 复审，domain 层默认拆解 fallback 已移除；长期拆解必须来自用户确认的每日标题。
10. 长期任务日期改为用户自定义：创建和编辑时通过日期选择器选择开始日期 / 截止日期，可修改日期范围和拆解标题。
11. 缩短长期任务日期范围时，不能排除已完成拆解项；若会排除未完成拆解项，必须显式确认，确认后这些未完成项会被放下且不产生 XP。
12. App 增加 `中 / EN` 全局语言切换；默认中文，切换后任务系统 P0 页面文案与长期任务日期选择器跟随语言变化。
13. 语言选择在 Web 预览中写入本地 `localStorage`，不接账号同步，不进入节点 6 的用户偏好云端合并范围。

## 明确未纳入节点 4

以下内容继续后置，避免节点 4 范围蔓延：

1. 云同步、登录、游客合并、同步冲突重放。
2. 真实系统通知调度、通知权限、勿扰执行。
3. PC 桌宠、Android Glance Widget、CompanionSnapshot 消费链路。
4. Streak、前日反馈、累计活跃奖励、怪兽完整状态机。
5. 完整回收站、复杂重复任务 occurrence、多端重复规则合并、普通任务 SubTask checklist。

## 验证记录

已通过：

```text
dart test                              # packages/task_domain
flutter test                           # apps/list_monster_app
powershell -File .\tool\verify_node2.ps1
flutter build web
flutter build windows --debug
flutter build apk --debug
```

## 节点 4 判定

节点 4：任务系统 P0 完成已达到当前冻结验收标准，等待 PM 手动试跑和验收确认。
