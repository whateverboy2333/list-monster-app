# Wave 0 多 Agent 控制面板

## 当前状态

已创建 8 个 Codex 子线程，当前线程为 `AG-PM-00` 项目经理中枢。

节点路线图已冻结，唯一事实源为 [node-roadmap-freeze.md](node-roadmap-freeze.md)。后续不得擅自修改节点编号、节点名称或节点定义。

节点 1：契约冻结已完成。`docs/contracts/` 已升级并冻结为 v0.1.3，作为节点 2“工程骨架 + 初始 commit”的输入基线。8 个子 Agent 均已收到冻结公告并 ACK。

节点 2：工程骨架 + 初始 commit，已完成。Flutter monorepo 基础工程已建立，项目可通过 Web 本地启动、基础测试和 lint 已通过，并形成初始 commit。

节点 3：核心闭环 Alpha，已通过 PM 验收并合并入主分支。

节点 4：任务系统 P0 完成，已通过 PM 验收，作为节点 5 输入基线。

节点 5：怪兽养成与激励 P0 已通过 QA 返工复检与 PM 验收，并已合并入 `master`。`QA-N5-001` 最终质检曾裁决为 fail，`FE-N5-001` 已完成返工；`QA-N5-002` 复检裁决为 pass，`flutter test` 33 项通过，相关 analyze 与 domain 测试通过。

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

## 最近完成节点：节点 7

节点 7 名称：QA 冻结与 MVP Beta。

最终结果：完成。`N7-QA-FINAL-002` 的 13 项冻结矩阵通过；PM Web 预览发现的平台兼容 P0 已由 `N7-R-002B` 修复，`N7-QA-R-002B` 独立复检与 PM 重验均通过。

关键证据：App 88 项测试、静态分析、全部 package 测试与分析、Web Release、Windows Debug、Android Debug APK、真实 Web 首屏与核心交互全部通过。

节点 7 交付摘要详见 [node-7-delivery-summary.md](node-7-delivery-summary.md)。

## 已完成范围

节点 6 范围：

```text
游客模式
登录
游客数据合并确认
云同步契约
本地通知
勿扰时段
15 天注销冷静期
PC 第二窗口桌宠
Android Widget
CompanionSnapshot
```

关键验收：

桌宠和 Widget 只读统一快照，不自己计算任务、XP、Streak。

节点 6 交付摘要详见 [node-6-delivery-summary.md](node-6-delivery-summary.md)。

## 当前推进节点

冻结路线图中的节点 1 至节点 7 已全部完成，当前没有已批准的新开发节点。节点 7 启动与返工记录详见 [node-7-kickoff.md](node-7-kickoff.md)。

## 编制注册表

| 角色 | 线程昵称 | Agent ID | 状态 | 已完成任务数 |
|---|---|---|---|---:|
| frontend_dev | FE-Alpha（历史） | `019f3cdc-58d6-76f2-9c01-738c3830e543` | 已失效 | 1 |
| frontend_dev | FE-Alpha | `019f4b51-2eb0-7971-a89b-2ffe2d1b8e97` | 已裁撤：线程系统错误 | 1 |
| frontend_dev | FE-Beta | `019f4b5f-bd19-7bc0-a111-9c5f89a9c3cd` | 已裁撤：节点 7 收尾 | 1 |
| frontend_dev | FE-Gamma（历史） | `019f3cdc-5b80-7c90-9568-86118071343f` | 已失效 | 2 |
| frontend_dev | FE-Gamma-2（工具昵称 FE-Alpha） | `019f4e9f-7a50-7c12-873c-d5b1fc9ca713` | 已裁撤：节点 7 收尾 | 2 |
| backend_dev | BE-Alpha | `019f4b3b-82a9-7790-89b8-a453a4f11950` | 已裁撤：线程记录已失效 | 1 |
| frontend_dev | FE-Pixel | `/root/fe_pixel` | 待命 | 7 |
| frontend_dev | FE-Pixel-2 | `/root/fe_pixel_2` | 待命 | 1 |
| frontend_dev | FE-Craft-Pixel | `/root/fe_craft_pixel` | 待命 | 6 |

节点 7 QA 临时实例：Darwin 已终止；Curie、Ramanujan、Erdos、Mencius、Aquinas、Kepler、Noether、Carson、Singer 已出具裁决并关闭。

节点 7 编制交接：BE-Alpha 完成离线队列、顺序回放、幂等与失败阻断底座；FE-Beta 完成无压清理和生命周期非阻塞交接补证；FE-Gamma-2 完成生命周期快照装配、Widget / 桌宠刷新及 Web 平台桥修复。后续风险集中在真实云接入与 Android 真机流转。

范围：

