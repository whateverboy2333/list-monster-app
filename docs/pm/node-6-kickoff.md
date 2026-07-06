# 节点 6 启动记录

日期：2026-07-06

节点名称：账号 / 同步 / 通知 / 陪伴场域。

状态：已启动首轮只读摸底，暂不进入实现写码。

## 启动原则

1. 桌宠和 Android Widget 只读统一 CompanionSnapshot，不自行计算任务、XP、Streak 或怪兽状态。
2. 登录后游客数据与已有云端数据合并必须由用户确认。
3. 勿扰期间默认不允许高优先级提醒穿透，后续可做用户显式 opt-in。
4. 账号注销设置 15 天冷静期。
5. Android Widget 技术路线优先采用 Glance，遇到兼容、样式或性能限制再局部退回 RemoteViews。
6. 任务标题隐私优先，桌宠提醒气泡和通知默认不展示具体任务标题。

## 首批任务卡

任务ID: N6-R-001

目标: 摸清账号、游客、云同步、本地通知和勿扰在当前代码中的已有基础与缺口。

背景: 节点 6 需要补齐游客模式、登录、游客数据合并确认、云同步、本地通知、勿扰时段和 15 天注销冷静期。当前只允许做只读调研，不允许实现。

验收标准:

1. 列出相关包、模块、页面、控制器、测试文件的现状。
2. 标出哪些能力已有占位，哪些完全缺失。
3. 给出后续实现任务拆分建议，并确保建议中的文件范围互不重叠。
4. 明确同步冲突中哪些事实不得被简单 LWW 覆盖。
5. 输出不超过 5 条阻塞问题或需要 PM 裁决的问题。

允许修改的文件范围: 无。

禁止事项: 不许改代码、不许改文档、不许提交、不许引入依赖。

依赖: 节点 1-5 已合并状态。

建议 Agent: explorer，按 AG-SYNC-01 视角执行。

任务ID: N6-R-002

目标: 摸清 CompanionSnapshot、PC 第二窗口桌宠、Android Glance Widget 在当前代码中的已有基础与缺口。

背景: 节点 6 要求桌宠和 Widget 只读统一快照，不自己计算任务、XP、Streak。当前只做只读调研，不允许实现。

验收标准:

1. 列出 companion_contract、客户端、Windows、Android、Widget 相关目录现状。
2. 判断 CompanionSnapshot 字段是否足够支撑桌宠和 Widget。
3. 标出 PC 第二窗口方案的工程入口与风险。
4. 标出 Android Glance Widget 方案的工程入口与风险。
5. 给出后续实现任务拆分建议，并确保建议中的文件范围互不重叠。

允许修改的文件范围: 无。

禁止事项: 不许改代码、不许改文档、不许提交、不许引入依赖。

依赖: 节点 1-5 已合并状态。

建议 Agent: explorer，按 AG-COMPANION-01 视角执行。

任务ID: N6-R-003

目标: 产出节点 6 QA 验收矩阵草案。

背景: 节点 6 覆盖账号、同步、通知、勿扰、桌宠、Widget 与统一快照，需要先明确验收边界，避免实现后返工。

验收标准:

1. 覆盖游客模式、登录、游客合并确认、云同步、注销冷静期。
2. 覆盖本地通知、勿扰时段、隐私标题、通知点击回流。
3. 覆盖 CompanionSnapshot 刷新、过期、隐私、去重。
4. 覆盖 PC 桌宠打开 / 关闭、勿扰期间低动效、提醒气泡不暴露任务标题。
5. 覆盖 Android Widget 只读快照、点击回 App、不自行计算 XP / Streak / 任务。
6. 每条验收项都能被自动化或人工步骤验证。

允许修改的文件范围: 无。

禁止事项: 不许改代码、不许改文档、不许提交、不许引入依赖。

依赖: 节点 6 路线图与 PM 已裁决项。

建议 Agent: qa_inspector，按 AG-QA-01 视角执行。

## 首轮摸底结果

N6-R-001 同步与通知摸底结论：

1. 当前只有契约和少量占位，账号、云同步、系统通知、勿扰和注销冷静期均未真正实现。
2. `sync_domain` 只有队列草稿和去重键，且 operationType 仍有 enum name 与契约 snake_case 不一致的风险。
3. `local_store` 仍是空壳，App 任务数据主要是内存态。
4. `task_domain` 已有 ReminderIntent 和 respectDnd 字段，但没有勿扰设置模型、顺延规则或真实通知调度。
5. 同步冲突中，任务完成、XP ledger、Streak / Monster 派生、tombstone / restore、长期任务达成、游客合并和注销冷静期均不得被简单 LWW 覆盖。

