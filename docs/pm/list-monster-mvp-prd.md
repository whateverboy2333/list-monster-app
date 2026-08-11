# 清单怪兽 MVP 产品需求文档（PRD）

| 项 | 内容 |
|---|---|
| 文档版本 | v1.0 |
| 状态 | 已冻结基线（对应 MVP Beta，节点 1-7 已完成口径） |
| 编写依据 | 《AI 时代的 PRD（输入）规范》：显式上下文 + 状态机闭环 + 可自动化验证的断言 |
| 契约基线 | `docs/contracts/` v0.1.3（domain-model / events / xp-rules / companion-snapshot / analytics / assets） |
| 裁决基线 | `docs/pm/pm-decisions.md` D-001 至 D-045 |
| 节点基线 | `docs/pm/node-roadmap-freeze.md`（已冻结） |
| 负责人 | `AG-PM-00` |

---

## 0. 文档定位与使用方式

本文档是清单怪兽 MVP 的**业务需求唯一输入**，面向 AI AutoPilot 托管开发与人工验收。按照 AI 时代 PRD 规范，本文档由三个核心要素构成，且仅由这三个要素构成：

1. **显式上下文（第 4 章）**：划定业务操作范围——本需求涉及哪些模块、哪些核心业务实体、必须引用哪些已有上下文、严禁新建或复活什么。这不是技术方案，不写库表、不写类设计、不指定实现路径。
2. **状态机闭环（第 5 章）**：用状态矩阵和规则矩阵把所有业务分支封死。状态机是纯粹的业务规则，不是伪代码；凡是矩阵中未列出的状态转换，一律视为**禁止**。
3. **可自动化验证的断言（第 6 章）**：用 Gherkin 语法写明验收标准的业务输入 / 输出（I/O）。这定义"什么叫做出厂合格"，不是单元测试代码；如何把这些断言跑成测试，由实现方或 Harness 自行完成。

**引用纪律**：实体的字段级定义以 `docs/contracts/domain-model.md` v0.1.3 为唯一事实源，事件的 payload 定义以 `docs/contracts/events.md` v0.1.3 为唯一事实源。本文档不重复定义字段，只引用实体名、枚举值与规则编号。如本文档与契约冲突，以契约为准并上报 `AG-PM-00` 裁决。

---

## 1. 产品概述

### 1.1 一句话定义

清单怪兽是一款游戏化清单工具：用户记录任务、完成任务，饲养一只怪兽（默认名"小单"），怪兽的成长全部来自真实的任务完成行为。

### 1.2 核心闭环（节点 3 冻结口径）

获得怪兽蛋 → 创建任务 → 完成任务 → 能量反馈 → XP 增长 → 怪兽状态变化 → 今日任务激励触发。

通过标准：不依赖云同步、不依赖桌宠，也能在本地完整跑通。

### 1.3 设计原则（全局约束，优先级高于任何单条功能）

1. **成长必须真实**：所有 XP 与怪兽成长只能来自真实任务行为。抚摸、打开 App、桌宠互动、小组件查看、引导自动完成一律不产生正式 XP。
2. **无压力**：产品不得惩罚、羞辱、责怪用户。`streak_break` 只是内部事件；禁止断签惩罚、扣 XP、怪兽负面状态、失败文案。
3. **本地反馈优先**：打勾完成等核心交互的反馈不得被同步、网络或外部桥阻塞。
4. **统一快照**：PC 桌宠与 Android Widget 只能读取统一 `CompanionSnapshot`，不得自行计算任务、XP、Streak 或怪兽状态。

---

## 2. 用户与模式

| 模式 | 说明 |
|---|---|
| 游客模式（`guest`） | 默认模式，可使用全部本地能力；游客也有本地 `userId` |
| 注册模式（`registered`） | 登录 Provider 为 `phone` / `wechat`；MVP P0 仅本地模拟登录，不接真实短信验证码或微信授权（D-038） |

登录后如云端已有数据，游客数据合并**必须经用户确认**（D-015）。

---

## 3. 范围

### 3.1 In Scope（MVP P0）

1. 任务系统：快速创建、今日视图、完成 / 撤销 / 放下（取消）/ 删除 / 恢复、长期任务手动拆解、无压清理、重复规则占位、提醒意图。
2. 怪兽养成：XP 计算与每日上限、高优先级 +15、Streak、今日任务激励、前日完成反馈、累计活跃奖励、睡觉 / 想念 / 期待 / 元气 / 空闲状态机、抚摸与多次唤醒、升级。
3. 账号与同步底座：游客模式、本地模拟登录、游客合并确认、15 天注销冷静期、离线队列、顺序回放、幂等与失败阻断。
4. 通知与隐私：本地通知端口、勿扰顺延、隐私标题、点击回流意图。
5. 陪伴场域：CompanionSnapshot、PC 第二窗口桌宠、Android Widget、deep link 与刷新意图。
6. 平台：Flutter Web、Windows、Android 三端；中 / EN 全局语言切换（默认中文）。

### 3.2 Out of Scope（明确不做，任何实现不得夹带）

1. 真实云服务、真实 Auth Provider、真实系统通知调度（均为本地适配器与模拟入口，D-037/D-038/D-040）。
2. AI 拆解、自然语言任务创建、普通任务 SubTask checklist（P1，D-001）。
3. 复杂重复任务 occurrence、多端重复规则合并（P1，D-020）。
4. 完整回收站（P1，D-033）。
5. 装扮、成就系统、分支进化、复杂动画资产。
6. Widget 组件内勾选任务、Widget 持续动画（D-017/D-041）。
7. 桌宠透明、置顶、点击穿透、拖拽、独立进程（D-013/D-043）。

