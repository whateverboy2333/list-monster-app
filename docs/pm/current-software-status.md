# 清单怪兽当前软件状态页

更新时间：2026-08-11

## 总体状态

冻结路线图中的节点 1 至节点 7 已全部完成，Flutter 主应用进入 MVP Beta 基线。最新完成的冻结节点仍是节点 7「QA 冻结与 MVP Beta」；当前没有已批准的新 Flutter 产品节点。

节点 7 之后的工作分为两条线：Flutter 主应用的像素宠物接入，以及独立 Craft 编辑器中的回响站阶段页、像素资产和工作区管理验证。后者位于 `C:/Users/Administrator/Documents/craft-demo`，不属于 Flutter 主应用的发布产物。

本文中的“已完成”仅表示现有提交、任务看板或独立 QA 已形成可复核结论；除非另有发布记录，不代表已经上线或对外发布。

## 当前已具备能力

1. 任务闭环：快速创建、完成、撤销、恢复、删除、长期任务、无压清理与提醒意图。
2. 怪兽成长：XP 幂等与回滚、每日上限、高优先级经验、Streak、今日激励、累计活跃奖励与状态机。
3. 账号与同步底座：游客模式、本地模拟登录、游客合并确认、离线队列、顺序回放、幂等与失败阻断。
4. 通知与隐私：本地通知端口、勿扰顺延、隐私标题与点击回流意图。
5. 陪伴场域：CompanionSnapshot、PC 第二窗口桌宠、Android Widget、deep link 与刷新意图。
6. 平台产物：Flutter Web Release、Windows Debug 与 Android Debug APK 均可构建。

## 节点 7 验收基线

1. `N7-QA-FINAL-002`：13 项冻结矩阵全部通过。
2. PM 首轮 Web 预览发现平台判断异常，`N7-R-002B` 完成修复。
3. `N7-QA-R-002B`：独立复检通过，App 88 项测试及三端构建全绿。
4. PM 重验：Web 首屏、任务创建 / 完成 / 撤销恢复、怪兽页、我的页与桌宠入口通过，控制台无错误。

## 2026-08-07 至 2026-08-09 已完成交付

### Flutter 主应用

1. 2026-08-07：像素宠物成长舞台接入 Today 与怪兽页，包含四阶段透明资产、最近邻渲染、语义与桌面 / 390px 证据；实现提交为 `590f0d1`。
2. 2026-08-07：少年期右臂裁切返工完成，提交为 `424ddb4`；`QA-PIXEL-UI-002` 复检通过。
3. 上述内容是本地 Git 提交与 QA 基线，尚无记录表明它们已对外发布。

### Craft 回响站编辑器

1. 2026-08-07：回响站 Today、今日移动端、怪兽、桌宠与 Widget 接入最终幼年像素宠物，蛋阶段 R2 接入最终像素蛋；双存储槽迁移和像素渲染通过 `QA-ECHO-PIXEL-002` 最终裁决。
2. 2026-08-09：成熟体与完全体新增成长档案、桌宠与 Widget 共 6 个阶段画板，`QA-ECHO-STAGES-001` 通过。
3. 2026-08-09：完全体第二分支“履契拳师”新增档案、桌宠与 Widget 共 3 个画板；修正超范围指标后，`QA-ECHO-BRANCH-B-002` 通过。
4. 2026-08-09：工作区切换器完成新建、重命名、删除、确认、持久化迁移和最后工作区保护；`QA-CRAFT-WS-CRUD-004` 通过。
5. 以上交付均属于 `C:/Users/Administrator/Documents/craft-demo` 的本地编辑器与验证证据，不应表述为 Flutter 主应用已发布能力。

## 设计物料地图

以下地图是物料位置的唯一索引，不复制物料本身。`docs/assets/visuals/**` 保存设计事实与过程资产；Flutter 与 Craft 目录中的 PNG 是派生运行时副本；`output/playwright/**` 只保存验收证据，不是设计事实源或可编辑源。