N6-R-002 陪伴场域摸底结论：

1. 文档版 CompanionSnapshot 足够支撑 P0，但代码版 CompanionSnapshotDraft 严重不足。
2. App 缺统一快照生成器和持久化 / 广播链路。
3. Windows 仍是 Flutter 默认单窗口 runner。
4. Android 无 Glance、AppWidgetProvider、Widget provider 配置或资源帧映射。
5. Widget 必须读取持久化快照，否则会违反“不自己计算任务、XP、Streak”的原则。

N6-R-003 QA 矩阵结论：

1. 已形成 20 条节点 6 验收项。
2. 覆盖账号、游客合并、同步冲突、注销冷静期、通知勿扰、通知隐私、通知回流、CompanionSnapshot、PC 桌宠和 Android Widget。
3. 系统通知、Glance Widget 和外部场域隐私需要真机 / 桌面人工验收配合。

## PM 新增裁决

1. 节点 6 首轮先做本地可测的领域模型、契约、规则和适配端口，不接真实第三方云服务或真实第三方 Auth。
2. 登录 Provider 首轮只实现本地模拟登录流程，phone / wechat 仅保留枚举或能力占位。
3. 本地存储首轮先建立端口和内存 / 测试实现，不引入数据库依赖。
4. 通知首轮先完成领域层规则，不立即接真实系统通知插件。
5. Widget 点击怪兽状态帧进入怪兽页；点击今日进度、今日任务激励、前日反馈和过期态进入今日页。

详见 [pm-decisions.md](pm-decisions.md) 的 D-037 至 D-041。

## 实现 Wave A 任务卡

任务ID: N6-I-101

目标: 补齐 CompanionSnapshot 代码契约。

背景: 文档版 CompanionSnapshot 已冻结，但 `companion_contract` 代码中只有 CompanionSnapshotDraft，无法支撑桌宠和 Widget 只读统一快照。

验收标准:

1. 字段覆盖 `docs/contracts/companion-snapshot.md` 的 P0 快照字段。
2. 支持 JSON 往返。
3. 支持过期判断。
4. 支持任务标题外部隐藏开关。
5. 单测覆盖正常快照、过期快照、隐私隐藏和枚举值。

允许修改的文件范围: `packages/companion_contract/**`

禁止事项: 不许修改 App、Windows、Android、docs、其他 packages；不许引入新依赖；不许提交。

依赖: 无。

任务ID: N6-I-102

目标: 补齐提醒与勿扰领域规则。

背景: 当前 task_domain 已有 ReminderIntent 和 respectDnd 字段，但缺少勿扰时段、跨天判断、“今晚”顺延、通知隐私事件等规则承载。

验收标准:

1. 支持勿扰时段跨天判断。
2. 默认不允许高优先级提醒穿透勿扰。
3. “今晚”提醒按 PM 裁决锚定本地 20:00、过点使用 now + 1 hour，且不得落入勿扰。
4. 若落入勿扰，顺延到勿扰结束后的第一个可提醒时间。
5. 测试覆盖跨天勿扰、今晚过点、顺延、隐私标题和不穿透。

允许修改的文件范围: `packages/task_domain/**`

禁止事项: 不许修改 App、Android、Windows、docs、其他 packages；不许引入新依赖；不许提交。

依赖: 无。

任务ID: N6-I-103

目标: 补齐同步队列基础契约与冲突判定。

背景: 当前 sync_domain 只有队列草稿和去重键，且 operationType 与契约 snake_case 存在偏差。节点 6 需要先保护任务完成、XP、Streak、tombstone、游客合并和注销冷静期事实不被简单 LWW 覆盖。

验收标准:

1. operationType 使用契约 snake_case。
2. 队列项支持 payload、baseRevision、status、retry 或等价字段。
3. 提供完成 / 取消并发冲突判定。
4. 提供 XP ledger、tombstone / restore、游客合并、注销冷静期不得 LWW 覆盖的策略表达。
5. 单测覆盖去重键、snake_case、完成取消冲突、XP 不覆盖、注销冷静期冲突。

允许修改的文件范围: `packages/sync_domain/**`

