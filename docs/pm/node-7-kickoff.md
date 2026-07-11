---
status: live
type: plan
module: MVP Beta
last_updated: 2026-07-11
owner: AG-PM-00
---

# 节点 7 启动单

节点名称：QA 冻结与 MVP Beta。

目标：在节点 1 至节点 6 的已合并能力上完成 P0 全链路冻结，进入可试用 Beta。

当前基线：`master`，启动时 HEAD 为 `8f3970d`。

通过门槛：P0 全绿；核心闭环不卡顿；任务打勾反馈不被同步或网络阻塞；无未关闭的 P0 / P1 缺陷。

首轮执行：`N7-QA-001` 曾派给全新 `qa_inspector` Darwin（`019f4b17-7490-7fe3-93b9-bb988b8a8a48`）。该 Agent 报告两个候选测试门禁后，在 Android 构建等待中两次补充任务卡仍未返回最终 JSON，PM 已终止该线程，不采用其未完成裁决。

当前执行：任务已按失败处理协议拆分为 `N7-QA-BLOCKER-001`，派给全新 `qa_inspector` Curie（`019f4b29-a3d2-7552-8df8-b4f653d3b7fa`），独立复核两个 package 测试门禁与 Android debug APK 构建。

`N7-QA-BLOCKER-001` 裁决为 fail：Android debug APK 构建通过；`sprite_runtime` 与 `ui_kit` 的 `dart test` 返回 65。PM 证据分诊发现两者均为 Flutter package，测试导入 `flutter_test`，因此该结果属于测试运行器口径待复核，暂不生成代码返工卡。运行器口径已由 `D-045` 修正，下一步新派 QA 使用 Flutter 测试运行器复核。

运行器复核任务 `N7-QA-BLOCKER-002` 已派给全新 `qa_inspector` Ramanujan（`019f4b2c-9d13-7450-9a39-0303b106334f`），状态为质检中。

`N7-QA-BLOCKER-002` 裁决为 pass：`sprite_runtime` 与 `ui_kit` 的静态检查均通过，分别使用 `flutter test --no-pub` 验证 1 项测试通过；此前失败正式归类为 `runner_misuse`，无代码缺陷、无需返工。节点 7 可继续完整总冻结验收。

完整总冻结任务 `N7-QA-FINAL-001` 已派给全新 `qa_inspector` Erdos（`019f4b2e-eded-7db3-8b60-b6cd46c91ab8`），状态为质检中。

## 验收矩阵

1. 完成反馈链。
2. 任务撤销。
3. `task_restored`。
4. 长期任务。
5. 无压清理。
6. XP 幂等与回滚。
7. Streak / `streak_break`。
8. 今日任务激励与前日反馈。
9. 离线完成与同步回放。
10. 游客数据合并确认 / 取消。
11. 通知、勿扰与隐私标题。
12. PC 桌宠开关与只读快照。
13. Android Widget 快照、落点与刷新意图。

## 首轮总冻结任务卡

任务ID：N7-QA-001

目标：对当前 `master` 执行节点 7 首轮完整 P0 总冻结验收，并给出可执行裁决。

背景：节点 1 至节点 6 已完成；节点 6 已通过 `QA-N6-FINAL-002`。本轮不是增量功能验收，而是覆盖核心闭环、跨模块接口、构建产物和用户可见流程的 Beta 质量门。

验收标准：

1. 以上 13 个矩阵项逐项给出 `pass` / `fail`，每项附测试、源码定位或运行时证据。
2. 所有 package 的静态检查与测试、App 全量测试与静态检查完成并记录退出结果；纯 Dart package 使用 Dart 测试运行器，Flutter package 使用 Flutter 测试运行器。
3. Windows debug 与 Android debug APK 构建完成并记录退出结果。
4. 核心用户链路至少覆盖创建任务、完成、即时反馈、撤销、恢复和成长状态变化；确认反馈不等待网络或同步完成。
5. 离线回放、游客合并、通知勿扰、桌宠、Widget 的跨模块契约均有明确裁决。
6. 发现问题时按 P0 / P1 / P2 分级，给出复现步骤、证据、受影响文件和建议责任域；不得修复。
7. 最终只输出结构化 JSON，裁决只能是 `pass`、`fail` 或 `blocked`。