---

## 4. 显式上下文（规范要素一）

### 4.1 模块边界

本需求只涉及以下既有模块，开发时必须在这些边界内作业，不得新建无关领域模型：

| 模块 | 业务职责 | 边界约束 |
|---|---|---|
| `apps/list_monster_app` | 主 App：今日页、长期页、怪兽页、我的页、桌宠第二窗口、各域接线 | 页面与交互承载；领域规则不在 UI 层重复实现 |
| `packages/task_domain` | 任务生命周期事件、长期任务聚合、TaskList、提醒意图 | 任务事件命名与 payload 以契约为准 |
| `packages/monster_domain` | XP 账本与规则、Streak、怪兽状态机、每日摘要、抚摸反应 | XP 唯一账本是 `XpLedger` |
| `packages/account_domain` | 账号、游客、游客合并任务、注销冷静期状态机 | 同步域不承载账号状态机本体（D-042） |
| `packages/sync_domain` | 同步队列、顺序回放、幂等、冲突策略 | 只引用账号事件事实，不新建账号模型 |
| `packages/local_store` | 本地持久化端口与内存实现 | 首轮不引入数据库依赖（D-039） |
| `packages/companion_contract` | CompanionSnapshot 契约 | 快照 schema 变更必须升 `schemaVersion` |
| `packages/sprite_runtime` / `packages/ui_kit` | 状态帧 / sprite 播放与 UI 组件 | 资产命名以 assets 契约为准 |
| `packages/core` | 事件 envelope、共享基础类型 | 枚举对外序列化必须使用契约名 |

### 4.2 必须引用的已有上下文

1. 实体定义：`docs/contracts/domain-model.md` v0.1.3（User / Task / SubTask / LongTermTask / TaskList / SmartTaskView / Monster / XpLedger / Streak / DailyTaskSummary / Reminder / GuestMergeJob / SyncQueueItem）。
2. 事件定义：`docs/contracts/events.md` v0.1.3（含 envelope：`eventId`、`eventName`、`userId`、`occurredAt`、`source`、`payload`）。
3. XP 数值口径：`docs/contracts/xp-rules.md` v0.1.3。
4. 快照字段与刷新口径：`docs/contracts/companion-snapshot.md` v0.1.3。
5. 埋点口径：`docs/contracts/analytics.md` v0.1.3。
6. 资产口径：`docs/contracts/assets.md` v0.1.3。
7. 全部 PM 裁决：`docs/pm/pm-decisions.md` D-001 至 D-045（本文以 D-xxx 引用）。

### 4.3 核心业务实体一句话边界

1. `Task` 是今日列表和 XP 的基础单位；长期任务每日拆解项也是 `Task`（`taskType = long_term_child`），**不得**用 `SubTask` 表示（D-001）。
2. `LongTermTask` 是跨天目标容器，`dueDate` 必须晚于 `startDate`，本体不能被直接完成（D-002）。
3. `XpLedger` 是 XP 的唯一账本来源，只追加、不删除原记录；撤销通过负数 `xp_reverted` 冲正（D-021）。
4. `CompanionSnapshot` 是桌宠与 Widget 的唯一数据源。
5. `SmartTaskView`（`today` / `next_7_days`）是智能视图，不是持久清单；`TaskList` 底层保留但 MVP 用户界面不暴露清单分类。

### 4.4 全局禁止事项（违反任一条 = 验收不通过）

| 编号 | 禁止项 | 依据 |
|---|---|---|
| F-01 | 禁止使用 `daily_clear` / "今日通关"旧口径（命名、文案、逻辑均禁止） | D-004 |
| F-02 | 禁止抚摸、打开 App、桌宠互动、Widget 查看、引导自动完成产生正式 XP | xp-rules / D-009 |
| F-03 | 禁止 `streak_break` 触发惩罚、羞辱、扣 XP、怪兽负面状态或惩罚型文案曝光 | D-006 |
| F-04 | 禁止长期任务本体被直接完成，`achieved` 只能由拆解任务进度汇总触发 | D-002 |
| F-05 | 禁止取消 / 放下、删除、恢复产生 XP 或触发负面反馈 | D-002 / D-003 |
| F-06 | 禁止已完成任务被直接取消；必须先撤销完成再取消（D-029） | D-029 |
| F-07 | 禁止 Widget / 桌宠发出任务完成、XP、Streak、怪兽状态变更类事件；只能点击回 App | companion-snapshot / D-041 |
| F-08 | 禁止桌宠、Widget、通知展示具体任务标题；外部场域只用泛化文案 | D-036 |
| F-09 | 禁止使用 `desktop_pet_toggle`；桌宠只有 `desktop_pet_on` / `desktop_pet_off` 两个状态 | D-005 |
| F-10 | 禁止出现 `sick` / `dead` / `hungry` / `angry` / `leave` / `punish` 动作或资源命名 | assets 契约 |
| F-11 | 禁止 XP 撤销时删除或改写原正向 `XpLedger` 记录；只能追加负数冲正 | D-021 |
| F-12 | 禁止同一正向 `sourceEventId` 重复发放 XP（含同步回放场景，D-024） | events / D-024 |
| F-13 | 禁止 XP 回退时展示降级动画、惩罚文案或怪兽负面反馈；只静默刷新 | D-026 |
| F-14 | 禁止同日同 `milestoneKey` 今日任务激励重复主动弹出 | D-031 |
| F-15 | 禁止前日 0 完成时弹出反馈弹层或使用断签 / 失败 / 责备文案 | D-032 |
| F-16 | 禁止枚举对外泄漏非契约命名（如 Dart `.name` 直出） | 节点 3 收敛 |
| F-17 | 禁止注销冷静期（`deletion_pending`）内新增会被同步的任务、XP 或账号数据；只允许取消注销 | D-027 |
| F-18 | 禁止客户端从动画帧自行猜测 Widget 静态帧；必须使用 `widgetFrameAssetId` | assets 契约 |
| F-19 | 禁止长期任务默认拆解 fallback；拆解项必须来自用户确认的每日标题 | 节点 4 收敛 |
| F-20 | 禁止高优先级 +15 与 +10 叠加；+15 是替代 | D-010 |