```text
完成反馈链
任务撤销
task_restored
长期任务
无压清理
XP 幂等
Streak / streak_break
今日任务激励
离线完成
游客合并
通知勿扰
桌宠开关
Android Widget
```

关键验收：

P0 全绿，核心闭环不卡顿，打勾反馈不被同步或网络阻塞。

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

## PRD 基线登记（2026-07-26）

`AG-PM-00` 按用户提供的《AI 时代的 PRD（输入）规范》完成 MVP 全量 PRD：
[list-monster-mvp-prd.md](list-monster-mvp-prd.md)（v1.0）。

1. 结构对齐规范三要素：显式上下文（第 4 章，含 20 条全局禁止项 F-01 至 F-20）、状态机闭环（第 5 章，12 组状态 / 规则矩阵）、可自动化验证断言（第 6 章，54 条 Gherkin 场景，编号 AC-*）。
2. 内容对齐契约 v0.1.3、PM 裁决 D-001 至 D-045 与节点 1-7 冻结口径；字段级事实源仍为 `docs/contracts/`，PRD 不重复定义字段。
3. 出厂合格门禁见 PRD 第 10 章：54 条 AC 全过 + 20 条禁止项静态检查无命中 + 节点 7 的 13 项冻结矩阵全绿。
4. 用途：作为后续 AI AutoPilot 开发或新一轮产品节点的需求输入基线。

## 像素怪兽资产任务（2026-07-30）

