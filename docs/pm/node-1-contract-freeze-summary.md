# 节点 1 契约冻结审核汇总

状态：已完成

冻结基线：`docs/contracts/` v0.1.3

## 已收集回复

1. `AG-CONTRACT-01`：v0.1.1 复审无阻塞，建议统一 `timezoneId`、前日反馈字段、`xp_reverted.amount` 正负号、累计奖励是否计入每日上限。
2. `AG-QA-01`：v0.1.1 满足节点 1 冻结条件，同意作为后续工程输入基线；剩余问题已由 PM 裁决并并入 v0.1.3。
3. `AG-TASK-01`：任务归属、撤销、删除、恢复、长期任务拆解、XP 责任边界已纳入契约。
4. `AG-MONSTER-01`：怪兽状态、睡眠唤醒、今日任务激励、XP 幂等和累计奖励口径已纳入契约。
5. `AG-COMPANION-01`：PC 桌宠与 Android Widget 统一只读 `CompanionSnapshot`，Glance 优先，Widget 不直接写任务事件。
6. `AG-SYNC-01`：游客合并确认、勿扰、通知生命周期、同步队列幂等字段已纳入契约。

## 本轮补丁

1. 契约版本从 v0.1.1 草案升级为 v0.1.2 冻结版。
2. 统一用户、Streak、快照时区字段为 `timezoneId`。
3. 明确 `xp_reverted.amount` 必须为负数，原 XP ledger 不删除。
4. 明确累计活跃第 4 天 +20 XP 计入每日正式 XP 上限；长期任务整体达成 +50 仍不占每日上限。
5. 补齐埋点表中的 `task_deleted`、`batch_cleanup_applied`、`xp_reverted`。
6. 补齐 `CompanionSnapshot` 的 stale 窗口、前日可奖励完成数和前日反馈标题字段。

## 冻结公告 ACK

1. `AG-CONTRACT-01`：ACK NODE1_FROZEN CONTRACT v0.1.2
2. `AG-QA-01`：ACK NODE1_FROZEN QA v0.1.2
3. `AG-PROD-01`：ACK NODE1_FROZEN PROD v0.1.2
4. `AG-CLIENT-01`：ACK NODE1_FROZEN CLIENT v0.1.2
5. `AG-TASK-01`：ACK NODE1_FROZEN TASK v0.1.2
6. `AG-MONSTER-01`：ACK NODE1_FROZEN MONSTER v0.1.2
7. `AG-COMPANION-01`：ACK NODE1_FROZEN COMPANION v0.1.2
8. `AG-SYNC-01`：ACK NODE1_FROZEN SYNC v0.1.2

## 冻结结论

节点 1 正式完成。后续节点 2“工程骨架 + 初始 commit”必须以 `docs/contracts/` v0.1.3 为输入契约；如需新增或改名字段，必须先回到 `AG-PM-00` 做契约变更裁决。