---

## 5. 业务规则与状态机闭环（规范要素二）

说明：以下矩阵封死全部业务分支。**矩阵中未列出的转换一律禁止**。`-->` 表示事件驱动的状态转换。

### 5.1 任务（Task）生命周期状态机

状态集：`active` / `completed` / `cancelled` / `deleted`（软删除 tombstone）。

| 当前状态 | 触发事件 | 目标状态 | XP 影响 | 其他规则 |
|---|---|---|---|---|
| `active` | `task_completed` | `completed` | 按 5.3 XP 矩阵发放 | 记录 `completedAt`、`completionSource` |
| `active` | `task_cancelled` | `cancelled` | 无 | 放下语义，不触发负面反馈 |
| `active` | `task_deleted` | `deleted` | 无 | 软删除，保留 tombstone |
| `active` | `task_rescheduled` | `active`（日期变更） | 无 | 记录 from/to 日期与时间 |
| `completed` | `task_completion_undone` | `active` | 追加负数 `xp_reverted` 冲正 | 原 XP 记录保留；携带 `originalXpLedgerId` |
| `cancelled` | `task_restored` | `active` | 无 | 携带 `restoredFromEventId` |
| `deleted` | `task_restored` | `previousStatus` | 无 | 删除前是 `completed` 的恢复为 `completed`，但不补发、不冲正 XP |

严禁转换：

1. `completed` --> `cancelled`（必须先撤销完成，D-029）。
2. `cancelled` / `deleted` --> `completed`（必须先恢复为 `active` 再完成）。
3. 任何状态经 `task_restored` 恢复时产生 XP。
4. `task_created` 时 `rewardEligible = false` 的普通任务进入 XP 计算。

补充规则：

1. 普通任务与长期任务拆解项默认 `rewardEligible = true`；普通 `SubTask` 默认 `false`。
2. 无日期输入的任务 `scheduledDate` 默认为今天，`dateSource = default_today`（D-007）。
3. 物理删除只用于账号注销或数据清理，不走 `task_restored` 恢复流。

### 5.2 长期任务（LongTermTask）状态机

状态集：`active` / `achieved` / `cancelled` / `deleted`。

| 当前状态 | 触发 | 目标状态 | XP 影响 | 规则 |
|---|---|---|---|---|
| `active` | 全部拆解 `Task` 完成汇总（`longterm_progress_changed` 进度达 1） | `achieved` | +50，不占每日上限，每个长期任务仅一次 | 触发 `longterm_achieved` |
| `active` | `longterm_cancelled` | `cancelled` | 无 | 未完成拆解项同步取消；已完成拆解项保留历史（D-018） |
| `active` | 软删除 | `deleted` | 无 | 同 Task 软删除口径 |

严禁转换：

1. 任何由用户操作直接把长期任务本体标记完成的路径。
2. `achieved` 由拆解汇总以外的任何触发源触发。
3. 缩短日期范围时静默排除已完成拆解项；会排除未完成拆解项时必须显式确认，确认后这些项被放下且不产生 XP。

创建规则：

1. 创建必须提供：长期目标标题、开始日期、截止日期（晚于开始日期）、用户填写的每日拆解项；仅输入标题不得创建（F-19）。
2. 创建后按日生成 `taskType = long_term_child` 的拆解 `Task`，进入今日列表，参与 XP 与进度汇总。

### 5.3 XP 规则矩阵

每日正式 XP 上限固定 **125**。

| 触发源 | 条件 | XP | 是否计入每日上限 |
|---|---|---|---|
| 任务完成 | 当日第 1-5 个可奖励完成，普通优先级 | +10 / 个 | 计入 |
| 任务完成 | 当日第 1-5 个可奖励完成，高优先级 | +15 / 个（替代 +10） | 计入 |
| 任务完成 | 当日第 6-10 个可奖励完成 | +5 / 个 | 计入 |
| 任务完成 | 当日第 11 个起可奖励完成 | +1 / 个 | 计入 |
| 累计活跃奖励 | 第 4 个活跃日（`rewardThreshold = 4`） | +20，一次性 | 计入 |
| 长期任务达成 | 拆解全部完成汇总 | +50，每个长期任务仅一次 | 不计入 |
| 完成撤销 | `task_completion_undone` | 负数冲正 | 冲正后重算当日累计 |

闭环规则：