禁止事项: 不许修改 App、task_domain、companion_contract、docs、其他 packages；不许引入新依赖；不许提交。

依赖: 无。

## Wave A 实现回收

N6-I-101 已完成：

1. 变更范围为 `packages/companion_contract/**`。
2. CompanionSnapshot 契约模型、枚举、JSON 往返、过期判断、隐私隐藏已补齐。
3. 包内 `dart analyze` 与 `dart test` 通过。

N6-I-102 已完成：

1. 变更范围为 `packages/task_domain/**`。
2. 勿扰时段跨天判断、高优先级默认不穿透、今晚提醒顺延、隐私标题承载已补齐。
3. 包内 `dart analyze` 与 `dart test` 通过。

N6-I-103 已完成：

1. 变更范围为 `packages/sync_domain/**`。
2. 同步队列契约、snake_case operationType、完成 / 取消冲突、受保护事实策略已补齐。
3. 包内 `dart analyze` 与 `dart test` 通过。

## 当前等待

`QA-N6-A-001` 功能项与测试项均通过，但将 PM 自己允许维护的 `docs/pm/` 看板与决策记录误判为实现 Agent 越界，因此流程裁决为 fail。

PM 裁决：`docs/pm/` 变更属于 PM 跟踪记录，不计入实现 Agent 文件范围越界。需要以修正后的口径重新复检，复检只检查实现文件是否限于 `packages/companion_contract/**`、`packages/task_domain/**`、`packages/sync_domain/**`，并允许 PM 文档存在独立变更。

`QA-N6-A-002` 复检裁决为 pass：

1. CompanionSnapshot 契约覆盖、JSON、过期、隐私隐藏通过。
2. 提醒与勿扰跨天、今晚顺延、隐私标题和默认不穿透通过。
3. 同步队列 snake_case、去重键、队列字段、受保护事实策略和冲突判定通过。
4. 三个包的 `dart analyze` 与 `dart test` 均通过。
5. 实现变更限于 `packages/companion_contract/**`、`packages/task_domain/**`、`packages/sync_domain/**`。

Wave A 判定：通过 QA，可提交。

## 后续 Wave B 候选

任务ID: N6-I-104

目标: 在 App 内生成统一只读 CompanionSnapshot。

背景: CompanionSnapshot 代码契约已补齐，但 App 还没有统一快照生成器。桌宠和 Widget 后续必须只读该快照，不能自行计算任务、XP、Streak。

验收标准:

1. 新增 App 层快照生成器，只读取 `TaskSystemController` 的公开状态或等价只读输入。
2. 输出 `packages/companion_contract` 中的 `CompanionSnapshot`。
3. 默认 `hideTaskTitlesOutsideApp = true`，外部展示文案不包含具体任务标题。
4. 快照包含今日进度、XP / Streak 摘要、怪兽状态、资源 ID、过期时间。
5. 测试覆盖正常快照、隐私隐藏、过期时间和不直接计算 XP / Streak。

允许修改的文件范围: `apps/list_monster_app/lib/companion_snapshot/**`、`apps/list_monster_app/test/companion_snapshot_*`

禁止事项: 不许修改 `main.dart`、`task_system_controller.dart`、Android、Windows、docs、其他 packages；不许引入新依赖；不许提交。

依赖: N6-I-101。

任务ID: N6-I-105

目标: 建立本地存储端口与内存 / 测试实现。

背景: 当前 `local_store` 仍为空壳。节点 6 后续需要保存账号、任务快照、事件、同步队列、通知设置和 CompanionSnapshot，但首轮不引入数据库依赖。

验收标准:

1. 定义本地存储端口，覆盖账号状态、任务快照、事件记录、同步队列、通知设置、CompanionSnapshot。
2. 提供内存实现用于测试。
3. 不绑定真实数据库或云服务。
4. 测试覆盖写入、读取、覆盖更新、队列追加、快照过期读取。
5. 包内 `dart analyze` 与 `dart test` 通过。

允许修改的文件范围: `packages/local_store/**`

禁止事项: 不许修改 App、docs、其他 packages；不许引入新依赖；不许提交。

依赖: N6-I-101、N6-I-103。

任务ID: N6-I-106

目标: 建立账号 / 游客 / 注销冷静期领域模型。

背景: PM 已裁决新建 `packages/account_domain/`。首轮只做本地可测领域模型，不接真实第三方 Auth。

