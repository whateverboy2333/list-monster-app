# 节点 3 核心闭环 Alpha 交付摘要

日期：2026-07-04

分支：`codex/node3-core-loop-alpha`

状态：已通过 PM 验收，准备合并入主分支。

## 冻结目标

节点 3 只验证第一条本地核心体验：

```text
获得怪兽蛋
-> 创建任务
-> 完成任务
-> 能量反馈
-> XP 增长
-> 怪兽状态变化
-> 今日任务激励触发
```

通过标准保持不变：不依赖云同步、不依赖桌宠，也能在本地完整跑通。

## 本次交付

1. App 本体新增本地闭环控制器 `CoreLoopController`，用于节点 3 内存态验证，不引入云同步、桌宠或 Widget 依赖。
2. 今日页可创建任务、完成任务，并显示 XP、怪兽状态和今日任务激励。
3. 怪兽页可展示怪兽蛋、小单名称、等级、心情和当前等级 XP。
4. 任务域补齐 `task_completed` 事件数据，包含 `thresholdCrossed = small_start / fruitful_day` 和 `parentLongTermTaskId = null`。
5. 怪兽域补齐 XP 规则、`XpLedgerEntry`、`xp_granted` 载荷、怪兽状态变化和 `daily_task_milestone`。
6. 核心事件 envelope 补齐 `source` 与 `payload`，与 `docs/contracts/events.md` 对齐。
7. 关键枚举增加稳定 `contractName`，避免后续用 Dart `.name` 造成 `longTermChild` / `userAction` 这类非契约命名外泄。

## 子 Agent 审核收敛

1. `AG-PROD-01`：确认节点 3 只跑本地核心闭环，不引入节点 6 外围能力；已按 3 次完成触发“小试身手”处理。
2. `AG-TASK-01`：要求 `task_completed` 命名和 payload 稳定；已补 `payload` 与契约名。
3. `AG-MONSTER-01`：要求 XP 由真实任务事件驱动并写入 ledger；已补本地 `XpLedgerEntry`。
4. `AG-CLIENT-01`：要求主 App 不再停留在占位壳；已接入 Today / Monster 的可用闭环。
5. `AG-QA-01`：要求不出现 `daily_clear` 旧口径、不依赖同步或桌宠；本次实现未引入 `daily_clear`。

## 明确未纳入节点 3

以下内容属于节点 4、节点 5 或节点 6，不在本次 Alpha 扩范围：

1. 任务撤销、删除、恢复、无压清理、重复规则。
2. 长期任务拆解与长期任务达成。
3. 每日 XP 上限完整裁剪、XP 冲正、Streak、前日反馈、累计活跃奖励。
4. 持久化存储、云同步、游客合并、通知、勿扰。
5. PC 第二窗口桌宠、Android Glance Widget、CompanionSnapshot 只读消费链路。

## 验证记录

已通过：

```text
dart test                              # packages/core
dart test                              # packages/task_domain
dart test                              # packages/monster_domain
flutter test                           # apps/list_monster_app
powershell -File .\tool\verify_node2.ps1
flutter build web
flutter build windows --debug
flutter build apk --debug
```

## 节点 3 判定

节点 3：核心闭环 Alpha 已达到冻结通过标准。

下一步进入节点 4：任务系统 P0 完成。