1. 只有 `rewardEligible = true` 的 `task_completed` 进入 XP 计算；同一 `eventId` 只能发放一次。
2. 高优先级 +15 只适用于当日第 1-5 个可奖励完成；第 6 个起统一进入递减规则。
3. 每次发放写入 `XpLedger`，携带 `sourceEventId`、`localDate`、`timezoneId`、`dailyTotalAfterGrant`、`dailyCapApplied`。
4. 发放触及每日上限时按上限裁剪，`dailyCapApplied = true`；+50 不受裁剪。
5. 冲正：追加 `xp_reverted` 负数记录，`originalXpLedgerId` 指向原记录；`xp_reverted.sourceEventId` 绑定 `task_completion_undone.eventId`，防重复冲正。
6. 升级：XP 到达等级门槛触发 `level_up`；回退时数据层立即校正、UI 静默刷新（F-13）。
7. 活跃日定义：用户本地时区内完成至少 1 个 `rewardEligible = true` 任务的自然日。

### 5.4 今日任务激励与前日反馈

今日任务激励（废弃 `daily_clear` 后的唯一当日激励机制）：

| 当日可奖励完成数 | `milestoneKey` | 标题 | 展示约束 |
|---|---|---|---|
| 3 | `small_start` | 小试身手 | 同一用户同一本地日同一 key 最多主动展示一次（D-031） |
| 6 | `fruitful_day` | 收获满满 | 同上 |

1. 撤销完成导致跌回阈值以下后再次跨过，不重复弹出；Snapshot 可恢复显示当前达成状态。
2. 该机制只提供正向激励，不要求用户清空今日任务。

前日反馈（`daily_task_summary`）：

1. 生成时机：第二天用户首次打开 App 时生成并展示，不做后台跨日预生成（D-023）。
2. 前日可奖励完成数为 0 时，不弹层；今日页可展示温和被动鼓励卡（D-032）。
3. 只做正向反馈，不发放 XP。

### 5.5 Streak 规则

1. 定义：连续活跃天数；活跃日见 5.3-7。
2. 时区：按用户本地时区（`timezoneId`）计算，不考虑 VPN 等网络位置（D-011）。
3. 跨日出现缺口时生成内部事件 `streak_break`，携带 `missedLocalDate`、`previousStreakDays`。
4. `streak_break` 不触发任何用户可见的惩罚、羞辱、扣 XP 或怪兽负面状态（F-03）。
5. `currentStreakDays` 与 `bestStreakDays` 分别维护；中断后 `currentStreakDays` 归零重计，`bestStreakDays` 保留历史最佳。

### 5.6 怪兽心情（moodState）状态机

状态集：`idle` / `energetic` / `expecting` / `sleeping` / `missing`（阶段 `stage`：`egg` / `child` / `teen` / `adult` 由 XP 等级驱动，独立于心情）。

心情是**派生状态**，按以下优先级取第一个满足条件者：

| 优先级 | 状态 | 进入条件（全部满足） | 解除 |
|---|---|---|---|
| P1（最高） | `missing` | 连续 3 个完整本地自然日未前台打开 App，下一次打开时触发一次（D-030） | 任一任务完成，或当次会话结束 |
| P2 | `sleeping` | 本地时间 ∈ [23:00, 07:00) 且无有效唤醒覆盖 | 离开睡眠时段，或唤醒覆盖生效（见 5.7） |
| P3 | `expecting` | 存在 `status = active` 的任务 | 无 active 任务 |
| P4 | `energetic` | 当日可奖励完成数 > 0 且无 active 任务 | 条件不再满足 |
| P5（最低） | `idle` | 以上均不满足 | 默认态 |

状态变化必须发出 `monster_state_changed`，携带 `fromMoodState` / `toMoodState` / `reason`。

### 5.7 睡眠抚摸互动规则

| 条件 | 结果 |
|---|---|
| 睡眠中第 1 次抚摸 | 不打断睡眠，反应 `pet_01` |
| 睡眠中第 2 次抚摸 | 不打断睡眠，反应 `pet_02` |
| 睡眠中第 3 次抚摸（`wakeUpThreshold = 3`） | 触发 `wake_up`，计数清零 |
| 唤醒后 | 若仍在睡眠时段，醒来状态最多保持 10 分钟，无继续互动则回到 `sleeping`（D-025） |
| 非睡眠状态抚摸 | 反应 `pet_01`，不计入睡眠抚摸计数 |

全程不产生 XP（F-02）。每次抚摸发出 `monster_pet_reacted`，携带 `reactionKey` 与 `touchCountInSleep`。

### 5.8 提醒与勿扰规则矩阵

Reminder 状态集：`scheduled` / `sent` / `snoozed` / `cancelled`。

| 场景 | 规则 |
|---|---|
| "今晚"稍后提醒 | 锚点 = 用户本地当天 20:00；选择时已过 20:00 则为 now + 1 小时（D-028） |
| 提醒落入勿扰时段 | 顺延到勿扰结束后的第一个可提醒时间，发出 `notification_suppressed_by_dnd` |
| 高优先级提醒穿透勿扰 | MVP 默认禁止（`dndAllowPriorityOverride = false`，D-014） |
| `respectDnd` | MVP 默认 true |
| 通知文案 | 只使用泛化隐私标题，不含任务标题（F-08） |
| 通知点击 | 回流 App 对应任务，发出 `notification_open` |

提醒在 MVP 只记录意图（`reminderId` 关联到任务），真实系统调度为 Out of Scope。

### 5.9 账号生命周期状态机

`accountDeletionStatus`：`active` / `deletion_pending` / `deleted` / `deletion_cancelled`。