允许修改的文件范围：无，只读验收。

禁止事项：不得修改任何文件；不得提交；不得把未执行项记为通过；不得用截图存在代替行为断言；不得忽略测试或构建失败。

依赖：节点 6 完成，`QA-N6-FINAL-002` 通过。

## 返工规则

1. `pass`：进入 PM 预览验收与 Beta 收口。
2. `fail`：PM 按责任域生成返工卡，派回原常驻实现 Agent；返工完成后新派 QA 复检。
3. `blocked`：PM 先排除环境阻塞；涉及产品取舍时再请求用户裁决。

## 完整总冻结裁决

`N7-QA-FINAL-001` 由全新 `qa_inspector` Erdos（`019f4b2e-eded-7db3-8b60-b6cd46c91ab8`）执行，裁决为 fail。

通过项：完成反馈链、任务撤销、`task_restored`、长期任务、XP 幂等与回滚、Streak / `streak_break`、今日任务激励与前日反馈、游客合并、通知勿扰、PC 桌宠。

阻断项：

1. `N7-P0-001`：离线完成未进入可回放同步队列，缺少 `sync_replay` 执行路径。
2. `N7-P0-002`：任务与成长生命周期未自动刷新 CompanionSnapshot，Widget / 桌宠可能读取旧快照。
3. `N7-P0-003`：无压清理批量操作与整批撤销缺少 P0 可执行行为测试证据。

自动化与构建基线：7 个纯 Dart package、2 个 Flutter package、App 73 项测试与静态检查全部通过；Windows Debug 与 Android Debug APK 均构建通过。

## 返工任务卡 N7-R-001

任务ID：N7-R-001

目标：为离线任务操作建立可持久排队、可有界重试、可幂等回放的同步底座，并由 AppSyncController 暴露可接线能力。

背景：对应 `N7-P0-001`。当前同步域只有队列草稿和冲突策略，缺少离线任务操作的可执行回放路径。本轮仍遵守 D-037 / D-039，只做本地可测底座，不接真实云服务。

验收标准：

1. 离线任务操作至少覆盖完成、撤销完成、恢复，保留稳定操作 / 事件身份和顺序。
2. 本地存储支持待回放操作保存、读取、状态更新和稳定 ID 去重。
3. 仅在消费成功后标记完成；部分失败可重试，成功项不重复消费，顺序可验证。
4. `sync_replay` 保持原始事件身份并防重复消费，完成 / XP / Streak 事实不被旧状态覆盖。
5. AppSyncController 暴露入队与回放入口，但本卡不修改 UI、TaskSystemController 或 `main.dart`。
6. 自动化测试覆盖离线入队、重复入队、顺序回放、部分失败重试、成功项不重复和原事件身份保持。

允许修改的文件范围：`packages/sync_domain/**`、`packages/local_store/**`、`apps/list_monster_app/lib/sync/**`、`apps/list_monster_app/test/app_sync_controller_test.dart`、相关 pubspec / lock。

禁止事项：不得修改 `docs/**`、`main.dart`、`task_system_controller.dart`、账号 / 快照 / 通知模块；不得接真实网络、云或 Auth；不得改变冻结事件名和成长规则；不得提交或暂存。

依赖：`N7-QA-FINAL-001`。

当前处理：新常驻 backend_dev BE-Alpha（`019f4b3b-82a9-7790-89b8-a453a4f11950`）已完成 `N7-R-001A` 二次返工；`N7-QA-R-001A` 复检裁决 pass，`N7-R-001` 正式关闭。

### 返工补充卡 N7-R-001A

任务ID：N7-R-001A

目标：修正同步回放的顺序阻断语义，确保任何未解决失败项都不能被后续队列项越过。

验收标准：

1. 任一待处理项失败时本轮立即停止，后续项不被消费。
2. 失败项达到最大重试次数后仍保持可观察的失败 / 阻断状态，后续回放不得越过。
3. 已成功项不重复消费，稳定操作 / 事件身份不变。
4. 测试覆盖失败直至上限、后续项始终未消费、再次回放仍阻断和成功项不重复。

允许修改的文件范围：`apps/list_monster_app/lib/sync/**`、`apps/list_monster_app/test/app_sync_controller_test.dart`、`packages/sync_domain/test/**`、`packages/local_store/test/**`。