验收标准:

1. 支持 guest、registered、deletion_pending、deleted 等账号状态。
2. 支持 phone / wechat Provider 枚举或能力占位，但只实现本地模拟登录所需模型。
3. 支持 GuestMergeJob 的 pending_confirmation、confirmed、cancelled、merged 等状态。
4. 支持 15 天注销冷静期、取消注销恢复 active、冷静期只读判断。
5. 测试覆盖游客创建、模拟登录、游客合并确认 / 取消、注销冷静期、取消注销、冷静期只读。
6. 包内 `dart analyze` 与 `dart test` 通过。

允许修改的文件范围: `packages/account_domain/**`

禁止事项: 不许修改 App、sync_domain、local_store、docs、其他 packages；不许接真实 Auth；不许引入新依赖；不许提交。

依赖: D-042。

## 当前等待

N6-I-104 已完成：

1. 变更范围为 `apps/list_monster_app/lib/companion_snapshot/**` 与 `apps/list_monster_app/test/companion_snapshot_*`。
2. App 层统一 CompanionSnapshot 生成器已完成，默认隐藏任务标题。
3. `flutter test` 与 `dart analyze` 通过。

N6-I-105 已完成：

1. 变更范围为 `packages/local_store/**`。
2. 本地存储端口和 MemoryLocalStore 已完成。
3. 包内 `dart analyze` 与 `dart test` 通过。

N6-I-106 已完成：

1. 变更范围为 `packages/account_domain/**`。
2. 账号、游客、模拟登录、游客合并和注销冷静期领域模型已完成。
3. 包内 `dart analyze` 与 `dart test` 通过。

`QA-N6-B-001` 复检裁决为 pass：

1. App 快照生成器只读 `TaskSystemController` 公开状态或等价输入，输出 CompanionSnapshot，默认隐藏任务标题。
2. local_store 本地存储端口和 MemoryLocalStore 覆盖账号、任务快照、事件、同步队列、通知设置和 CompanionSnapshot。
3. account_domain 覆盖账号状态、模拟登录、游客合并和注销冷静期。
4. `apps/list_monster_app` 的 `flutter test` 37 项通过，`dart analyze .` 通过。
5. `packages/local_store` 与 `packages/account_domain` 的 `dart analyze` / `dart test` 通过。
6. 实现范围合规。

Wave B 判定：通过 QA，可提交。

## 后续 Wave C 候选

任务ID: N6-I-107

目标: 将账号 / 本地存储 / 快照生成接入 App 壳与“我的”页。

背景: account_domain 与 local_store 底座已经完成，但 App 还没有账号状态、游客合并确认、注销冷静期的 UI / 控制器入口。

验收标准:

1. “我的”页能展示游客 / 已登录 / 注销冷静期状态。
2. 支持本地模拟登录，不接真实 Auth。
3. 登录时若存在游客数据与模拟云端数据冲突，必须展示合并确认；取消时两侧数据不变。
4. deletion_pending 状态下，除取消注销外，App 层新增会同步的数据入口应被阻止或显示只读提示。
5. 账号状态和合并确认使用 local_store 端口持久化或等价内存实现。
6. 测试覆盖游客态、模拟登录、合并确认 / 取消、注销冷静期只读和取消注销。

允许修改的文件范围: `apps/list_monster_app/lib/account/**`、`apps/list_monster_app/lib/sync/**`、`apps/list_monster_app/lib/main.dart`、`apps/list_monster_app/pubspec.yaml`、`apps/list_monster_app/pubspec.lock`、`apps/list_monster_app/test/account_sync_*`、`apps/list_monster_app/test/widget_test.dart`

禁止事项: 不许修改通知目录、companion_snapshot 目录、Android、Windows、docs、packages；不许接真实 Auth；不许引入外部依赖；不许提交。

依赖: N6-I-104、N6-I-105、N6-I-106。

任务ID: N6-I-108

目标: 建立通知适配层端口，消费 task_domain 勿扰与隐私规则。

背景: task_domain 已补齐勿扰和提醒顺延领域规则。节点 6 首轮通知不接真实系统插件，只做 App 内通知适配端口和可测试调度计划。

验收标准:

1. 定义通知适配端口，支持权限状态、调度、取消、点击回流意图。
2. 调度计划消费 task_domain 的勿扰、今晚顺延和隐私标题规则。
3. 默认通知 payload 不包含具体任务标题。
4. 勿扰期间默认不穿透，顺延到下一个可提醒时间。
5. 测试覆盖权限拒绝、调度、取消、勿扰顺延、隐私标题、点击回流意图。