| 当前状态 | 触发 | 目标状态 | 规则 |
|---|---|---|---|
| `active` | 用户申请注销 | `deletion_pending` | 冷静期 15 天，记录申请时间与生效时间 |
| `deletion_pending` | 用户取消注销 | `deletion_cancelled` 后恢复 `active` | 冷静期内唯一允许的写操作 |
| `deletion_pending` | 冷静期满 | `deleted` | 物理删除可用于数据清理 |

冷静期内账号默认只读：不允许新增会被同步的新任务、XP 或账号数据（F-17）。

游客合并（`GuestMergeJob`）状态集：`pending_confirmation` / `confirmed` / `merged` / `cancelled` / `failed`。

| 转换 | 规则 |
|---|---|
| 登录后云端已有数据 --> `pending_confirmation` | 必须等待用户确认，不得自动合并（D-015） |
| `pending_confirmation` --> `confirmed` --> `merged` | 用户确认后执行合并 |
| `pending_confirmation` --> `cancelled` | 用户放弃合并 |
| 合并执行失败 --> `failed` | 保留重试入口，不得静默丢失游客数据 |

### 5.10 同步队列（SyncQueueItem）状态机

状态集：`pending` / `syncing` / `synced` / `failed`。

闭环规则：

1. 任务生命周期操作入队时必须携带 `eventId` 与 `dedupeKey`（幂等键）。
2. 回放严格按顺序消费；单项失败标记 `failed` 并阻断后续项，保留重试。
3. 离线完成：本地完成反馈链立即执行，同步交接异步进行，不得阻塞打勾反馈。
4. `completionSource = sync_replay` 的远端完成允许触发本地 XP / Streak / 怪兽重算，但必须使用原始 `eventId` / `sourceEventId` 幂等去重（D-024）。
5. 并发冲突：取消操作基于旧 `active` 版本提交时触发冲突重放，不得覆盖已完成事实（D-029）。

### 5.11 CompanionSnapshot 与陪伴场域规则

1. 桌宠与 Widget 只能读取统一 `CompanionSnapshot`；禁止自行计算任务、XP、Streak、怪兽状态（F-07）。
2. 过期：`staleAfterSeconds` P0 固定 300；超过后外部场域应刷新或显示保守过期文案。
3. 刷新触发：任务创建 / 完成 / 撤销 / 恢复；XP 发放 / 等级变化 / 怪兽状态变化；今日任务激励触发；Streak 更新或 `streak_break`；桌宠开关；通知提醒到达。
4. 外部桥（Widget 桥、桌宠窗口）失败不得阻塞任务与成长反馈链。
5. 隐私：`hideTaskTitlesOutsideApp` 生效时外部场域隐藏任务标题（F-08）。
6. 勿扰期间桌宠保持可见但低动效：不弹提醒气泡、不播放声音、不强反馈（D-035）。
7. Widget 点击落点：怪兽状态帧 --> 怪兽页；今日进度 / 激励 / 前日反馈 / 过期态 --> 今日页并触发刷新（D-041）。
8. Widget 埋点 P0 只保留 `widget_added`（D-022）。
9. 快照 schema 变更必须升 `schemaVersion`。

### 5.12 多奖励展示顺序

同一完成事件同时触发多个反馈时，展示顺序固定为（D-034）：

任务完成即时反馈 --> 今日任务激励轻提示 --> 长期任务达成 --> XP / 等级升级 -->（前日反馈延后到次日打开时展示）。

---

## 6. 可自动化验证的验收断言（规范要素三）

说明：以下为业务 I/O 断言，定义出厂合格标准。每个场景可独立自动化。编号规则：`AC-<域>-<序号>`。

### 6.1 核心闭环与 XP 发放

```gherkin
场景 AC-XP-01: 首个普通任务完成发放 +10 XP
  假如 用户当日可奖励完成数为 0
  当 用户完成 1 个 rewardEligible = true 的普通优先级任务
  那么 XpLedger 新增 1 条 amount = +10 的记录
  并且 记录携带该 task_completed 的 sourceEventId
  并且 dailyTotalAfterGrant = 10 且 dailyCapApplied = false

场景 AC-XP-02: 高优先级 +15 替代 +10
  假如 用户当日可奖励完成数小于 5
  当 用户完成 1 个高优先级任务
  那么 XpLedger 新增 amount = +15，而不是 +10 或 +25

场景 AC-XP-03: 第 6 至第 10 个完成进入 +5 递减
  假如 用户当日已完成 5 个可奖励任务
  当 用户再完成 1 个可奖励任务（含高优先级）
  那么 XpLedger 新增 amount = +5

场景 AC-XP-04: 第 11 个起完成进入 +1 递减
  假如 用户当日已完成 10 个可奖励任务
  当 用户再完成 1 个可奖励任务
  那么 XpLedger 新增 amount = +1

场景 AC-XP-05: 每日 XP 上限 125 裁剪
  假如 用户当日正式 XP 累计已达 120
  当 触发一笔 +10 的任务完成 XP
  那么 实际入账被裁剪至当日累计不超过 125
  并且 该记录 dailyCapApplied = true

场景 AC-XP-06: XP 发放幂等
  假如 某 task_completed 事件已产生正向 XP 记录
  当 同一 eventId 的完成事件再次被消费（含同步回放 sync_replay）
  那么 不产生第二条正向 XP 记录

场景 AC-XP-07: 非真实行为不产生 XP
  当 用户抚摸怪兽、打开 App、查看 Widget、与桌宠互动，或引导自动完成"给怪兽起名字"
  那么 XpLedger 不新增任何记录
```