禁止事项：不得修改 UI、任务控制器、主入口、账号 / 快照 / 通知 / 原生平台和 `docs/**`；不得提交或暂存。

依赖：`N7-R-001`、`N7-QA-R-001` fail。

实现结果：失败项达到重试上限后保持失败并持续阻断后续队列项；新增连续失败和再次回放测试，App 全量测试 77 项通过，待 QA 裁决。

## 返工任务卡 N7-R-003

任务ID：N7-R-003

目标：补齐无压清理与整批撤销 P0 行为证据，并让任务生命周期具备向同步底座非阻塞交接的可验证能力。

背景：对应 `N7-P0-003`，同时为 `N7-P0-001` 的 App 接线准备任务侧交接点。

验收标准：

1. 批量清理只处理符合条件的未完成活动任务，保护已完成任务。
2. 批量摘要事件与逐任务事件可验证，清理不产生 XP。
3. 最近一批清理可整批撤销，逐任务恢复，重复撤销不产生重复副作用。
4. 完成、撤销完成、恢复等任务生命周期可向 `N7-R-001` 同步底座做非阻塞交接；交接失败不得阻塞本地完成反馈或重复发成长奖励。
5. 自动化测试覆盖批量清理、整批撤销、已完成任务保护、XP 不变、交接失败不阻塞本地反馈。

允许修改的文件范围：`apps/list_monster_app/lib/task_system_controller.dart`、`apps/list_monster_app/test/widget_test.dart`、新增的任务同步 / 清理专项测试、`packages/task_domain/test/**`。

禁止事项：不得修改 `main.dart`、`apps/list_monster_app/lib/sync/**`、快照 / Android / Windows / 账号模块和 `docs/**`；不得改变冻结 XP / Streak 规则；不得提交或暂存。

依赖：`N7-R-001`。

当前处理：新常驻 frontend_dev FE-Beta（`019f4b5f-bd19-7bc0-a111-9c5f89a9c3cd`）已完成 `N7-R-003A` 补证；`N7-QA-R-003A` 复检裁决 pass，`N7-R-003` 正式关闭。

### 返工补充卡 N7-R-003A

任务ID：N7-R-003A

目标：补齐任务生命周期非阻塞交接的专项证据，证明回调挂起或缺失时本地即时反馈与成长状态仍先完成。

验收标准：

1. 永不完成的交接回调不得阻塞本地任务完成。
2. 挂起场景下即时反馈、XP ledger、Streak / 今日激励在交接完成前已更新，奖励只发生一次。
3. 未注入交接回调时，完成、撤销、恢复仍正常并保留本地交接记录。
4. 抛错回调、稳定事件身份、无压清理和整批撤销测试继续通过。

允许修改的文件范围：`apps/list_monster_app/test/task_system_controller_sync_test.dart`、`apps/list_monster_app/lib/task_system_controller.dart`、`apps/list_monster_app/test/no_pressure_cleanup_test.dart`。

禁止事项：不得修改主入口、同步 / 存储 / 快照 / 原生平台 / 账号 / 通知和 `docs/**`；不得提交或暂存。

依赖：`N7-R-003`、`N7-QA-R-003` fail。

实现结果：仅修改任务生命周期专项测试，补齐永久挂起与缺失回调证据；专项 6 项、App 83 项、task_domain 23 项及静态分析通过，待 QA 裁决。

## 返工任务卡 N7-R-002

任务ID：N7-R-002

目标：把任务 / XP / Streak 生命周期接入同步队列与 CompanionSnapshot 自动刷新，让 Widget 和桌宠读取最新快照。

背景：对应 `N7-P0-002`，并完成 `N7-P0-001` 的 App 组装。当前只有手动或 Widget 返回 App 时刷新快照。

验收标准：

1. 创建、完成、撤销、恢复及相关成长状态变化在本地提交后触发快照刷新。
2. 自动刷新为 best-effort，外部桥或同步失败不得阻塞任务打勾与即时成长反馈。
3. App 把任务侧非阻塞交接与 `N7-R-001` 队列 / 回放能力组装起来，保留稳定事件身份和幂等边界。
4. 手动刷新、Widget deep link、刷新意图和隐私保护不得回归。
5. 自动化测试从 App 操作入口验证持久化快照会随任务生命周期更新，且不会产生额外 XP / Streak。