允许修改的文件范围: `apps/list_monster_app/lib/notifications/**`、`apps/list_monster_app/test/notifications/**`

禁止事项: 不许修改 main.dart、pubspec、Android、Windows、docs、packages、account、sync、companion_snapshot；不许接真实系统通知插件；不许引入新依赖；不许提交。

依赖: N6-I-102、N6-I-105。

任务ID: N6-I-109

目标: 建立 CompanionSnapshot 持久化刷新链路。

背景: App 快照生成器和 local_store 已完成，但还缺统一刷新 / 持久化链路。桌宠和 Widget 后续必须只读取持久化 CompanionSnapshot。

验收标准:

1. 提供快照刷新服务，将 CompanionSnapshot 生成后写入 local_store。
2. 任务创建 / 完成 / 撤销 / 恢复、XP / Streak 变化、App 打开可触发刷新入口或等价可测试方法。
3. 读取过期快照时能返回过期态或触发刷新建议。
4. 不直接计算任务、XP、Streak，只消费快照生成器与 local_store。
5. 测试覆盖刷新写入、过期读取、重复刷新不重复产生 XP / Streak、敏感标题不落盘到外部文案。

允许修改的文件范围: `apps/list_monster_app/lib/companion_snapshot/**`、`apps/list_monster_app/test/companion_snapshot_*`

禁止事项: 不许修改 main.dart、pubspec、Android、Windows、docs、packages、account、sync、notifications；不许引入新依赖；不许提交。

依赖: N6-I-104、N6-I-105。

## 当前等待

N6-I-107 已完成：

1. 变更范围为 `apps/list_monster_app/lib/account/**`、`apps/list_monster_app/lib/sync/**`、`apps/list_monster_app/lib/main.dart`、App pubspec 和账号同步测试。
2. “我的”页展示游客 / 已登录 / 注销冷静期状态。
3. 本地模拟登录、游客数据合并确认、冷静期只读门禁和取消注销已接入。
4. `flutter test` 全量通过；实现 Agent 报告 `flutter analyze` 遇到分析服务 JSON 截断异常，未产出代码诊断。

N6-I-108 已完成：

1. 变更范围为 `apps/list_monster_app/lib/notifications/**` 与 `apps/list_monster_app/test/notifications/**`。
2. 通知适配端口支持权限状态、调度、取消、点击回流意图。
3. 调度计划消费提醒意图，不包含具体任务标题，勿扰默认顺延。

N6-I-109 已完成：

1. 变更范围为 `apps/list_monster_app/lib/companion_snapshot/**` 与 `apps/list_monster_app/test/companion_snapshot_*`。
2. CompanionSnapshot 刷新服务已将生成结果写入 local_store。
3. 过期读取、重复刷新无成长副作用、敏感标题不落盘均已覆盖。

`QA-N6-C-001` 复检裁决为 pass：

1. “我的”页账号状态、模拟登录、游客合并确认、注销冷静期只读和取消注销通过。
2. 通知适配端口、权限状态、调度、取消、点击回流、勿扰顺延和隐私标题通过。
3. CompanionSnapshot 持久化刷新、过期读取、重复刷新无成长副作用和敏感标题不落盘通过。
4. `apps/list_monster_app` 的 `flutter test` 57 项通过。
5. `apps/list_monster_app` 的 `dart analyze .` 通过。
6. 实现范围合规。

Wave C 判定：通过 QA，可提交。

## 后续 Wave D 候选

任务ID: N6-I-110

目标: PC 第二窗口桌宠基础壳。

建议允许修改的文件范围: `apps/list_monster_app/windows/**`、`apps/list_monster_app/lib/desktop_pet/**`、`apps/list_monster_app/test/desktop_pet_*`

依赖: N6-I-104、N6-I-109。

任务ID: N6-I-111

目标: Android Glance Widget 原生壳。

建议允许修改的文件范围: `apps/list_monster_app/android/**`

依赖: N6-I-104、N6-I-109。

任务ID: N6-I-112

目标: 节点 6 端到端 QA 冻结前验收。

建议允许修改的文件范围: 无，只读验收。

依赖: N6-I-107、N6-I-108、N6-I-109，以及后续桌宠 / Widget 实现。
