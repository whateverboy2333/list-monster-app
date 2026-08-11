---
status: live
type: feature
module: craft-workspace-save
last_updated: 2026-08-10
owner: FE-Gamma
---

# T-CRAFT-SAVE-001 任务记录

## 任务身份

- 任务 ID：T-CRAFT-SAVE-001
- 目标：为 Craft 编辑器增加用户显式触发的固定项目存档闭环，并在启动或刷新时安全恢复。
- 依赖：T-CRAFT-WS-CRUD-001（已通过 QA-CRAFT-WS-CRUD-004）
- 记录路径：`.features/T-CRAFT-SAVE-001/status.md`

## 当前状态

`completed`

## 变更文件

- `C:/Users/Administrator/Documents/清单怪兽app/.features/T-CRAFT-SAVE-001/status.md`
- `C:/Users/Administrator/Documents/清单怪兽app/.features/_registry.md`
- `C:/Users/Administrator/Documents/craft-demo/vite.config.js`
- `C:/Users/Administrator/Documents/craft-demo/package.json`
- `C:/Users/Administrator/Documents/craft-demo/src/App.jsx`
- `C:/Users/Administrator/Documents/craft-demo/src/components/Topbar.jsx`
- `C:/Users/Administrator/Documents/craft-demo/src/utils/workspaceSave.js`
- `C:/Users/Administrator/Documents/craft-demo/src/index.css`
- `C:/Users/Administrator/Documents/craft-demo/scripts/craft-save-plugin.mjs`
- `C:/Users/Administrator/Documents/craft-demo/scripts/verify-workspace-save.mjs`
- `C:/Users/Administrator/Documents/craft-demo/scripts/workspace-save-browser-flow.js`
- `C:/Users/Administrator/Documents/craft-demo/output/playwright/T-CRAFT-SAVE-001/workspace-save-success.png`
- `C:/Users/Administrator/Documents/craft-demo/output/playwright/T-CRAFT-SAVE-001/scope-verification.txt`
- `C:/Users/Administrator/Documents/craft-demo/AGENTS.md`
- `C:/Users/Administrator/Documents/craft-demo/dist/index.html`
- `C:/Users/Administrator/Documents/craft-demo/dist/assets/index-CD6LRsRa.css`
- `C:/Users/Administrator/Documents/craft-demo/dist/assets/index-y5FFypr-.js`

## 行为变化

- 顶部栏新增“保存当前版本”，保存中禁用重复提交；成功显示“已保存”及时间，后续实际编辑只显示“有未保存改动”。
- 点击保存时先抓取 Craft Editor 最新序列化节点并回写当前画板，再把完整活动工作区与目录元数据安全替换到固定项目存档。
- 启动/刷新优先读取合法项目存档并恢复工作区切换器及当前画板；缺失时沿用 localStorage→默认模板，非法存档显示警告且不覆盖文件。
- 项目文件没有自动保存入口；编辑、等待、选择、刷新/pagehide 只影响内存与既有 localStorage 行为。
- 生产存档固定为 `craft-demo/.craft-saves/current-workspace.json`；测试模式仅使用证据目录固定沙箱且结束后清理。
- `craft-demo/AGENTS.md` 已写入存档优先级、任务卡基线记录、禁止无授权重建及保留未涉及节点规则。
- 收口时真实固定存档不存在，因此当前基线事实为：savedAt 不适用、工作区名称不适用、当前画板不适用；未创建占位存档。
- R1 新增授权的三个 `dist` 文件确认为当前源码对应的生产构建产物；逐字节哈希与临时构建完全一致，保留现状且未再次改写。

## 验证证据