### 6.2 撤销、冲正与恢复

```gherkin
场景 AC-UNDO-01: 撤销完成产生负数冲正
  假如 任务 A 已完成并入账 +10 XP
  当 用户撤销任务 A 的完成
  那么 XpLedger 追加 1 条 sourceType = xp_reverted 的负数记录
  并且 该记录通过 originalXpLedgerId 指向原 +10 记录
  并且 原 +10 记录保留不被删除或改写

场景 AC-UNDO-02: 重复冲正防护
  假如 任务 A 的完成已撤销且冲正记录已存在
  当 同一 task_completion_undone 事件再次被消费
  那么 不产生第二条冲正记录

场景 AC-UNDO-03: 冲正后当日累计重算
  假如 当日 dailyTotalAfterGrant 最新为 20
  当 撤销一笔 +10 的完成
  那么 冲正记录的 dailyTotalAfterGrant 反映冲正后的当日累计

场景 AC-UNDO-04: 等级回退静默刷新
  假如 撤销完成后怪兽 XP 低于当前等级门槛
  那么 数据层立即校正等级数据
  并且 不展示降级动画、惩罚文案或怪兽负面反馈

场景 AC-RESTORE-01: 删除恢复不产生 XP
  假如 任务 A 处于 deleted 状态
  当 用户通过 task_restored 恢复任务 A
  那么 任务 A 恢复为其 previousStatus
  并且 XpLedger 不新增任何记录
```

### 6.3 任务生命周期边界

```gherkin
场景 AC-TASK-01: 放下不产生 XP 与负面反馈
  当 用户对 active 任务执行放下（task_cancelled）
  那么 任务进入 cancelled
  并且 XpLedger 无新增，怪兽不出现负面状态

场景 AC-TASK-02: 已完成任务不能直接取消
  假如 任务 A 处于 completed
  当 用户尝试对任务 A 执行取消
  那么 操作被拒绝或要求先撤销完成
  并且 任务保持 completed，不产生 task_cancelled

场景 AC-TASK-03: 无日期任务默认归属今天
  当 用户创建任务且未输入日期
  那么 scheduledDate = 用户本地今天 且 dateSource = default_today
```

### 6.4 长期任务

```gherkin
场景 AC-LT-01: 长期任务本体不能直接完成
  假如 存在一个 active 的长期任务
  当 用户尝试直接完成该长期任务本体
  那么 操作不可用，长期任务保持 active

场景 AC-LT-02: 拆解全部完成触发达成 +50
  假如 长期任务 L 的全部拆解 Task 均已 completed
  那么 L 变为 achieved 并触发 longterm_achieved
  并且 XpLedger 新增 amount = +50
  并且 该 +50 不计入当日 125 上限

场景 AC-LT-03: 达成奖励仅一次
  假如 长期任务 L 已 achieved 且 +50 已入账
  当 任何后续事件再次触发达成汇总
  那么 不再发放第二笔 +50

场景 AC-LT-04: 取消长期任务不产生 XP
  假如 长期任务 L 有 2 个未完成拆解项和 1 个已完成拆解项
  当 用户取消 L
  那么 2 个未完成拆解项同步取消
  并且 已完成拆解项保留历史完成记录
  并且 XpLedger 无新增

场景 AC-LT-05: 仅标题不能创建长期任务
  当 用户只输入长期目标标题、未填写每日拆解项
  那么 不创建长期任务，不生成默认拆解

场景 AC-LT-06: 缩短日期范围排除未完成项需确认
  假如 长期任务 L 的未完成拆解项落在拟缩短后的范围之外
  当 用户保存新的日期范围
  那么 系统要求显式确认
  并且 确认后这些未完成项被放下且不产生 XP
```

### 6.5 激励、前日反馈与累计奖励

```gherkin
场景 AC-MS-01: 第 3 个完成触发"小试身手"
  假如 用户当日可奖励完成数为 2 且本日未展示过 small_start
  当 用户完成当日第 3 个可奖励任务
  那么 触发 daily_task_milestone，milestoneKey = small_start

场景 AC-MS-02: 同一 milestone 同日只主动展示一次
  假如 本日 small_start 已主动展示过
  当 用户撤销完成后再度跨过第 3 个完成
  那么 不重复弹出 small_start 提示

场景 AC-SUM-01: 前日反馈在次日首次打开生成
  假如 昨天用户完成了 3 个可奖励任务
  当 用户今天首次打开 App
  那么 生成 daily_task_summary 并以正向语气展示昨日完成数
  并且 不发放 XP

场景 AC-SUM-02: 前日 0 完成不弹层
  假如 昨天用户可奖励完成数为 0
  当 用户今天打开 App
  那么 不弹出前日反馈弹层
  并且 不出现断签、失败或责备文案

场景 AC-CUM-01: 第 4 个活跃日一次性 +20
  假如 用户已有 3 个活跃日
  当 用户在第 4 个活跃日完成首个可奖励任务
  那么 触发 cumulative_active_reward，XpLedger 新增 +20
  并且 该 +20 计入当日 125 上限
```

### 6.6 Streak