允许修改的文件范围：`apps/list_monster_app/lib/main.dart`、`apps/list_monster_app/lib/companion_snapshot/**`、`apps/list_monster_app/test/companion_snapshot_*`、`apps/list_monster_app/test/android_widget_*`、必要的 App 接线专项测试。

禁止事项：不得修改原生 Android / Windows、任务域 / 同步域 / 本地存储底座、账号 / 通知模块和 `docs/**`；不得接真实网络或云；不得提交或暂存。

依赖：`N7-R-001`、`N7-R-003`。

当前处理：Widget / 快照职责继任 frontend_dev FE-Gamma-2（`019f4e9f-7a50-7c12-873c-d5b1fc9ca713`）已完成 `N7-R-002`；`N7-QA-R-002` 复检裁决 pass，`N7-P0-002` 关闭。三项 P0 阻断均已关闭。

## 最终总冻结裁决 N7-QA-FINAL-002

全新 `qa_inspector` Carson（`019f4eb8-24a8-7133-835d-d0cd53b3e30f`）裁决为 pass，并已关闭：13 项冻结矩阵全部通过；App 85 项测试、静态分析、7 个纯 Dart package、2 个 Flutter package、Windows Debug、Android Debug APK 与 `git diff --check` 全部通过。

PM 预览验收未通过：Flutter Web Release 可完成构建并在 `http://127.0.0.1:5360/` 提供服务，但首帧为空白，浏览器控制台报错 `Unsupported operation: Platform._operatingSystem`。该缺陷属于平台桥选择逻辑的 Web 兼容 P0，节点 7 暂不关闭。

## PM 预览返工任务卡 N7-R-002B

任务ID：N7-R-002B

目标：修复 Flutter Web 启动时因平台判断触发 `Platform._operatingSystem` 异常而空白，恢复 Web 真实预览，同时保持 Android Widget 与 Windows 行为不回归。

验收标准：

1. Flutter Web Release 启动后正常渲染首屏，不出现平台判断异常。
2. 默认 Android Widget 桥仍仅在 Android 真机路径启用；Web 与 Windows 不发起 Android MethodChannel 调用。
3. 注入式 Widget bridge、任务完成 / 撤销 / 恢复后的 CompanionSnapshot 刷新链路不退化。
4. 自动化测试覆盖 Web 安全的平台选择逻辑。
5. App 全量测试与静态分析通过。
6. Web Release、Windows Debug、Android Debug APK 均构建成功。

允许修改的文件范围：`apps/list_monster_app/lib/companion_snapshot/android_widget_bridge.dart`、`apps/list_monster_app/lib/main.dart`、`apps/list_monster_app/test/task_lifecycle_snapshot_test.dart`、必要的单个平台桥选择测试文件。

禁止事项：不得修改其他 package 或 PM 文档；不得引入新依赖；不得改变任务生命周期事件语义、`operationId` 或同步队列顺序；不得删除 Android Widget；不得提交或推送。

依赖：`N7-R-002`、`N7-QA-FINAL-002` pass、PM Web 预览 fail。

实现结果：原实现 frontend_dev FE-Gamma-2（`019f4e9f-7a50-7c12-873c-d5b1fc9ca713`）仅修改 Android Widget 平台桥并新增平台选择测试；自测 App 88 项、静态分析、Web Release、Windows Debug、Android Debug APK 全部通过。

复检结果：全新 `qa_inspector` Singer（`019f4ecd-19ed-7d31-b34c-26aedb86e154`）使用独立 Web 服务执行 `N7-QA-R-002B`，裁决 pass 并已关闭。App 88 项、静态分析、Web / Windows / Android 构建、Widget 与生命周期专项、`git diff --check` 全部通过；独立 Web 首屏正常，控制台无 error / warning。

PM 预览验收：pass。PM 使用无旧 Service Worker 缓存的 `http://127.0.0.1:5372/` 验证首屏、任务创建、完成、撤销恢复、怪兽页、我的页与桌宠入口，控制台无 error / warning。节点 7 达到 MVP Beta 冻结门槛，正式完成。
