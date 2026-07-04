# Wave 0 多 Agent 控制面板

## 当前状态

已创建 8 个 Codex 子线程，当前线程为 `AG-PM-00` 项目经理中枢。

节点路线图已冻结，唯一事实源为 [node-roadmap-freeze.md](node-roadmap-freeze.md)。后续不得擅自修改节点编号、节点名称或节点定义。

节点 1：契约冻结已完成。`docs/contracts/` 已升级并冻结为 v0.1.3，作为节点 2“工程骨架 + 初始 commit”的输入基线。8 个子 Agent 均已收到冻结公告并 ACK。

节点 2：工程骨架 + 初始 commit，已完成。Flutter monorepo 基础工程已建立，项目可通过 Web 本地启动、基础测试和 lint 已通过，并形成初始 commit。

节点 3：核心闭环 Alpha，已通过 PM 验收，准备合并入主分支。

## Agent 名册

详见 [agent-roster.md](agent-roster.md)。

## 已通过项

1. 采用 `AG-XXX-01 + threadId` 作为 Agent 定位方式。
2. 采用 PM 中枢路由：子 Agent 不直接改其他组方案，跨组问题发给 `AG-PM-00`。
3. 当前仓库未初始化 commit 前，所有子 Agent 只读，不写代码、不做 git 操作。
4. P0 信息架构按 今日 / 清单 / 怪兽 / 我的 4 Tab。
5. 桌宠和 Android Widget 只读统一快照，不各自计算任务、XP、Streak。
6. 经验只来自任务完成、今日任务激励、Streak、长期任务达成；抚摸和陪伴互动不产经验。

## PM 已裁决

1. `SubTask` 独立建模；MVP 的长期任务每日拆解项用 `Task` 表示，不用 `SubTask`。普通任务下的 `SubTask` 属 P1，默认不产生 XP。
2. 长期任务本体不允许直接完成；长期任务必须有跨天时间范围，只能通过拆解任务进度汇总达成。普通任务和长期任务都可以直接取消 / 放下，但取消不等于完成，不产生 XP。
3. 补充 `task_restored` 事件。
4. 废弃“今日通关 / daily_clear”核心概念，改为“今日任务激励”：完成 3 次提示“小试身手”，完成 6 次提示“收获满满”，第二天打开 App 时反馈前一天完成情况，累计完成超过 3 天给予累计经验奖励。
5. 桌宠只保留打开和关闭两个状态，事件为 `desktop_pet_on` / `desktop_pet_off`。
6. 补充 `streak_break` 内部事件，但不得形成用户惩罚、羞辱或负面反馈。
7. 无日期任务默认归属“今天”。
8. 由于取消“今日通关”，不再存在今日通关后新增任务回滚奖励问题。
9. 引导自动完成“给怪兽起名字”不给正式 XP。
10. 高优先级任务 `+15` 替代普通 `+10`，不是额外加成。
11. Streak 按用户本地时区计算。
12. 睡觉时抚摸一两次不打断，多次抚摸可打断睡眠，并表现为从睡觉到醒来的过渡。
13. PC 桌宠 MVP 采用主 App 第二窗口形态，类似 Codex floating overlay。
14. 勿扰期间默认不允许高优先级提醒穿透，后续可做用户显式 opt-in。
15. 登录后游客数据与已有云端数据合并必须由用户确认。
16. 账号注销设置 15 天冷静期。
17. Android Widget 技术路线优先采用 Glance；如遇兼容、样式或性能限制，再局部退回 RemoteViews。

详见 [pm-decisions.md](pm-decisions.md)。

## PM 待裁决

暂无。

## 节点 1 已处理审核项

1. `AG-CONTRACT-01`：统一事件命名，消除 `task.completed` 与 `task_completed` 混用。
2. `AG-CONTRACT-01`：补 `task_restored`、`streak_break`、`daily_task_milestone`、`daily_task_summary`、`cumulative_active_reward`、`batch_cleanup_applied` payload。
3. `AG-PROD-01`：补弹层优先级与情绪状态优先级。
4. `AG-CLIENT-01`：补 LWW 风险替代方案。
5. `AG-TASK-01`：补 5 秒撤销、XP 回滚、重复任务多端生成、tombstone。
6. `AG-MONSTER-01`：补 XP 幂等与蛋阶段首日破壳规则。
7. `AG-COMPANION-01`：补 CompanionSnapshot 字段、刷新、过期、隐私和通知去重。
8. `AG-SYNC-01`：补游客合并、删除同步、注销、任务标题隐私、“今晚”稍后提醒规则。

## 节点路线图

详见 [node-roadmap-freeze.md](node-roadmap-freeze.md)。

## 当前完成节点：节点 3

节点 3 名称：核心闭环 Alpha。

负责人：

```text
AG-PROD-01：流程
AG-TASK-01：任务完成事件
AG-MONSTER-01：XP / 状态
AG-CLIENT-01：页面与动画承载
AG-QA-01：验收
```

通过标准：

1. 不依赖云同步、不依赖桌宠。
2. 能在本地跑通“获得怪兽蛋 -> 创建任务 -> 完成任务 -> 能量反馈 -> XP 增长 -> 怪兽状态变化 -> 今日任务激励触发”。
3. 打勾反馈不被网络、同步或外部陪伴场域阻塞。

节点 3 交付摘要详见 [node-3-core-loop-alpha-summary.md](node-3-core-loop-alpha-summary.md)。

## 当前待启动节点：节点 4

节点 4 名称：任务系统 P0 完成。

范围：

```text
快速创建
今日视图
清单分组
任务完成 / 撤销 / 删除 / 恢复
长期任务拆解
无压清理
重复规则基础能力
提醒意图
```

关键验收：

1. 取消 / 放下不产生 XP。
2. `task_restored` 能正确恢复任务。
3. 长期任务不能直接完成，只能由拆解任务汇总达成。

## 进入代码开发前准入门槛

1. PM 完成全部 P0 裁决，并形成决策表。
2. `docs/contracts/` 建立并冻结数据模型、事件、埋点、快照、资产命名。
3. 事件命名统一为 snake_case。
4. Task 完成、撤销、删除、恢复、长期任务达成、今日任务激励、Streak 事件链路闭环。
5. XP 幂等、XP 回滚、每日上限、长期任务 +50 例外有测试口径。
6. CompanionSnapshot 字段冻结。
7. 离线同步不依赖简单 LWW 覆盖完成/XP/Streak。
8. P0 页面流、弹层优先级、情绪状态优先级冻结。
9. 通知、勿扰、隐私标题、权限请求时机冻结。
10. 初始 commit 完成，并为代码型 Agent 分配独立 worktree。