| 类别 | 当前路径与文件 | 用途 | 事实源等级 | 修改注意事项 |
|---|---|---|---|---|
| 宠物最终视觉源 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/checklist-creature-pixel-evolution-v3-r3.png` | 四形态宠物像素母图 | 最终视觉事实源 | 修改须先形成视觉裁决，并同步验证所有派生副本；同目录 v1、v2、v3、v3-r1、v3-r2 均为历史过程资产 |
| 宠物蛋最终视觉源 | `docs/assets/visuals/checklist-creature-evolution/pixel-art/eggs/egg-turnaround-pixel-v7.png`；`docs/assets/visuals/checklist-creature-evolution/pixel-art/eggs/egg-glow-states-pixel-v3.png` | 三视角蛋与三枚发光状态母图 | 最终视觉事实源 | 不得用旧版 turnaround / glow 文件覆盖；派生时保持最近邻像素与状态语义 |
| 设计规范与过程资产 | `docs/DESIGN.md`；`docs/assets/visuals/**` | 设计规则、视觉决策、提示词、元数据、源 SVG 与历史迭代 | 设计事实与过程资产 | 先读 `docs/DESIGN.md` 判断当前基线；历史草稿仅供追溯，不自动成为最终物料 |
| 五阶段界面设计物料 | `docs/assets/visuals/checklist-creature-evolution/ui-integration/`：`shared-stage-layout.md`、`stage-00-egg-r2.*`、`stage-01-juvenile.*`、`stage-02-growth.*`、`stage-03-fighter.*`、`stage-04-scholar.*`、`stage-overview.*`、`role-crops/` | 初诺契茧、诺卷仔、联页契灵、履契拳师、万策卷贤的布局、PNG、可重渲染 SVG、来源说明与元数据 | 当前五阶段界面设计源 | 蛋阶段当前基线是 `stage-00-egg-r2.*`；`stage-00-egg.*` 与 `stage-00-egg-r1.*` 是历史稿，不得标为当前最终物料 |
| Flutter 运行时资产 | `packages/sprite_runtime/assets/monsters/`：`egg.png`、`child.png`、`teen.png`、`adult.png` | Flutter 主应用读取的四阶段透明 PNG | 派生运行时副本 | 不在此目录重新定义角色；变更应从最终视觉源派生，并复核透明边界、哈希与最近邻渲染 |
| Craft 公共资产 | `C:/Users/Administrator/Documents/craft-demo/public/assets/`：`list-monster-pixel-egg.png`、`list-monster-egg-r2.png`、`list-monster-pixel-child.png`、`list-monster-pixel-teen.png`、`list-monster-pixel-adult.png`、`list-monster-pixel-adult-fighter.png` | Craft 画板运行时引用的宠物与蛋 PNG | 派生运行时副本 | 不以此目录反向覆盖设计母图；替换后需验证默认工作区、保存数据迁移和 pixelated 渲染 |
| Craft 可编辑画板源 | `C:/Users/Administrator/Documents/craft-demo/src/data/listMonsterEchoWorkspace.js` | 回响站默认画板、阶段页及迁移所用的 Craft 节点数据 | 可编辑界面源 | 这是画板结构源，不是像素视觉母图；修改须保留既有画板、用户字段、选择状态与幂等迁移 |
| Flutter QA 证据 | `output/playwright/` | Flutter Web 桌面 / 移动截图、日志与验收导出 | 验收证据，非设计事实源 | 只用于证明实现状态；不得据截图反向重建设计或作为可编辑页面源 |
| Craft QA 证据 | `C:/Users/Administrator/Documents/craft-demo/output/playwright/` | Craft 阶段页、工作区、迁移与浏览器回归证据 | 验收证据，非设计事实源 | 只用于复核具体任务；不得标成公共资产、设计母图或可编辑画板源 |

修改顺序：先确认 `docs/DESIGN.md` 与最终视觉源，再更新派生运行时副本或 Craft 画板源，最后生成新的 QA 证据。任何层级都不得用截图替代 SVG、Craft 节点或最终视觉源。

## 项目内容地图

主项目唯一事实源是 `C:/Users/Administrator/Documents/清单怪兽app`。下表按“路径—用途—事实源等级—内容类型”描述当前内容；它是位置索引，不复制文件，也不把构建产物、QA 截图或本地诊断提升为产品事实。

| 内容 | 当前路径 | 用途 | 事实源等级 | 内容类型 |
|---|---|---|---|---|
| Flutter 主 App | `apps/list_monster_app/` | 今日、长期、怪兽、我的、桌宠入口及平台接线 | 主项目产品实现事实 | 源码；其中 App 引用的图像为派生运行时资产 |
| 九个领域 / 运行时 package | `packages/account_domain/`、`packages/companion_contract/`、`packages/core/`、`packages/local_store/`、`packages/monster_domain/`、`packages/sprite_runtime/`、`packages/sync_domain/`、`packages/task_domain/`、`packages/ui_kit/` | 账号、陪伴快照、共享基础、本地存储、成长、精灵运行时、同步、任务和 UI 契约 / 实现 | 主项目领域与运行时实现事实 | 源码；`packages/sprite_runtime/assets/monsters/` 为派生运行时资产 |
| 产品契约 | `docs/contracts/` | 实体、事件、XP、快照、埋点与资产命名约束 | 字段与事件契约事实源 | 契约文档 |
| 设计规范与视觉资产 | `docs/DESIGN.md`、`docs/DESIGN-CHANGELOG.md`、`docs/assets/visuals/` | 设计规则、当前视觉基线、母图、源 SVG、元数据和历史过程资产 | 设计事实源；具体当前物料以“设计物料地图”为准 | 设计源与过程资产 |
| 项目入口与全局状态 | `README.md`、`docs/pm/current-software-status.md`、`PROJECT_BOARD.md`、`docs/pm/pm-decisions.md` | 入口、状态快照、唯一当前全局任务 / QA 看板和产品裁决 | 四层事实源中的入口 / 快照 / 全局层；决策表为产品裁决源 | 活文档 |
| 其他 PM 文档 | `docs/pm/` | 路线图、PRD、节点总结、历史 wave 与旧名册 | 路线图 / PRD 按各文档声明；wave 和旧名册仅作历史参考 | 产品文档与历史记录 |
| 任务级交接 | `.features/`、`.features/_registry.md`、`.features/T-DOC-CONTENT-005/status.md` | 协议索引，以及单任务改动、验证、风险与下一接手点；其他任务由注册表定位 | 四层事实源中的任务层 | 活任务记录 |
| 协作与本地 Agent 配置 | `AGENTS.md`、`.codex/` | 多 Agent 规则、角色和本机项目级 Agent 配置 | 协作规则；不构成产品能力事实 | 规则与本地配置 |
| 输入参考资料 | `AI时代的PRD（输入）规范.pdf` | PRD 编写方法输入 | 外部参考，不覆盖本项目 PRD、契约或裁决 | 输入资料 |
| 工具源码 | `tool/verify_node2.ps1`、`tool/build_windows.ps1` | 节点验证与 Windows 打包 | 主项目工具实现 | 工具源码 |
| 构建与预览产物 | `dist/`、`apps/list_monster_app/build/`、`packages/sprite_runtime/build/`、`packages/ui_kit/build/`、`tool/craft-echo-preview/` | Windows 包、Flutter / package 构建缓存和本地 Craft 静态预览 | 可再生成，不是源码或设计事实 | 构建产物 |
| QA 与 Bug 证据 | `output/playwright/`、`docs/bugfix/`、`docs/pm/current-app-preview.png`、`docs/pm/current-app-preview-today.png`、`docs/pm/current-app-preview-my.png` | 浏览器截图、回归导出、Bug 记录和阶段预览证据 | 验收证据，不是设计或源码事实源 | QA 证据 |
| 本地临时与诊断项 | `.playwright-cli/`、`shot05-out.json`、`snap03-out.json`、`webbridge-req-shot02.json`、`.node3-web-server.err.log`、`.node3-web-server.out.log`、`.node4-static-5206.err.log`、`.node4-static-5206.out.log`、`.node4-web-server-5204.err.log`、`.node4-web-server-5204.out.log`、`.node4-web-server-5205.err.log`、`.node4-web-server-5205.out.log` | 浏览器会话、桥接请求、抓取结果和本地服务日志 | 非事实源；清理前仍须确认归属和复现价值 | 本地临时文件与诊断日志 |
| 外部 Craft 配套工作区 | `C:/Users/Administrator/Documents/craft-demo/src/`、`C:/Users/Administrator/Documents/craft-demo/public/assets/`、`C:/Users/Administrator/Documents/craft-demo/.craft-saves/current-workspace.json`、`C:/Users/Administrator/Documents/craft-demo/output/playwright/` | 可编辑画板源码、派生公共资产、用户显式保存基线和 Craft QA 证据 | 主项目配套工作区；不是第二主项目事实源 | Craft 源码、派生资产、用户存档与 QA 证据 |

### 主项目、Craft 与恢复副本边界

| 身份 | 路径 | 当前口径 |
|---|---|---|
| 活跃主项目 | `C:/Users/Administrator/Documents/清单怪兽app` | 唯一项目事实源；当前 `master` HEAD 为 `424ddb4`，任务、文档、产品源码和交接体系均从此处读取 |
| Craft 配套工作区 | `C:/Users/Administrator/Documents/craft-demo` | 受主项目文档与裁决约束的可编辑设计工作区；不是第二主仓，不承载 Flutter 产品事实 |
| 电脑迁移恢复副本 | `C:/Users/Administrator/Documents/Codex/Recovered_Old_PC/Documents/清单怪兽app` | HEAD `c20254a`，仅作待隔离历史资料；禁止继续派单、实现、更新看板或生成新事实，在主项目与 Craft 均形成可恢复版本前不得删除 |

### 恢复副本比对结论

1. `c20254a` 是主项目 `424ddb4` 的祖先，恰落后 `590f0d1` 与 `424ddb4` 两个像素宠物提交。
2. 截至 2026-08-11 的 `T-REPO-IDENTITY-001` 只读审计时，排除 `.git`、构建和平台生成缓存后，恢复副本 239 个项目文件全部可在活跃主项目找到；活跃主项目另有 214 个文件。该数字是审计快照，不是会随当前工作树自动更新的实时计数；结论是没有“旧副本独有但主版本缺失”的项目文件需要迁移。
3. 同路径未提交差异按 `D-REPO-IDENTITY-001` 处理：旧 README 已被主 README 完整取代；旧 `agent-roster.md` 与 `wave-0-control-board.md` 更新违反当前单一全局看板规则，不迁移为现役状态。
4. 恢复副本的旧 `D-046: 文档对齐阶段裁决` 与主项目现有 `D-046: 四形态怪兽像素化首轮交付边界` 编号冲突，不整段复制。其有效事实已由主项目 README、当前状态页、PRD、覆盖审计及 `D-REPO-IDENTITY-001` 摘要吸收。
5. 恢复副本没有合并覆盖主项目的权限；后续只能在用户确认后执行可逆隔离或归档，不得直接永久删除整个 `Recovered_Old_PC` 资料树。

## 两套运行环境

| 环境 | 事实位置 | 当前口径 |
|---|---|---|
| Flutter 主应用 | `apps/list_monster_app/` | 产品代码与节点 1 至 7 MVP Beta 基线；Web、Windows、Android 构建与设备验收按各自任务记录核对 |
| Craft 回响站编辑器 | `C:/Users/Administrator/Documents/craft-demo` | 本地 Craft 画板与编辑器；`http://127.0.0.1:5173/` 只用于该编辑器预览，服务是否正在运行需现场核验 |

不得使用 `5173` 证明 Flutter Web、Windows 或 Android 产物状态，也不得把 Craft 画板、工作区 CRUD 或本地存储迁移写成 Flutter 主应用能力。

## 尚未完成或待人工裁决

1. 当前没有已批准的新 Flutter 产品节点。真实设备 Beta、远端同步 / 认证接入和下一轮产品范围仍需人工排序与立项。
2. `PROJECT_BOARD.md` 中 `T-DIGIPET-CRAFT-008` 仍记录为“实现已完成；独立 QA 受浏览器执行环境阻塞”。后续阶段页和工作区任务的 QA 通过不自动关闭这条早期记录，是否补验或作废需 PM 裁决。
3. 当前混合工作树尚未完成统一整理、提交或发布裁决；未提交源码、文档、资产和证据不得视为稳定里程碑。

## 已知边界

1. 同步回放目前接本地 consumer 端口，尚未连接真实云服务与认证系统。
2. Android Widget 已通过源码、自动化测试与 APK 构建，尚缺真实 Android 桌面点击流转证据。
3. 通知与账号能力仍以本地适配器和模拟入口为主。
4. Craft 回响站是本地可编辑验证环境，不是 Flutter 运行时，也没有可据此推断的线上发布状态。
5. 本文不保证历史本地预览端口持续在线；使用前须现场核验监听进程、资源版本和控制台状态。

## 当前工作树风险

1. 本仓库工作树包含已跟踪源码、测试、PM 文档的修改，以及未跟踪的设计文档、视觉资产、截图、预览产物和诊断文件；不同来源混杂，禁止在未确认归属前清理、重置或批量提交。
2. `README.md` 在本任务开始前已包含 Windows 构建脚本相关的未提交修改，本次整理在其基础上保留并适配，没有回退。
3. 仓库存在异常的 `refs/codex/turn-diffs/checkpoints/...` 引用，`git log --all` 可能报错；当前可使用 `git log HEAD` 核对主历史，引用清理由专门任务另行授权。
4. `C:/Users/Administrator/Documents/craft-demo` 当前没有 `.git` 元数据，无法仅靠 Git 区分其已提交与未提交状态；应把看板、QA 证据和实际文件交叉核对，并默认视为本地工作副本。

## 后续 Agent 的事实源读取顺序

1. 从仓库入口 [README](../../README.md) 确认项目边界和两套运行环境。
2. 阅读本状态页，获取截至 2026-08-09 的软件、物料、边界与工作树风险快照。
3. 阅读 [PROJECT_BOARD.md](../../PROJECT_BOARD.md)，确认唯一当前全局任务状态、编制、派单与 QA 裁决。
4. 阅读 [.features 任务记录索引](../../.features/_registry.md)，再打开目标任务的 `.features/<任务ID>/status.md` 获取改动文件、行为变化、验证、风险和下一接手点。协议见 [AGENTS.md](../../AGENTS.md)，合规样例见 [T-DOC-HANDOFF-004/status.md](../../.features/T-DOC-HANDOFF-004/status.md)。
5. [wave-0-control-board.md](wave-0-control-board.md) 只核对历史节点与交付，[agent-roster.md](agent-roster.md) 只作旧名册参考；二者不再承担当期任务状态。产品与工程裁决仍查 [pm-decisions.md](pm-decisions.md)，路线图范围以 [node-roadmap-freeze.md](node-roadmap-freeze.md) 为基线。
6. 最后用 `git log HEAD`、`git status --short` 和实际文件复核代码与工作树。若文档与现场状态冲突，以更新日期更晚且有任务 / QA / Git 证据的记录为准，并向 PM 上报冲突。

可复制指令：把改动更新到 `.features/<任务ID>/status.md`，按 `AGENTS.md` 模板记录改动、验证、风险和下一接手点。

## 下一步建议

先由 PM 裁决早期 Craft 阻塞记录是否补验，并为混合工作树制定归属与提交策略；产品侧优先开展真实 Windows 与 Android 设备 Beta，记录崩溃、交互阻塞和数据恢复问题，再决定远端同步接入或下一轮 Flutter 产品节点。