```gherkin
场景 AC-ST-01: 活跃日驱动 Streak 增长
  假如 用户昨天完成过可奖励任务且 currentStreakDays = 1
  当 用户今天完成首个可奖励任务
  那么 currentStreakDays = 2 并触发 streak_updated

场景 AC-ST-02: 断签只产生内部事件
  假如 用户 currentStreakDays = 5 且昨天无任何可奖励完成
  当 系统在今天判定跨日缺口
  那么 生成内部 streak_break，携带 missedLocalDate 与 previousStreakDays = 5
  并且 不扣 XP、不展示惩罚或羞辱文案、怪兽不进入负面状态

场景 AC-ST-03: Streak 按本地时区
  当 计算活跃日与跨日缺口
  那么 使用用户 timezoneId 的本地自然日，不受网络位置影响
```

### 6.7 怪兽状态机与抚摸

```gherkin
场景 AC-MD-01: 状态优先级 missing > sleeping
  假如 用户连续 3 个完整自然日未打开 App 且当前本地时间为 23:30
  当 用户打开 App
  那么 moodState = missing，而非 sleeping

场景 AC-MD-02: 睡眠时段判定
  假如 当前本地时间属于 [23:00, 07:00) 且无有效唤醒覆盖
  那么 moodState = sleeping

场景 AC-MD-03: 有待办则期待
  假如 非睡眠时段、无 missing，存在至少 1 个 active 任务
  那么 moodState = expecting

场景 AC-MD-04: 无待办且今日有完成则元气
  假如 非睡眠时段、无 missing、无 active 任务，且当日可奖励完成数 > 0
  那么 moodState = energetic

场景 AC-MD-05: 默认空闲
  假如 以上条件均不满足
  那么 moodState = idle

场景 AC-PET-01: 睡眠中前两次抚摸不打断
  假如 怪兽处于 sleeping
  当 用户连续抚摸 2 次
  那么 两次反应分别为 pet_01、pet_02，怪兽保持 sleeping
  并且 XpLedger 无新增

场景 AC-PET-02: 第三次抚摸唤醒
  假如 怪兽处于 sleeping 且本次睡眠窗口已被抚摸 2 次
  当 用户第 3 次抚摸
  那么 触发 wake_up，睡眠抚摸计数清零

场景 AC-PET-03: 唤醒保持 10 分钟
  假如 怪兽刚被 wake_up 唤醒且仍在睡眠时段
  那么 10 分钟内无继续互动后，moodState 回到 sleeping
```

### 6.8 提醒与勿扰

```gherkin
场景 AC-NT-01: "今晚"锚点为 20:00
  假如 当前本地时间早于 20:00
  当 用户选择"今晚"稍后提醒
  那么 计划提醒时间 = 当天 20:00

场景 AC-NT-02: 已过 20:00 的"今晚"
  假如 当前本地时间已过 20:00
  当 用户选择"今晚"
  那么 计划提醒时间 = 当前时间 + 1 小时，且不晚于勿扰开始
  并且 若落入勿扰则顺延至勿扰结束后的第一个可提醒时间

场景 AC-NT-03: 勿扰抑制
  假如 用户开启勿扰且提醒 deliverAt 落入勿扰时段
  当 到达计划提醒时间
  那么 提醒被抑制并顺延，产生 notification_suppressed_by_dnd
  并且 高优先级提醒默认不穿透勿扰

场景 AC-NT-04: 通知隐私标题
  当 系统生成任何通知、桌宠气泡或 Widget 文案
  那么 不包含具体任务标题，只使用泛化文案
```

### 6.9 账号与同步

```gherkin
场景 AC-AC-01: 游客可使用全部本地能力
  假如 用户处于 guest 模式
  那么 创建、完成、撤销、恢复、长期任务、怪兽成长均可用

场景 AC-AC-02: 游客合并必须确认
  假如 游客本地有数据且云端已有数据
  当 用户完成登录
  那么 GuestMergeJob 进入 pending_confirmation
  并且 未经用户确认不得执行合并

场景 AC-AC-03: 注销冷静期只读
  假如 账号处于 deletion_pending
  那么 不允许新增会被同步的任务、XP 或账号数据
  并且 用户可取消注销恢复 active

场景 AC-SY-01: 离线完成本地反馈优先
  假如 设备离线
  当 用户完成任务
  那么 完成反馈、XP、怪兽状态变化立即生效
  并且 同步操作进入 pending 队列异步交接

场景 AC-SY-02: 顺序回放与失败阻断
  假如 队列中有多个 pending 操作
  当 第 1 项同步失败
  那么 该项标记 failed 并阻断后续项，保留重试

场景 AC-SY-03: 回放幂等
  当 同一 dedupeKey 的操作被重复消费
  那么 只生效一次

场景 AC-SY-04: 远端完成回放 XP 幂等
  假如 远端 completionSource = sync_replay 的完成事件使用原始 eventId
  当 该 eventId 已在本地产生过 XP
  那么 回放不重复发放 XP
```

### 6.10 陪伴场域

```gherkin
场景 AC-CP-01: 快照过期处理
  假如 CompanionSnapshot 生成时间距现在超过 300 秒
  那么 外部场域将其标记为过期，触发刷新或显示保守过期文案

场景 AC-CP-02: Widget 只读
  那么 Widget 与桌宠不发出任何任务完成、XP、Streak 或怪兽状态变更事件
  并且 Widget 点击只回流 App（怪兽帧 --> 怪兽页；进度与激励 --> 今日页刷新）

场景 AC-CP-03: 外部桥失败不阻塞
  假如 Widget 桥或桌宠窗口不可用
  当 用户完成任务
  那么 任务与成长反馈链正常完成，不受外部桥失败影响

场景 AC-CP-04: 勿扰期桌宠低动效
  假如 当前处于勿扰时段
  那么 桌宠保持可见但不弹提醒气泡、不播放声音

场景 AC-CP-05: 快照随关键事件刷新
  当 发生任务创建 / 完成 / 撤销 / 恢复、XP 发放、怪兽状态变化、激励触发、Streak 更新、桌宠开关或通知到达
  那么 CompanionSnapshot 被刷新
```