- 2026-08-10：实施前已完整读取 `清单怪兽app/AGENTS.md` 与 `.features/_registry.md`。
- 2026-08-10：先建立模型失败用例，初次因 `workspaceSave.js` 尚不存在按预期失败；实现后 `npm run verify:workspace-save` 通过，覆盖 schema、最新节点、非法负载与安全替换。
- 2026-08-10：浏览器回归逐轮排除 Playwright VM 文件接口、初始 Frame 水合误报、测试服务插件装载及预期 HTTP 状态污染控制台等测试边界；所有隔离沙箱均清理，真实固定存档始终未触碰。
- 2026-08-10：最终 `npm run verify:workspace-save-browser` exit 0；手动保存边界、最新节点、内置/自建工作区、刷新恢复、外部合法更新、404、非法 JSON/schema、写入失败均通过，console error=0。
- 2026-08-10：最终 `npm run verify:workspace-browser` exit 0；CRUD、迁移、焦点、持久化、隔离、最后工作区保护与窄屏无回归，console error=0。
- 2026-08-10：最终 `npm run lint`、`npm run build`、`npm run verify:workspace-model`、`npm run verify:workspace-save` 均 exit 0。
- 2026-08-10：顶部成功状态截图：`C:/Users/Administrator/Documents/craft-demo/output/playwright/T-CRAFT-SAVE-001/workspace-save-success.png`。
- 2026-08-10：`package-lock.json` SHA256 仍为 `A2280AF626E6E89E1A6E0C5066B2325C75343370738E7365FD514EA5DAF79970`；未新增依赖、未初始化 Git，`src/data/**` 与 `public/**` 未修改。
- 2026-08-10 R1：系统临时镜像 build 生成同名 index.html/CSS/JS，分别与项目现存文件 SHA-256 完全一致；项目 dist 写入时间保持 07:45:08，未再次覆盖。
- 2026-08-10 R1：临时镜像复跑 lint、临时 outDir build、workspace-model、workspace-browser、workspace-save、workspace-save-browser，全部 exit 0；两套浏览器 console error=0。
- 2026-08-10 R1：范围证据为 `C:/Users/Administrator/Documents/craft-demo/output/playwright/T-CRAFT-SAVE-001/scope-verification.txt`；临时根目录、测试沙箱均已清理。
- 2026-08-10 首轮 QA-CRAFT-SAVE-001：功能、异常回退、刷新恢复、Agent 规则及六组命令通过；仅 SCOPE-001 因三个 dist 产物未获原卡授权且未登记而判 fail。
- 2026-08-10 QA-CRAFT-SAVE-001-R2：复核 R1 精确授权、构建哈希映射、范围证据与完整历史后判 pass，blocking_issues 为空。
- 2026-08-10 PM 收口：PM 明确依据 QA-CRAFT-SAVE-001-R2=pass 将本任务正式收口为 `completed`。

## 风险 / 未决事项

- 无剩余阻塞或待裁决事项；QA-CRAFT-SAVE-001-R2 已通过，blocking_issues 为空，PM 已明确完成态收口。
- 固定文件读写依赖本项目配置的 Vite dev/preview 服务；单独用不加载插件的静态服务器打开构建产物时会安全回退到既有 localStorage，不具备磁盘保存能力。
- 测试专用控制端点仅在服务端环境变量 `CRAFT_SAVE_TEST_MODE=1` 时启用，路径固定在任务证据沙箱且不接受客户端磁盘路径。

## 下一接手点

- 首个动作：后续涉及 Craft 画板或工作区的 Agent 开工前必须先读取 `C:/Users/Administrator/Documents/craft-demo/.craft-saves/current-workspace.json`。
- 前置条件：存档存在且合法时以其为用户确认基线；文件不存在或无效时按 `craft-demo/AGENTS.md` 的 localStorage→默认模板回退规则处理并明确记录。
- 禁止触碰：未经用户或新任务卡授权，禁止清空、删除、重建或用默认模板覆盖用户存档；不得丢失未涉及画板与节点。

## 维护信息

- 最近更新时间：2026-08-10
- 当前负责人：FE-Gamma

## 更新记录

- 2026-08-10：创建任务记录，状态设为 `in_progress`，登记实施边界与初始风险。
- 2026-08-10：完成显式保存服务、顶部状态、启动恢复、协作规则、模型验证与隔离浏览器验证；既有工作区回归通过，状态更新为 `ready_for_qa`。
- 2026-08-10：收到 QA-CRAFT-SAVE-001 的 SCOPE-001 返工裁决；正文状态更新为 `rework`，开始核实三个新增授权的生产构建产物。
- 2026-08-10：R1 临时构建确认三个 dist 文件与当前源码逐字节一致；补充范围证据和交付登记，六组验证通过，正文恢复为 `ready_for_qa`。
- 2026-08-10：全新 QA-CRAFT-SAVE-001-R2 判 pass 且无阻塞；PM 明确要求完成态收口，正文状态更新为 `completed`，历史证据完整保留。