| 任务ID | 执行线程 | 状态 | 允许修改范围 | 验收 |
|---|---|---|---|---|
| T-PIX-001 | FE-Pixel | 已完成 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/**` | QA-PIX-001：pass |
| T-PIX-002 | FE-Pixel | 已完成 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/**` | QA-PIX-002：pass |
| T-PIX-003 | FE-Pixel | 质检未通过 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/**` | QA-PIX-003：fail，背景与落地阴影仍有平滑过渡 |
| T-PIX-003-R1 | FE-Pixel | 复检未通过 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/**` | QA-PIX-004：fail，空白背景仍含细粒度色值噪声 |
| T-PIX-003-R2 | FE-Pixel | 复检未通过 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/**` | QA-PIX-005：fail，边界空白区残留 53 个非目标色像素 |
| T-PIX-003-R3 | FE-Pixel | 已完成 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/**` | QA-PIX-006：pass |

范围：将用户提供的四形态清单卷轴怪兽设定图转为统一色板、统一像素密度的彩色像素风概念资产；不修改代码、旧版视觉稿或应用配置。

独立质检结论：六项验收标准全部通过；PNG 格式有效，尺寸为 1672 × 941，无阻塞问题。

T-PIX-002 返工结论：v2 相较 v1 显著扩大角色轮廓与内部结构的像素簇，减少细密纹理与色阶，同时保留四形态及关键识别元素；QA-PIX-002 六项对比验收全部通过。

T-PIX-003 最终结论：第三版继续扩大像素网格、压缩色阶和装饰纹理；经 R1 至 R3 逐步硬化落地影并纯色化外部背景。QA-PIX-006 最终复检 5 项全部通过，四边与空白抽样区均为单一 RGB(254,250,236)，非背景差异像素数为 0。

## 宠物蛋像素资产任务（2026-07-30）

| 任务ID | 执行线程 | 状态 | 允许修改范围 | 验收 |
|---|---|---|---|---|
| T-EGG-001 | FE-Pixel | 质检未通过 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/eggs/**` | QA-EGG-001：fail，A视角区分不足且主体残留柔化色阶 |
| T-EGG-001-R1 | FE-Pixel | 已完成 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/eggs/**` | QA-EGG-002：pass |
| T-EGG-002 | FE-Pixel | 已完成 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/eggs/**` | QA-EGG-003：pass |
| T-EGG-003 | FE-Pixel | 质检未通过 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/eggs/**` | QA-EGG-004：fail，中间蛋壳色覆盖不足、视觉重量偏轻 |
| T-EGG-003-R1 | FE-Pixel | 已完成 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/eggs/**` | QA-EGG-005：pass |
| T-EGG-004 | FE-Pixel | 已完成 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/eggs/**` | QA-EGG-006：pass |
| T-EGG-005 | FE-Pixel-2 | 已完成 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/eggs/**` | QA-EGG-007：pass |

范围：将用户提供的宠物蛋三视角组与三枚发光状态组分别转换为与怪兽 v3-r3 一致的粗像素视觉资产；保持蛋壳标识、颜色、观察角度和发光差异，不接入应用代码。

最终结论：A 组三视角已明确区分为左前、窄侧与右前；B 组保留三枚正向蛋并实现由左至右的硬边发光增强。两图均为 192×108 逻辑网格、9 倍最近邻放大、无抖动量化；整图分别为 18 色和 22 色。QA-EGG-002 七项复检全部通过。

新参考图修改结论：三视角 v3 已按最新造型参考完成，左右分别为偏左与偏右 3/4 视角，中间为标识仅在左缘可见的窄侧后视角；斜带短横颜色同步更新。成品为 18 色，192×108 逻辑网格、9 倍最近邻放大。QA-EGG-003 七项验收全部通过。

中间蛋一致性修改结论：v5 将中间蛋改为完整蛋形并补足象牙壳体色块，三蛋尺寸为 46×69、45×69、45×69 逻辑像素；中间蛋非背景像素量与左右平均差 0.44%，壳色量差 2.40%。左右蛋及全部图案保持不变。QA-EGG-005 七项复检全部通过。

侧视花纹投影修正结论：v6 保留中间蛋 45×69 的完整蛋形与视觉重量，仅将眼环、蜡封、勾选、虚线和斜带短横恢复为侧视投影；左右蛋与接地影零像素变化。QA-EGG-006 九项验收全部通过。

像素强度对齐结论：三视角 v7 与发光组 v3 均升级为 144×81 逻辑网格、12 倍最近邻放大，基础像素线性尺寸较旧版增加 33.3%，面积增加 77.8%；两图分别为 21 色与 24 色，并共享 18 种核心颜色。QA-EGG-007 八项验收全部通过。

## Craft 像素宠物融合任务（2026-08-07）

| 任务ID | 执行线程 | 状态 | 允许修改范围 | 验收 |
|---|---|---|---|---|
| T-PIXEL-UI-001 | FE-Craft-Pixel | 质检未通过 | `packages/sprite_runtime/**`、`apps/list_monster_app/lib/main.dart`、`apps/list_monster_app/pubspec.yaml`、`apps/list_monster_app/assets/**`、`apps/list_monster_app/test/**`、`output/playwright/**` | QA-PIXEL-UI-001：fail；teen.png 右臂触达右边界，71 个不透明像素被硬裁切 |
| T-PIXEL-UI-001-R1 | FE-Craft-Pixel | 已完成 | `packages/sprite_runtime/assets/monsters/teen.png`、`packages/sprite_runtime/test/sprite_runtime_test.dart` | QA-PIXEL-UI-002：pass；右臂新增646像素与事实源100%一致，四边安全留白通过 |

范围：以怪兽 `checklist-creature-pixel-evolution-v3-r3.png`、宠物蛋 `egg-turnaround-pixel-v7.png` 和 `egg-glow-states-pixel-v3.png` 为视觉事实源，替换 Craft 界面的占位宠物表现；保持业务规则、领域模型、导航和任务流程不变。

最终结论：实现提交 `590f0d1` 完成四阶段单体透明像素资产、Today/怪兽页成长舞台、最近邻渲染、语义与桌面/390px截图；初检发现少年期右臂裁切后，由返工提交 `424ddb4` 从原拼版补全并增加四阶段透明边界测试。QA-PIXEL-UI-002 最终复检通过。

## 回响站 Craft 像素资产融合任务（2026-08-07）

| 任务ID | 执行线程 | 状态 | 允许修改范围 | 验收 |
|---|---|---|---|---|
| T-ECHO-PIXEL-001 | FE-Craft-Pixel | 质检未通过 | `C:/Users/Administrator/Documents/craft-demo/public/assets/**`、`src/data/listMonsterEchoWorkspace.js`、`src/components/user/Asset.jsx`、`src/index.css`、`scripts/verify-list-monster-workspace.mjs`、`output/playwright/T-ECHO-PIXEL-001/**` | QA-ECHO-PIXEL-001：功能/视觉7项通过；`.playwright-cli/` 遗留本任务诊断文件导致范围 fail |
| T-ECHO-PIXEL-001-R1 | FE-Craft-Pixel | 已完成 | `C:/Users/Administrator/Documents/craft-demo/.playwright-cli/page-2026-08-07T00-*.yml`、`console-2026-08-07T00-*.log` | QA-ECHO-PIXEL-002：pass；越界诊断已清除，历史文件完整保留 |

范围纠正：用户确认目标为 `http://127.0.0.1:5173/` 的回响站 Craft 编辑器，而非 Flutter 主应用。复用上一轮已通过 QA 的四阶段透明单体资产；当前幼年期页面、桌宠与 Widget 展示幼年像素宠物，蛋阶段 R2 展示最终像素蛋，少年/成年资产进入 Craft 静态资源库供后续阶段切换。

最终结论：回响站 Today、今日移动端、怪兽、桌宠和 Widget 已使用最终幼年像素宠物，蛋阶段 R2 已使用最终像素蛋；四阶段 PNG 与源资产哈希一致，Asset 采用显式 pixelated 契约，双存储槽迁移保留用户字段且幂等。独立冷刷新目标资源完整、控制台 0 error / 0 warning。QA-ECHO-PIXEL-001 功能与视觉 7 项通过，范围残留经 R1 清理后由 QA-ECHO-PIXEL-002 最终裁决 pass。

## 回响站成熟体 / 完全体多界面任务（2026-08-09）

| 任务ID | 执行线程 | 状态 | 允许修改范围 | 验收 |
|---|---|---|---|---|
| T-ECHO-STAGES-001 | FE-Craft-Pixel | 已完成 | `C:/Users/Administrator/Documents/craft-demo/src/data/listMonsterEchoWorkspace.js`、`scripts/verify-list-monster-workspace.mjs`、`output/playwright/T-ECHO-STAGES-001/**` | QA-ECHO-STAGES-001：pass；10项验收全部通过，无阻塞问题 |
| T-ECHO-BRANCH-B-001 | FE-Craft-Pixel | 质检未通过 | `C:/Users/Administrator/Documents/craft-demo/public/assets/list-monster-pixel-adult-fighter.png`、`src/data/listMonsterEchoWorkspace.js`、`scripts/verify-list-monster-workspace.mjs`、`output/playwright/T-ECHO-BRANCH-B-001/**` | QA-ECHO-BRANCH-B-001：fail；档案页两处“状态：坚定”超出批准成长指标范围 |
| T-ECHO-BRANCH-B-001-R1 | FE-Craft-Pixel | 已完成 | `C:/Users/Administrator/Documents/craft-demo/src/data/listMonsterEchoWorkspace.js`、`scripts/verify-list-monster-workspace.mjs`、`output/playwright/T-ECHO-BRANCH-B-001/01-fighter-archive.png` | QA-ECHO-BRANCH-B-002：pass；8项复检全部通过，无阻塞问题 |

范围：将 `teen` 映射为成熟体、`adult` 映射为完全体；每个阶段新增成长档案 Page、桌宠 Window 和 Widget，完整展示不同体型在主 App、桌面陪伴和紧凑组件中的表现。现有16个回响站画板及其用户保存内容不得修改。

## Craft 工作区增删改任务（2026-08-09）

| 任务ID | 执行线程 | 状态 | 允许修改范围 | 验收 |
|---|---|---|---|---|
| T-CRAFT-WS-CRUD-001 | FE-Craft-Workspace | 已完成（经 R1-R3A） | `C:/Users/Administrator/Documents/craft-demo/src/App.jsx`、`src/components/workspace/{BoardManager.jsx,WorkspaceProvider.jsx,useWorkspace.js}`、`src/utils/workspaceModel.js`、`src/index.css`、`scripts/{verify-workspace-model.mjs,workspace-browser-flow.js}`、`output/playwright/T-CRAFT-WS-CRUD-001/**` | QA-CRAFT-WS-CRUD-004：pass；8项复检全部通过，无范围违规和阻塞问题 |
| T-CRAFT-WS-CRUD-001-R1 | FE-Craft-Workspace | 复检未通过 | `C:/Users/Administrator/Documents/craft-demo/src/components/workspace/BoardManager.jsx`、`scripts/workspace-browser-flow.js`、`output/playwright/T-CRAFT-WS-CRUD-001/**` | QA-CRAFT-WS-CRUD-002：fail；功能与范围均通过，真实内置工作区视觉证据不成立 |
| T-CRAFT-WS-CRUD-001-R2 | FE-Craft-Workspace | 复检未通过 | `C:/Users/Administrator/Documents/craft-demo/scripts/workspace-browser-flow.js`、`output/playwright/T-CRAFT-WS-CRUD-001/**` | QA-CRAFT-WS-CRUD-003：fail；演示身份断言不完整、参考基线过旧、manifest 可见内容描述不实 |
| T-CRAFT-WS-CRUD-001-R3A | FE-Craft-Evidence | 已完成 | `C:/Users/Administrator/Documents/craft-demo/scripts/workspace-browser-flow.js`、`output/playwright/T-CRAFT-WS-CRUD-001/**` | QA-CRAFT-WS-CRUD-004：pass；视觉身份、源模型基线与证据描述一致 |

范围：保留现有工作区切换器视觉和三个既有工作区，新增工作区创建、重命名、删除、确认与持久化迁移能力；不得修改画布内 App 设计稿、`src/data/**` 或公共素材。

### 编制注册补充

| 角色 | 线程昵称 | Agent ID | 状态 | 已完成任务数 |
|---|---|---|---|---:|
| frontend_dev | FE-Craft-Workspace | `/root/fe_craft_workspace` | 待命（功能实现完成） | 1 |
| frontend_dev | FE-Craft-Evidence | `/root/fe_craft_evidence` | 待命（证据校准完成） | 1 |