### 6.11 展示顺序

```gherkin
场景 AC-SHOW-01: 多奖励展示顺序固定
  假如 一次完成同时触发今日激励、长期任务达成与升级
  那么 展示顺序为：完成即时反馈 --> 今日激励轻提示 --> 长期任务达成 --> XP / 升级
  并且 前日反馈不在该流程中展示，延后至次日打开
```

---

## 7. 埋点需求

1. 埋点事件使用 `snake_case`，与业务事件同名，口径以 `docs/contracts/analytics.md` v0.1.3 的 MVP 埋点表为准。
2. `monster_pet_reacted` 同时作为业务事件与埋点事件，不得命名分叉。
3. 禁止：记录惩罚型 `streak_break` 文案曝光；使用 `daily_clear`；使用 `desktop_pet_toggle`。

## 8. 资产与表现约束

1. 怪兽资源路径、sprite 元数据（`actionKey` / `frameCount` / `fps` / `loop` / 锚点 / `widgetFrameAssetId`）以 `docs/contracts/assets.md` v0.1.3 为准。
2. MVP 物种 `speciesKey = lister`，`styleLine ∈ {cool, soft, neutral}`，`stage ∈ {egg, child, teen, adult}`。
3. 动作 key 只允许契约列出的 17 个；禁止动作见 F-10。
4. Widget 静态帧必须使用 `widgetFrameAssetId`，不得从动画猜测（F-18）。
5. MVP 音效：`task_check` / `energy_fly` / `monster_eat` / `milestone` / `level_up` / `hatch`。

## 9. 非功能需求

1. **本地反馈优先**：任务完成、撤销、恢复的本地反馈不被同步、网络或外部桥阻塞。
2. **离线可用**：核心闭环（创建 --> 完成 --> XP --> 状态变化 --> 激励）在无网络下完整可用。
3. **幂等与可恢复**：所有 XP 与同步操作可重放且不产生重复效果。
4. **隐私**：任务标题不出主 App；外部场域与通知一律泛化文案。
5. **无压力体验**：全产品无惩罚、羞辱、失败文案；语言默认中文，支持中 / EN 切换。
6. **平台**：Flutter Web、Windows、Android 三端可构建可运行。

## 10. 出厂合格门禁

1. 第 6 章全部 AC 场景可自动化执行并通过。
2. 第 4.4 节 20 条禁止项静态检查无命中。
3. 节点 7 冻结的 13 项验收矩阵全绿：完成反馈链、任务撤销、`task_restored`、长期任务、无压清理、XP 幂等、Streak / `streak_break`、今日任务激励、离线完成、游客合并、通知勿扰、桌宠开关、Glance Widget。
4. 核心闭环不卡顿，打勾反馈不被同步或网络阻塞。

---

## 附录 A：术语表

| 术语 | 定义 |
|---|---|
| 可奖励任务 | `rewardEligible = true` 的任务 |
| 活跃日 | 本地时区内完成至少 1 个可奖励任务的自然日 |
| 今日任务激励 | 当日完成 3 / 6 个可奖励任务触发"小试身手" / "收获满满" |
| 无压清理 | 批量"放下"（`let_go`）、移到今日、移到收集箱的清理动作，摘要事件 `batch_cleanup_applied` |
| 冲正 | 撤销完成时追加负数 `xp_reverted`，不删除原 XP 记录 |
| 统一快照 | `CompanionSnapshot`，桌宠与 Widget 的唯一数据源 |
| 久别回归 | 连续 3 个完整自然日未打开后的 `missing` 状态 |

## 附录 B：PM 决策索引

本文档引用的全部裁决见 `docs/pm/pm-decisions.md`：D-001（SubTask 建模）、D-002（长期任务完成与取消）、D-003（task_restored）、D-004（今日任务激励）、D-005（桌宠开关）、D-006（streak_break）、D-007（无日期归属）、D-008（无回滚问题）、D-009（引导不产 XP）、D-010（+15 替代）、D-011（Streak 时区）、D-012（睡眠抚摸）、D-013（桌宠形态）、D-014（勿扰穿透）、D-015（游客合并确认）、D-016（15 天冷静期）、D-017（Widget 路线）、D-018（长期取消拆解处理）、D-019（无压清理语义）、D-020（重复任务边界）、D-021（XpLedger）、D-022（Widget 落点）、D-023（前日反馈时机）、D-024（回放 XP 幂等）、D-025（唤醒 10 分钟）、D-026（等级回退静默）、D-027（冷静期只读）、D-028（"今晚"锚点）、D-029（完成取消冲突）、D-030（missing 阈值）、D-031（激励不重复）、D-032（前日 0 完成）、D-033（批量清理撤销）、D-034（展示顺序）、D-035（勿扰桌宠）、D-036（隐私文案）、D-037 至 D-045（节点 6/7 技术边界与验证口径）。

---

变更记录：v1.0（2026-07-26，`AG-PM-00`）按《AI 时代的 PRD（输入）规范》首版，对齐契约 v0.1.3 与 MVP Beta 冻结口径。
