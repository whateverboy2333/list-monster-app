# 清单怪兽可视化复现项目看板

## 当前目标

当前阶段优先完成仓库身份与资料安全收口：以 `C:/Users/Administrator/Documents/清单怪兽app`
作为主项目唯一事实源，以 `C:/Users/Administrator/Documents/craft-demo` 作为受主项目文档约束的
Craft 可编辑设计工作区；先把两处活跃工作落入可恢复版本，再隔离电脑迁移产生的旧恢复副本。
完成安全收口后，再继续产品开发、Craft 设计与设备 Beta。

## 编制注册表

| 角色 | 线程昵称 | 状态 | 已完成任务数 |
|---|---|---|---:|
| PM | 当前根会话 | 在岗 | 1 |
| frontend_dev | Lovelace / FE-PC-Design | 待命 | 2 |
| documentation | DOC-Alpha | 待命 | 6 |
| repository_ops | Repo-Alpha | 已轮换：权限上下文无法接收用户授权 | 0 |
| repository_ops | Repo-Beta | 在岗（T-REPO-SAFETY-001-R2） | 1 |
| qa_inspector | QA-REPO-SAFETY-001 | 已裁撤 | 0 |
| qa_inspector | QA-DOC-CONTENT-005 | 已裁撤 | 1 |
| qa_inspector | QA-DOC-CONTENT-005-CLOSE | 已裁撤 | 1 |
| qa_inspector | QA-DOC-001 | 已裁撤 | 1 |
| qa_inspector | QA-DOC-003 | 已裁撤 | 1 |
| qa_inspector | QA-DOC-004 | 已裁撤 | 1 |
| qa_inspector | QA-DOC-004-R1 | 已裁撤 | 1 |
| qa_inspector | QA-DOC-004-CLOSE | 已裁撤 | 1 |
| frontend_dev | FE-Beta | 待命（权限上下文不含用户授权） | 16 |
| frontend_dev | Euler / FE-Current | 待命 | 7 |
| frontend_dev | Darwin / FE-Current-2 | 待命 | 2 |
| frontend_dev | Ptolemy / Preview-OPS | 待命 | 1 |
| qa_inspector | Einstein / QA-006-R1 | 已裁撤 | 1 |
| qa_inspector | Noether / QA-006 | 已裁撤 | 0 |
| qa_inspector | Kepler / QA-005 | 已裁撤 | 0 |
| qa_inspector | Tesla / QA-005-R1 | 已裁撤 | 0 |
| qa_inspector | Maxwell / QA-005-R2 | 已裁撤 | 0 |
| qa_inspector | Hubble / QA-005-R3 | 已裁撤 | 0 |
| qa_inspector | Faraday / QA-005-R4 | 已裁撤 | 0 |
| qa_inspector | Planck / QA-005-R4-R1 | 已裁撤 | 0 |
| qa_inspector | Curie / QA-005-R4-R2 | 已裁撤 | 0 |
| qa_inspector | Fermi / QA-005-R4-R3 | 已裁撤 | 0 |
| frontend_dev | FE-Delta | 待命 | 1 |
| frontend_dev | FE-Gamma | 在岗 | 2 |
| frontend_dev | FE-Epsilon | 待命 | 1 |
| frontend_dev | FE-Alpha | 已裁撤：工作区刷新后无响应；无代码变更 | 0 |
| frontend_dev | FE-Beta / Craft-R2-Successor | 待命 | 1 |
| qa_inspector | Pascal / QA-CRAFT-008 | 已裁撤 | 0 |
| qa_inspector | Plato / QA-CRAFT-008-R1 | 已裁撤：复验未跑完 | 0 |
| qa_inspector | Planck / QA-CRAFT-008-R2 | 已裁撤：最终读数未完成 | 0 |
| qa_inspector | Leibniz / QA-CRAFT-008-R3 | 已裁撤：浏览器脚本未启动 | 0 |
| qa_inspector | QA-OPS-004 | 已裁撤 | 1 |
| design | Peirce / Design-Alpha | 已裁撤：会话不可用 | 7 |
| design | Peirce / Design-Beta | 已裁撤：当前会话句柄不可用 | 6 |
| design | Hegel / Design-Gamma | 已裁撤：执行无响应 | 0 |
| design | Pasteur / Design-Delta | 待命 | 4 |
| qa_inspector | Goodall / QA-DIGIPET-007A | 已裁撤 | 1 |
| qa_inspector | Plato / QA-DIGIPET-007B | 已裁撤 | 1 |
| qa_inspector | Dewey / QA-DIGIPET-007A-R1 | 已裁撤 | 1 |
| qa_inspector | Bacon / QA-DIGIPET-007A-R2 | 已裁撤 | 1 |
| qa_inspector | QA-DIGIPET-006-R4 | 已裁撤 | 1 |
| qa_inspector | QA-DIGIPET-006-R3 | 已裁撤 | 1 |
| qa_inspector | QA-DIGIPET-006-R2 | 已裁撤 | 0 |
| qa_inspector | QA-DIGIPET-006-R1 | 已裁撤 | 1 |
| qa_inspector | QA-DIGIPET-006 | 已裁撤 | 1 |
| qa_inspector | QA-DIGIPET-005 | 已裁撤 | 1 |
| qa_inspector | QA-DIGIPET-004-R3 | 已裁撤 | 0 |
| qa_inspector | QA-DIGIPET-004-R4 | 已裁撤：未返回裁决 | 0 |
| qa_inspector | QA-DIGIPET-004-R4B | 已裁撤 | 1 |
| qa_inspector | QA-DIGIPET-004-R2 | 已裁撤 | 1 |
| qa_inspector | QA-DIGIPET-004-R1 | 已裁撤 | 0 |
| qa_inspector | QA-DIGIPET-004 | 已裁撤 | 1 |
| qa_inspector | QA-DIGIPET-CRAFT | 已裁撤 | 0 |
| qa_inspector | QA-DIGIPET-CRAFT-R2 | 已裁撤 | 1 |
| qa_inspector | Gauss / QA-DIGIPET-001 | 已裁撤 | 1 |
| qa_inspector | Parfit / QA-002A | 已裁撤 | 0 |
| qa_inspector | Pauli / QA-002A-2 | 已裁撤 | 0 |
| qa_inspector | Pasteur / QA-002A-R1 | 已裁撤 | 0 |
| qa_inspector | Bohr / QA-002A-R2 | 已裁撤 | 1 |
| qa_inspector | Helmholtz / QA-002B | 已裁撤 | 1 |
| qa_inspector | Feynman / QA-002C | 已裁撤 | 1 |
| qa_inspector | Copernicus / QA-FINAL | 已裁撤 | 0 |
| qa_inspector | Dirac / QA-FINAL-R1 | 已裁撤 | 0 |
| qa_inspector | Godel / QA-FINAL-R2 | 已裁撤 | 1 |
| qa_inspector | Descartes / QA-004 | 已裁撤 | 1 |

## 任务看板

| 任务 ID | 任务 | 负责人 | 状态 | 依赖 |
|---|---|---|---|---|
| T-REPO-IDENTITY-001 | 裁决主项目、Craft 工作区与恢复副本身份 | PM | 已完成 | 无 |
| T-REPO-SAFETY-001 | 将主项目未提交工作按价值分类并提交落盘 | Repo-Beta | QA 未通过：任务记录遗漏第 5 个提交，R2 返工中 | T-REPO-IDENTITY-001 |
| T-REPO-SAFETY-001-R1 | 诊断 Flutter 测试启动超时并在门禁通过后继续主仓提交推送 | Repo-Beta | 已完成：5 个提交推送，HEAD/远端一致 | T-REPO-SAFETY-001 |
| T-REPO-QA-SAFETY-001 | 独立验收主仓提交、排除项、测试证据与远端一致性 | QA-REPO-SAFETY-001 | 未通过：状态页仍记 4 个提交/1292f51 | T-REPO-SAFETY-001-R1 |
| T-REPO-SAFETY-001-R2 | 校正任务记录中的第 5 个提交与最终远端哈希 | Repo-Beta | 已派单 | T-REPO-QA-SAFETY-001 |
| T-CRAFT-SAFETY-001 | 为 Craft 工作区建立本地版本快照 | 待派单 | 用户已确认，等待主仓安全任务通过 | T-REPO-SAFETY-001-R1 |
| T-REPO-ARCHIVE-001 | 迁移唯一有效事实后隔离旧恢复副本 | 待派单 | 用户已确认，等待主仓与 Craft 快照通过 | T-REPO-SAFETY-001-R1、T-CRAFT-SAFETY-001 |
| T-DOC-CONTENT-005 | 整理当前项目内容地图与旧副本差异结论 | DOC-Alpha | 已完成 | T-REPO-IDENTITY-001 |
| T-DOC-QA-CONTENT-005 | 独立质检内容地图与旧副本差异结论 | QA-DOC-CONTENT-005 | 已通过 | T-DOC-CONTENT-005 |
| T-DOC-CONTENT-005-CLOSE | 收口内容地图任务记录 | DOC-Alpha | 已完成 | T-DOC-QA-CONTENT-005 |
| T-DOC-QA-CONTENT-005-CLOSE | 只读复核内容地图完成态 | QA-DOC-CONTENT-005-CLOSE | 已通过 | T-DOC-CONTENT-005-CLOSE |
| T-CRAFT-SAVE-001 | Craft 显式保存当前版本、项目文件恢复与 Agent 基线规则 | FE-Gamma | 已完成（QA-CRAFT-SAVE-001-R2 通过） | T-CRAFT-WS-CRUD-001 |
| QA-CRAFT-SAVE-001 | 独立验收 Craft 显式保存与项目存档闭环 | QA Inspector | 未通过：功能全过，dist 产物未在原范围登记 | T-CRAFT-SAVE-001 |
| QA-CRAFT-SAVE-001-R2 | 复检 dist 精确授权、构建一致性及功能非回退 | QA Inspector | 已通过：SCOPE-001 闭环，六组回归与真实存档保护通过 | T-CRAFT-SAVE-001-R1 |
| BF-0810-1 | 点击保存成功后“已保存时间”不立即更新 | FE-Gamma | R1 QA 通过，待用户验收 | T-CRAFT-SAVE-001 |
| T-DOC-HANDOFF-001 | 统一项目入口与当前交接状态 | DOC-Alpha | 已完成 | 无 |
| T-PC-DESIGN-001 | 保留“清单怪兽V2.0”源工作区，新建“清单怪兽V2.0 · PC端”并完成 PC 高保真界面设计 | Lovelace / FE-PC-Design | 已完成（R1复验通过） | 安卓端 V2.0 设计事实源、现有 Windows/Flutter 代码 |
| T-PC-DESIGN-QA-001 | 独立验收“清单怪兽V2.0 · PC端”工作区、8画板、迁移与真实截图 | 新鲜 QA | 未通过：搜索提示裁切、状态控件空态文字溢出 | T-PC-DESIGN-001 |
| T-PC-DESIGN-001-R1 | 修复 PC 搜索入口与任务状态控件的真实渲染缺陷 | Lovelace / FE-PC-Design | 已完成 | T-PC-DESIGN-QA-001 |
| T-PC-DESIGN-QA-001-R1 | 独立复验 PC 搜索入口、任务状态控件及既有回归 | Aristotle / QA-PC-R1 | 已通过 | T-PC-DESIGN-001-R1 |
| T-DOC-QA-001 | 独立质检项目入口与交接状态 | QA-DOC-001 | 已通过 | T-DOC-HANDOFF-001 |
| T-DOC-AUDIT-002 | 只读审计项目文件与文档治理风险 | DOC-Alpha | 扫描范围过大，已中止并拆小 | T-DOC-QA-001 |
| T-DOC-AUDIT-002-R1 | 聚焦审计根目录、docs/pm 与生成目录 | DOC-Alpha | 已完成 | T-DOC-AUDIT-002 |
| T-DOC-ASSETS-003 | 建立项目设计物料地图 | DOC-Alpha | 已完成 | T-DOC-QA-001 |
| T-DOC-QA-003 | 独立质检项目设计物料地图 | QA-DOC-003 | 已通过 | T-DOC-ASSETS-003 |
| T-DOC-HANDOFF-004 | 建立多 Agent 任务交接记录体系 | DOC-Alpha | 已完成（经 R1） | T-DOC-QA-003 |
| T-DOC-QA-004 | 独立模拟新人接手与交接协议质检 | QA-DOC-004 | 未通过 | T-DOC-HANDOFF-004 |
| T-DOC-HANDOFF-004-R1 | 补齐自包含协议并消除历史看板冲突 | DOC-Alpha | 已完成 | T-DOC-QA-004 |
| T-DOC-QA-004-R1 | 独立复验交接协议 R1 | QA-DOC-004-R1 | 已通过 | T-DOC-HANDOFF-004-R1 |
| T-DOC-HANDOFF-004-CLOSE | 收口交接体系任务记录 | DOC-Alpha | 已完成 | T-DOC-QA-004-R1 |
| T-DOC-QA-004-CLOSE | 只读复核交接记录完成态 | QA-DOC-004-CLOSE | 已通过 | T-DOC-HANDOFF-004-CLOSE |
| T-VIS-001 | 清单怪兽界面与 Craft 组件覆盖度审计 | Ohm / FE-Alpha | 已完成 | 无 |
| T-VIS-002A | 补齐视觉原语与公共外观属性 | Ohm / FE-Alpha | 已完成 | T-VIS-001 |
| T-VIS-QA-002A-1 | 首轮独立质检视觉原语 | Parfit / QA-002A | 证据不足失败 | T-VIS-002A |
| T-VIS-QA-002A-2 | 二次独立质检视觉原语 | Pauli / QA-002A-2 | 发现阻断问题 | T-VIS-002A |
| T-VIS-002A-R1 | 修复物料面板拖入不创建节点 | Ohm / FE-Alpha | 已完成 | T-VIS-002A |
| T-VIS-QA-002A-R1 | 独立回归物料拖入创建链路 | Pasteur / QA-002A-R1 | 证据不足失败 | T-VIS-002A-R1 |
| T-VIS-002A-R2 | 建立有边界的物料拖入浏览器回归入口 | Ohm / FE-Alpha | 已完成 | T-VIS-002A-R1 |
| T-VIS-QA-002A-R2 | 独立执行物料浏览器回归入口 | Bohr / QA-002A-R2 | 已通过 | T-VIS-002A-R2 |
| T-VIS-002B | 补齐表单、选择、列表、导航、进度与反馈控件 | Ohm / FE-Alpha | 已完成 | T-VIS-002A |
| T-VIS-QA-002B | 独立质检业务控件补齐结果 | Helmholtz / QA-002B | 已通过 | T-VIS-002B |
| T-VIS-002C | 补齐多画板、多状态和导出模型 | Ohm / FE-Alpha | 已完成 | T-VIS-002B |
| T-VIS-QA-002C | 独立质检多画板模型 | Feynman / QA-002C | 已通过 | T-VIS-002C |
| T-VIS-003 | 使用可视化工具复现清单怪兽界面 | Ohm / FE-Alpha | 已完成 | T-VIS-002C |
| T-VIS-QA | 独立质检组件覆盖与界面复现 | Copernicus / QA-FINAL | 发现阻断问题 | T-VIS-003 |
| T-VIS-003-R1 | 修正桌宠状态、Widget 尺寸、怪兽蛋资源和只读回归 | Ohm / FE-Alpha | 已完成 | T-VIS-QA |
| T-VIS-QA-R1 | 最终返工独立验收 | Dirac / QA-FINAL-R1 | 发现只读脚本问题 | T-VIS-003-R1 |
| T-VIS-003-R2 | 修正 Playwright 会话文件写入项目 | Ohm / FE-Alpha | 已完成 | T-VIS-QA-R1 |
| T-VIS-QA-R2 | 最终只读回归验收 | Godel / QA-FINAL-R2 | 已通过 | T-VIS-003-R2 |
| T-VIS-PREVIEW | 启动实际 Craft 项目预览 | Ohm / FE-Alpha | 已完成 | T-VIS-QA-R2 |
| T-VIS-004 | 修复画板视口无法拖动和滚轮浏览 | Ohm / FE-Alpha | 已完成 | T-VIS-PREVIEW |
| T-VIS-QA-004 | 独立验收画板视口导航 | Descartes / QA-004 | 已通过 | T-VIS-004 |
| T-VIS-005 | 保留顶部页面切换前的画板视口位置 | Euler / FE-Current | 已完成 | T-VIS-004 |
| T-VIS-QA-005 | 独立验收页面切换后的画板视口恢复 | Kepler / QA-005 | 未通过 | T-VIS-005 |
| T-VIS-005-R1 | 修复快速页面切换丢失视口位置并隔离回归选择器 | Euler / FE-Current | 已完成 | T-VIS-QA-005 |
| T-VIS-QA-005-R1 | 独立复验页面切换后的画板视口恢复 | Tesla / QA-005-R1 | 未通过 | T-VIS-005-R1 |
| T-VIS-005-R2 | 修复移动端横向视口恢复丢失 | Euler / FE-Current | 已完成 | T-VIS-QA-005-R1 |
| T-VIS-QA-005-R2 | 独立复验移动端与快速切换视口恢复 | Maxwell / QA-005-R2 | 未通过 | T-VIS-005-R2 |
| T-VIS-005-R3 | 对齐 5173 实际预览并修复页面视口恢复 | Euler / FE-Current | 已完成待复验 | T-VIS-QA-005-R2 |
| T-VIS-005-R3-R1 | 用当前 Craft 项目替换已确认失效的旧 5173 预览服务 | Euler / FE-Current | 已完成 | T-VIS-005-R3 |
| T-VIS-QA-005-R3 | 最终验收实际 5173 页面视口恢复 | Hubble / QA-005-R3 | 未通过 | T-VIS-005-R3-R1 |
| T-VIS-005-R4 | 修复实际 5173 画布拖动回归并补齐最终证据 | Euler / FE-Current | 已完成 | T-VIS-QA-005-R3 |
| T-VIS-QA-005-R4 | 最终独立验收实际 5173 视口与完整回归 | Faraday / QA-005-R4 | 未通过 | T-VIS-005-R4 |
| T-VIS-QA-005-R4-R1 | 补齐移动快速切换与完整回归独立证据 | Planck / QA-005-R4-R1 | 未通过 | T-VIS-005-R4 |
| T-VIS-QA-005-R4-R2 | 只读补齐项目哈希与 Craft 序列化直比对 | Curie / QA-005-R4-R2 | 未通过 | T-VIS-005-R4 |
| T-VIS-QA-005-R4-R3 | 最小范围补齐操作后快照与项目 after hash | Fermi / QA-005-R4-R3 | 已通过 | T-VIS-005-R4 |
| T-VIS-006 | 保持顶部页面切换栏横向滚动位置 | Darwin / FE-Current-2 | 已完成 | T-VIS-005 |
| T-VIS-QA-006 | 独立验收顶部切换栏横向位置保持 | Noether / QA-006 | 未通过 | T-VIS-006 |
| T-VIS-006-R1 | 修复页面切换时“含 Craft 数据”状态丢失 | Darwin / FE-Current-2 | 已完成 | T-VIS-QA-006 |
| T-VIS-QA-006-R1 | 独立复验顶部栏位置与 Craft 状态保持 | Einstein / QA-006-R1 | 已通过 | T-VIS-006-R1 |
| T-VIS-007 | 恢复 5173 本地 Craft 预览服务 | Ptolemy / Preview-OPS | 已完成 | T-VIS-006 |
| T-DIGIPET-001 | 电子宠物主导的 L1 设计审计与视觉方向稿 | Design-Alpha | 已完成 | 无 |
| T-DIGIPET-002A | Craft / Flutter 实现边界只读侦察 | Ohm / FE-Alpha | 已完成 | 无 |
| T-DIGIPET-PREVIEW | 恢复 Craft 本地预览地址 | Ohm / FE-Alpha | 已完成 | 无 |
| T-DIGIPET-QA-001 | 独立质检电子宠物设计与视觉稿 | Gauss / QA-DIGIPET-001 | 已通过 | T-DIGIPET-001、T-DIGIPET-PREVIEW |
| T-DIGIPET-003A | 确认 Craft 组件化实现基线 | Peirce / Design-Alpha | 已完成 | T-DIGIPET-001 |
| T-DIGIPET-003B | 新增“清单怪兽·回响站”完整 Craft 工作区 | FE-Beta | 已完成 | T-DIGIPET-003A |
| T-DIGIPET-003C | 为回响站追加既有回归断言 | FE-Gamma | 已完成 | T-DIGIPET-003B（部分实现可读） |
| T-DIGIPET-003D | 无临时配置产物构建并换新 5173 预览 | FE-Beta | 外部 dist 写权限阻塞 | T-DIGIPET-003B |
| T-DIGIPET-003E | 构建到项目内独立目录并换新 5173 预览 | FE-Beta | 已完成 | T-DIGIPET-003B、T-DIGIPET-003C |
| T-DIGIPET-003F | 稳定恢复新版 5173 预览服务 | FE-Beta | 已完成 | T-DIGIPET-003E |
| T-DIGIPET-QA-003 | 独立质检回响站组件化工作区 | QA-DIGIPET-CRAFT | 发现阻断问题 | T-DIGIPET-003B、T-DIGIPET-003C、T-DIGIPET-003E、T-DIGIPET-003F |
| T-DIGIPET-003B-R1 | 修复提醒气泡文字不可读并补齐回归证据 | FE-Delta | 已由 R2 完成真实生效 | T-DIGIPET-QA-003 |
| T-DIGIPET-003B-R2 | 兼容已保存工作区并使提醒文字真实生效 | FE-Delta | 已完成 | T-DIGIPET-003B-R1 |
| T-DIGIPET-QA-003-R2 | 最终独立复验回响站组件化工作区 | QA-DIGIPET-CRAFT-R2 | 已通过 | T-DIGIPET-003B-R2 |
| T-DIGIPET-OPS-004 | 恢复回响站 5173 本地预览服务 | FE-Epsilon | 已完成 | T-DIGIPET-003E、T-DIGIPET-003B-R2 |
| T-DIGIPET-QA-OPS-004 | 独立质检 5173 预览恢复结果 | QA-OPS-004 | 已通过 | T-DIGIPET-OPS-004 |
| T-DIGIPET-004 | 设计“清单成长精灵”的幼年体与双分支完全体概念图 | Peirce / Design-Alpha | 已完成 | 无 |
| T-DIGIPET-QA-004 | 独立质检“清单成长精灵”设定与概念图 | QA-DIGIPET-004 | 已通过 | T-DIGIPET-004 |
| T-DIGIPET-004-R1 | 去狐狸化重绘幼年体，并将拳手头部完全纸封 | Peirce / Design-Alpha | 已完成并由 R2 继承 | T-DIGIPET-QA-004 |
| T-DIGIPET-QA-004-R1 | 独立质检去狐狸化与拳手纸封头部重绘 | QA-DIGIPET-004-R1 | 未通过：幼体仍像纸质小狗 | T-DIGIPET-004-R1 |
| T-DIGIPET-004-R2 | 彻底去犬科化并重构抽象合同幼体剪影 | Peirce / Design-Alpha | 已完成 | T-DIGIPET-QA-004-R1 |
| T-DIGIPET-QA-004-R2 | 独立质检 V3 抽象合同幼体剪影 | QA-DIGIPET-004-R2 | 已通过 | T-DIGIPET-004-R2 |
| T-DIGIPET-004-R3 | 仅重绘大学者头部并统一三形态头部语言 | Peirce / Design-Alpha | 已完成并由 R4 继承 | T-DIGIPET-QA-004-R2 |
| T-DIGIPET-QA-004-R3 | 独立质检 V4 大学者头部与不变量 | QA-DIGIPET-004-R3 | 未通过：画布及全图像素漂移 | T-DIGIPET-004-R3 |
| T-DIGIPET-004-R4 | 将已通过的新学者头部严格局部合成到 V3 | Peirce / Design-Alpha | 已完成 | T-DIGIPET-QA-004-R3 |
| T-DIGIPET-QA-004-R4 | 独立质检 V5 局部合成与像素不变量 | QA-DIGIPET-004-R4 | 中止：未返回裁决 | T-DIGIPET-004-R4 |
| T-DIGIPET-QA-004-R4B | 重新独立质检 V5 局部合成与像素不变量 | QA-DIGIPET-004-R4B | 已通过 | T-DIGIPET-004-R4 |
| T-DIGIPET-005 | 设计幼年体与双分支完全体之间的共同成长体 | Peirce / Design-Beta | 已完成 | T-DIGIPET-QA-004-R4B |
| T-DIGIPET-QA-005 | 独立质检共同成长体与四形态进化链 | QA-DIGIPET-005 | 已通过 | T-DIGIPET-005 |
| T-DIGIPET-006 | 设计可孵化诺卷仔的物种专属宠物蛋及花纹系统 | Peirce / Design-Beta | 用户反馈后返工 | T-DIGIPET-QA-005 |
| T-DIGIPET-QA-006 | 独立质检“初诺契茧”宠物蛋与花纹系统 | QA-DIGIPET-006 | 已通过 | T-DIGIPET-006 |
| T-DIGIPET-006-R1 | 重构为全物种统一恐龙蛋模板，仅以配色区分宠物 | Peirce / Design-Beta | 已完成 | T-DIGIPET-QA-006 |
| T-DIGIPET-QA-006-R1 | 独立质检统一恐龙蛋模板与仅换色规则 | QA-DIGIPET-006-R1 | 已通过 | T-DIGIPET-006-R1 |
| T-DIGIPET-006-R2 | 保留统一白色恐龙蛋母型，改用幼年体专属壳面纹样区分物种 | Peirce / Design-Beta | 质检未通过：三状态视角与纹样投影漂移 | T-DIGIPET-QA-006-R1 |
| T-DIGIPET-QA-006-R2 | 独立质检白蛋母型与幼年体派生纹样系统 | QA-DIGIPET-006-R2 | 未通过 | T-DIGIPET-006-R2 |
| T-DIGIPET-006-R3 | 锁定同一蛋体与纹样投影，仅修正三状态发光变化 | Peirce / Design-Beta | 已完成 | T-DIGIPET-QA-006-R2 |
| T-DIGIPET-QA-006-R3 | 独立复验三状态同基底与仅发光变化 | QA-DIGIPET-006-R3 | 已通过 | T-DIGIPET-006-R3 |
| T-DIGIPET-006-R4 | 将白蛋母型锁定为旋转轴对称，任意角度保持相同画面尺寸 | Peirce / Design-Beta | 已完成 | T-DIGIPET-QA-006-R3 |
| T-DIGIPET-QA-006-R4 | 独立质检旋转轴对称母型与等尺寸多视角 | QA-DIGIPET-006-R4 | 已通过 | T-DIGIPET-006-R4 |
| T-DIGIPET-007 | 契响卷灵宠物蛋与四阶段回响站界面设计 | Hegel / Design-Gamma | 已由 007A/007B 完成 | T-DIGIPET-QA-006-R4、T-DIGIPET-005 |
| T-DIGIPET-007A | 初诺契茧界面稿与五阶段共享骨架 | Pasteur / Design-Delta | 已完成 | T-DIGIPET-QA-006-R4 |
| T-DIGIPET-007B | 契响卷灵四阶段界面稿与五阶段总览 | Pasteur / Design-Delta | 已完成 | T-DIGIPET-007A |
| T-DIGIPET-QA-007A | 独立质检初诺契茧界面稿与共享骨架 | Goodall / QA-DIGIPET-007A | 已通过 | T-DIGIPET-007A |
| T-DIGIPET-QA-007B | 独立质检四阶段界面稿与五阶段总览 | Plato / QA-DIGIPET-007B | 已通过 | T-DIGIPET-007B |
| T-DIGIPET-007A-R1 | 修正蛋页蛋体纵向拉长与光晕比例 | Pasteur / Design-Delta | 已完成 | T-DIGIPET-QA-007A、用户反馈 |
| T-DIGIPET-QA-007A-R1 | 独立复验蛋页比例与拉长观感修正 | Dewey / QA-DIGIPET-007A-R1 | 已通过 | T-DIGIPET-007A-R1 |
| T-DIGIPET-007A-R2 | 移除蛋页横向光晕，仅保留宠物蛋本体 | Pasteur / Design-Delta | 已完成 | T-DIGIPET-007A-R1、用户反馈 |
| T-DIGIPET-QA-007A-R2 | 独立复验蛋页仅保留宠物蛋本体 | Bacon / QA-DIGIPET-007A-R2 | 已通过 | T-DIGIPET-007A-R2 |
| T-DIGIPET-CRAFT-008 | 将 R2 蛋阶段同步到 Craft 可编辑工作区 | FE-Beta / Craft-R2-Successor | 实现已完成；独立QA受浏览器执行环境阻塞 | T-DIGIPET-QA-007A-R2 |
| T-DIGIPET-QA-CRAFT-008 | 独立验收 R2 蛋阶段 Craft 可编辑页面与 15 旧画板非回归 | Pascal / QA-CRAFT-008 | 未通过 | T-DIGIPET-CRAFT-008 |
| T-DIGIPET-QA-CRAFT-008-R1 | 独立复验16画板验证、节点可编辑性与运行时零错误 | Plato / QA-CRAFT-008-R1 | 未通过：独立浏览器循环未完成 | T-DIGIPET-CRAFT-008 |
| T-DIGIPET-QA-CRAFT-008-R2 | 独立完成16画板循环与全过程零错误监控 | Planck / QA-CRAFT-008-R2 | 未通过：最终读数未完成 | T-DIGIPET-CRAFT-008 |
| T-DIGIPET-QA-CRAFT-008-R3 | 最终复验旧怪兽页排除R2文案与零错误计数 | Leibniz / QA-CRAFT-008-R3 | 阻塞：浏览器脚本未执行 | T-DIGIPET-CRAFT-008 |

## 任务卡

### T-DOC-CONTENT-005

任务ID：T-DOC-CONTENT-005

目标：把活跃主项目、Craft 工作区和恢复副本差异整理成可供任意 Agent 快速读取的当前内容地图。

背景：只读审计确认恢复副本 HEAD `c20254a` 是活跃主仓 HEAD `424ddb4` 的祖先且落后两个提交；排除 Git、构建与平台生成缓存后，恢复副本 239 个项目文件全部能在活跃主项目找到，活跃主项目另有 214 个文件。恢复副本未提交内容均已被取代、失效或由 `D-REPO-IDENTITY-001` 摘要吸收。

验收标准：
1. `docs/pm/current-software-status.md` 新增“项目内容地图”，覆盖 Flutter App、九个领域/运行时包、契约、设计文档与视觉资产、PM 文档、`.features`、工具、构建产物、QA 证据、临时诊断项和外部 Craft 工作区。
2. 每类内容写明准确路径、用途、事实源等级，以及属于源码、设计源、派生资产、构建产物、QA 证据还是本地临时文件。
3. 单独记录恢复副本比对结论：没有旧副本独有且主版本缺失的项目文件；同路径差异及旧 D-046 的处置口径与 `D-REPO-IDENTITY-001` 一致。
4. 明确主项目唯一事实源、Craft 配套工作区和恢复副本三者边界；不得把 Craft 或恢复副本表述为第二主仓。
5. README 只增加内容地图短入口，不复制完整清单。
6. `.features/T-DOC-CONTENT-005/status.md` 按协议完整记录本任务，并把任务加入 `.features/_registry.md`；状态为 `ready_for_qa`。
7. 所有列出路径存在；不修改、复制、移动或删除产品文件、旧副本、Craft 文件或证据。

允许修改的文件范围：
- `README.md`
- `docs/pm/current-software-status.md`
- `.features/_registry.md`
- `.features/T-DOC-CONTENT-005/status.md`

任务记录：`.features/T-DOC-CONTENT-005/status.md`

禁止事项：
- 不得修改 `PROJECT_BOARD.md`、`pm-decisions.md`、AGENTS、源码、素材、配置、测试、构建产物或外部目录。
- 不得新建 `onboarding-index.md` 或其他第二入口文档。
- 不得把旧副本同路径但较旧的内容合并覆盖到主项目。

依赖：T-REPO-IDENTITY-001。

### T-DOC-CONTENT-005 最终裁决

QA-DOC-CONTENT-005 八项验收全部通过，完成态又由 QA-DOC-CONTENT-005-CLOSE 只读复核通过。恢复副本不存在主项目缺失的独有项目文件；有效历史语义已由 `D-REPO-IDENTITY-001` 摘要吸收。当前项目内容地图、三类目录边界、事实源层级和下一接手入口均已落盘，任务记录与 registry 同步为 `completed`。DOC-Alpha 转入待命。

### T-REPO-SAFETY-001

任务ID：T-REPO-SAFETY-001

目标：将主项目当前有价值的产品、设计、证据与治理内容分组提交并推送到现有 `origin/master`，消除裸工作树风险。

背景：主仓 `master` HEAD 为 `424ddb4`，本地比 `origin/master` 领先两个像素宠物提交；工作树还包含产品修复、设计资产、PRD、交接体系、QA 证据和项目工具。用户已明确授权执行提交与推送。临时浏览器会话、根目录诊断 JSON、服务日志、build/dist 不应进入版本库。

验收标准：
1. 不切换分支、不改写历史、不 force push；保持 `master`，在现有提交之上创建符合 `[T-REPO-SAFETY-001] 描述` 格式的逻辑提交。
2. 提交并保全当前有价值内容：产品源码/测试、`tool/build_windows.ps1`、`tool/craft-echo-preview/**`、设计文档与 `docs/assets/**`、PRD/PDF、QA 证据、PM 文档、AGENTS/README、PROJECT_BOARD、`.features/**`、`.codex/**`。
3. 只允许实际编辑 `.gitignore`、`.features/_registry.md` 和 `.features/T-REPO-SAFETY-001/status.md`；其余文件只按当前内容暂存和提交，不改写。
4. `.gitignore` 明确排除 `.playwright-cli/`、`shot*-out.json`、`snap*-out.json`、`webbridge-req-*.json`；既有日志、build、dist 忽略规则保持有效。
5. 提交前运行 `git diff --check`，并运行 `apps/list_monster_app/test/desktop_pet_view_test.dart` 的 Flutter 定向测试；失败则停止推送并在任务记录标记阻塞。
6. 提交后 `git status --short` 为空；临时项只因 ignore 消失，不得删除其磁盘内容。
7. 将 `master` 正常推送到现有 origin，推送后本地 HEAD 与 `origin/master` 一致，包含原先两个领先提交和本任务新提交。
8. `.features/T-REPO-SAFETY-001/status.md` 完整记录提交哈希、验证、排除项、风险和下一接手点，并在 registry 登记为 `ready_for_qa`。

允许修改的文件范围：
- `.gitignore`
- `.features/_registry.md`
- `.features/T-REPO-SAFETY-001/status.md`
- Git 索引与提交对象（仅暂存/提交当前主仓已有工作树内容）
- 允许暂存但禁止改写：`AGENTS.md`、`README.md`、`PROJECT_BOARD.md`、`.codex/**`、`apps/**`、`packages/**`、`docs/**`、`output/playwright/**`、`tool/**`、`AI时代的PRD（输入）规范.pdf`

任务记录：`.features/T-REPO-SAFETY-001/status.md`

禁止事项：
- 不得删除、还原或重写任何现有用户修改。
- 不得提交 `.playwright-cli/**`、根目录诊断 JSON、服务日志、`build/**`、`dist/**`。
- 不得修改产品、设计、PM 文档、看板或素材内容；只允许按现状暂存。
- 不得 amend、rebase、reset、clean、force push 或切换分支。
- 不得操作 `craft-demo` 或恢复副本。

依赖：T-REPO-IDENTITY-001。

### T-REPO-SAFETY-001-R1

任务ID：T-REPO-SAFETY-001-R1

目标：查明 Flutter 定向测试 300 秒无输出的原因，取得可复核的测试结果；仅在测试明确通过后继续 T-REPO-SAFETY-001 的逻辑提交与正常推送。

背景：首轮已完成忽略项核对与 `git diff --check`，但绝对路径调用本机 Flutter SDK 后，定向测试连续 300 秒无 stdout/stderr 并以退出码 124 超时。当前 Git 索引为空，HEAD 仍为 `424ddb4`，没有提交或推送。用户已授权执行三项安全任务，但主仓测试门禁不得绕过。

验收标准：
1. 在任务记录追加诊断证据：Flutter/Dart 工具链是否能在有限时间内启动、测试启动阶段卡在哪里、是否存在锁、依赖解析或残留进程问题；所有诊断命令设置有限超时，不无限等待。
2. 先使用只读或测试所需的常规诊断验证绝对路径 SDK，包括 Flutter 版本、Dart 版本和 doctor 信息；不得安装或升级 SDK、不得修改系统配置。
3. 从 `apps/list_monster_app` 目录使用绝对路径 SDK，以可观察输出方式重跑 `test/desktop_pet_view_test.dart`；允许使用 `--no-pub`、verbose/expanded reporter 与最长 900 秒的有限超时，但必须取得明确退出码和输出证据。
4. 若重跑未明确通过，保持任务 `blocked`，Git 索引为空，不得提交或推送；记录新的阻塞点与下一接手动作。
5. 若重跑明确通过，重新执行 `git diff --check`，核对暂存清单不含 `.playwright-cli/**`、根目录诊断 JSON、日志、`build/**`、`dist/**`，然后按原任务卡创建 `[T-REPO-SAFETY-001]` 逻辑提交并正常推送 `master`。
6. 成功路径必须满足：工作树对纳入范围无未提交内容，临时文件仍在磁盘且只因 ignore 隐藏；本地 HEAD 与 `origin/master` 一致，并包含原领先提交 `590f0d1`、`424ddb4` 及本任务新提交。
7. 继续维护同一记录 `.features/T-REPO-SAFETY-001/status.md`，不新建 R1 平行记录；成功时正文转为 `ready_for_qa`，失败时维持 `blocked`，registry 同步同一状态。

允许修改的文件范围：
- `.gitignore`
- `.features/_registry.md`
- `.features/T-REPO-SAFETY-001/status.md`
- Git 索引与提交对象（仅在测试明确通过后，按原任务卡暂存/提交当前主仓已有工作树内容）
- 允许暂存但禁止改写：`AGENTS.md`、`README.md`、`PROJECT_BOARD.md`、`.codex/**`、`apps/**`、`packages/**`、`docs/**`、`output/playwright/**`、`tool/**`、`AI时代的PRD（输入）规范.pdf`
- 测试产生且已被忽略的项目内缓存/构建产物；不得主动纳入提交

任务记录：`.features/T-REPO-SAFETY-001/status.md`

禁止事项：
- 不得绕过、删除或弱化 Flutter 测试门禁。
- 不得安装/升级 Flutter 或 Dart，不得修改系统 PATH、SDK 文件或系统配置。
- 不得修改产品、设计、PM 文档、看板或素材内容；上述文件只允许按现状暂存。
- 不得删除、还原或重写现有用户修改；不得 amend、rebase、reset、clean、force push 或切换分支。
- 不得操作 `craft-demo` 或恢复副本。

依赖：T-REPO-SAFETY-001 首轮阻塞记录。

### T-REPO-SAFETY-001-R1 阶段结果

Flutter 启动超时已定位为项目外 SDK 的 Git 所有权校验与缓存写权限问题；在不改系统配置的受控环境下，目标测试取得退出码 0，5/5 通过，`git diff --check` 亦通过。当前暂存 10 个文件、合计 1,333,705 字节，其中 `tool/craft-echo-preview/**` 为静态预览构建产物，最大三份 JavaScript 各约 422 KB。自动权限审查因“在默认分支 `master` 创建提交并包含生成预览产物”拒绝提交。当前 HEAD 仍为 `424ddb4`，未提交、未推送、未取消暂存；需用户在知悉该风险范围后明确批准，方可继续。

2026-08-11 用户已明确回复“我批准将上述内容提交并推送到 origin/master”，批准范围包括：直接提交并推送现有 GitHub `origin/master`、首批静态预览构建产物，以及后续设计素材、PRD、QA 证据和交接文档；仍禁止改写历史、force push 或删除本地文件。

Repo-Alpha 交接：Flutter 定向测试 5/5 通过；HEAD 仍为 `424ddb4`；10 个文件、1,333,705 字节暂存且无禁入项。两次提交均因其线程无法获得根会话可信用户授权而被权限审查拒绝，未提交、未推送、未取消暂存。由继承用户原始授权上下文的 Repo-Beta 从现有暂存现场继续。

Repo-Beta 实施结果：共创建并推送 5 个逻辑提交，最终 HEAD、`origin/master` 跟踪引用与 GitHub 远端均为 `db4f21e94a78de51a291facf16fd3acf906c0d4b`；Flutter 定向测试 5/5 通过，实施结束时工作树为空且禁入项为零。普通 `git fetch` 仍被既有损坏的 Codex checkpoint 引用阻断，已作为独立风险保留，不影响本次通过跟踪引用与 `ls-remote` 完成的远端一致性核验。

### T-REPO-QA-SAFETY-001

任务ID：T-REPO-QA-SAFETY-001

目标：以只读方式独立验收主仓安全提交是否完整、合规、可恢复，并裁决能否进入收口。

背景：Repo-Beta 报告在 `master` 上创建并推送 5 个逻辑提交，最终本地和 GitHub 远端均为 `db4f21e94a78de51a291facf16fd3acf906c0d4b`；Flutter 定向测试 5/5 通过。普通 fetch 受既有损坏 Codex checkpoint 引用影响，实施 Agent 已改用跟踪引用和 `ls-remote` 交叉核验。PM 派发 QA 时会新增一处未提交的 `PROJECT_BOARD.md` 看板更新，该差异属于 PM 派单，不得归因于实施 Agent。

验收标准：
1. 只读确认当前分支为 `master`，历史包含 `590f0d1`、`424ddb4` 及本任务 5 个新提交；提交信息符合 `[T-REPO-SAFETY-001]` 格式且未出现 amend/rebase/force 痕迹。
2. 复核 5 个提交的文件清单与分组，确认产品源码/测试、项目工具、静态预览、设计文档与素材、PRD/PDF、QA 证据、PM 文档、协作体系和任务记录均已纳入。
3. 确认提交历史不含 `.playwright-cli/**`、根目录诊断 JSON、服务日志、`build/**`、`dist/**`；对应临时文件若存在，应由 ignore 排除而非被删除。
4. 复核 `.gitignore` 新增规则有效，`git diff --check` 通过；验证任务记录中 Flutter 命令、退出码 0 与 5/5 结果证据完整可信。
5. 独立核对本地 HEAD、`refs/remotes/origin/master` 与 `git ls-remote origin refs/heads/master` 均为 `db4f21e94a78de51a291facf16fd3acf906c0d4b`；不得以受损 checkpoint 导致的普通 fetch 失败误判本次 push 失败，但须确认风险记录准确。
6. 除 PM 派单产生的 `PROJECT_BOARD.md` 未提交差异外，不应存在其他实施遗留的 tracked/untracked 工作树变化；不得清理或修改任何文件。
7. `.features/T-REPO-SAFETY-001/status.md` 与 `.features/_registry.md` 均为 `ready_for_qa`，提交哈希、排除项、风险和下一接手点完整一致。
8. 输出结构化 JSON：`task_id`、`verdict`（pass/fail）、逐项 `criteria`、`blocking_issues`、`scope_check`、`remote_recovery_check`、`summary`。

允许修改的文件范围：无；全程只读。

任务记录：QA 不创建或修改任务记录；裁决由 PM 写入 `PROJECT_BOARD.md`。

禁止事项：不得编辑、暂存、提交、推送、清理、修复引用或操作 `craft-demo`/恢复副本。

依赖：T-REPO-SAFETY-001-R1。

### T-REPO-QA-SAFETY-001 裁决

QA 裁决为 fail，无范围违规。主仓提交内容、禁入项、ignore、工作树与本地/跟踪引用均通过核查；阻断问题仅在任务记录：`.features/T-REPO-SAFETY-001/status.md` 仍称 4 个逻辑提交、最终哈希 `1292f51`，遗漏第 5 个记录提交 `db4f21e`，使远端恢复锚点和下一接手说明与实际历史不一致。退回原实现线程 Repo-Beta 返工。

### T-REPO-SAFETY-001-R2

任务ID：T-REPO-SAFETY-001-R2

目标：把主仓安全任务记录校正为实际 5 个提交与最终远端哈希，消除交接事实不一致。

背景：QA 已确认仓库内容、禁入项、ignore、工作树和跟踪引用本身正常；唯一阻断是任务状态页仍停留在第 4 个提交 `1292f51`。实际第 5 个记录提交及本地/远端最终哈希为 `db4f21e94a78de51a291facf16fd3acf906c0d4b`。

验收标准：
1. 继续维护同一 `.features/T-REPO-SAFETY-001/status.md`，正文状态进入 `rework` 后在自测完成时恢复 `ready_for_qa`；不得新建 R2 平行记录。
2. 将所有“4 个提交”“最终为 `1292f51`”及下一步只复核 4 个提交的过时表述，统一校正为实际 5 个提交与最终哈希 `db4f21e94a78de51a291facf16fd3acf906c0d4b`。
3. 保留并逐项列明 5 个提交哈希及用途；不得抹除 Flutter 5/5、禁入项、首次推送、凭据登录和 checkpoint 引用风险等既有证据。
4. `.features/_registry.md` 与正文状态一致为 `ready_for_qa`，更新时间同步。
5. 只修改两份任务记录文件；`PROJECT_BOARD.md` 仅允许按 PM 当前内容暂存，不得改写。
6. 创建符合 `[T-REPO-SAFETY-001] 校正最终提交记录` 格式的提交并正常推送 `master`；推送后本地 HEAD、跟踪引用与远端一致，并把新记录提交哈希作为第 6 个提交追加回状态页时，不得再次形成自指遗漏：状态页应明确区分“5 个实施提交”和“本次 R2 记录校正提交”，远端最终锚点以推送后的实际 HEAD 为准。
7. 若为记录本次 R2 最终提交哈希需要产生后续记录提交，必须采用非自指表述：记录“R2 记录提交的父提交/推送批次”及可由 Git 历史定位的提交信息，不强行把当前尚未生成的自身哈希写入自身内容；下一接手点须说明以 `git log -1` 与远端引用复核最终锚点。

允许修改的文件范围：
- `.features/T-REPO-SAFETY-001/status.md`
- `.features/_registry.md`
- Git 索引与提交对象
- 允许暂存但禁止改写：`PROJECT_BOARD.md`

任务记录：`.features/T-REPO-SAFETY-001/status.md`

禁止事项：不得修改其他文件；不得重写历史、amend、rebase、reset、clean、force push 或切换分支；不得操作 `craft-demo` 或恢复副本。

依赖：T-REPO-QA-SAFETY-001 fail 裁决。

### T-DOC-HANDOFF-001

任务ID：T-DOC-HANDOFF-001

目标：统一仓库入口与当前软件状态，使后续 Agent 能在五分钟内识别当前里程碑、事实源、近期交付、待决事项和工作区风险。

背景：根 README 仍停留在“节点 2 / 下一节点 3”，而 `docs/pm/current-software-status.md` 已记录节点 1 至 7 完成；2026-08-07 至 2026-08-09 又完成像素宠物、回响站阶段页和 Craft 工作区 CRUD。当前工作树含大量未提交文件，产品修改、文档资产、截图和诊断产物混杂，本任务只整理入口与状态，不移动或删除文件。

验收标准：
1. `README.md` 的当前阶段与 `docs/pm/current-software-status.md` 一致，不再出现节点 2 尚未进入节点 3的过期结论。
2. `docs/pm/current-software-status.md` 明确标注更新时间 2026-08-09，并覆盖：当前里程碑、2026-08-07 至 2026-08-09 已完成交付、尚未完成或待人工裁决事项、已知边界、工作树风险、后续 Agent 的事实源读取顺序。
3. 两份文档明确区分 Flutter 主应用与 `C:/Users/Administrator/Documents/craft-demo` Craft 编辑器，避免把 5173 与 Flutter 预览混为一谈。
4. 所有状态断言均可由现有 `PROJECT_BOARD.md`、`docs/pm/wave-0-control-board.md`、`docs/pm/pm-decisions.md`、Git 历史或当前工作树复核；不把未提交内容写成已发布。
5. 不创建新文档，不移动、不删除、不重命名任何文件，不修改源码、配置、构建产物、截图或其他文档。
6. 文档链接使用仓库相对路径且目标存在；执行文档内链与关键状态词检查通过。

允许修改的文件范围：
- `README.md`
- `docs/pm/current-software-status.md`

禁止事项：
- 不得修改 `PROJECT_BOARD.md`、`AGENTS.md`、源码、配置、测试或任何其他文件。
- 不得清理当前工作树，不得覆盖其他人的既有未提交修改。
- 不得新增依赖或运行会改变项目状态的构建命令。
- 不得将 Craft 编辑器进度表述为 Flutter 主应用已发布能力。

依赖：无。

### T-DOC-HANDOFF-001 最终裁决

独立 QA-DOC-001 已通过：两份交接文档里程碑一致，2026-08-07 至 2026-08-09 近期交付、待决事项、双项目边界、工作树风险和事实源读取顺序完整；关键状态可追溯，内链目标存在，未发现阻断问题或范围违规。DOC-Alpha 转入待命。

### T-DOC-AUDIT-002

任务ID：T-DOC-AUDIT-002

目标：只读盘点当前项目文件与文档治理问题，形成后续可安全整理的分类清单与优先级。

背景：仓库当前混有已跟踪源码、未跟踪产品文档与视觉资产、根目录诊断 JSON、Playwright 会话目录、构建/预览输出和服务日志。用户要求项目可被任意后续 Agent 快速接手；在没有逐项确认归属前，禁止直接删除或搬迁。

验收标准：
1. 按“权威活文档、历史/重复文档、源资产、可再生成产物、临时诊断文件、配置/工具状态、归属不明需人工确认”分类列出具体路径。
2. 识别 README、PROJECT_BOARD、wave-0-control-board、current-software-status、pm-decisions、PRD、DESIGN 等事实源之间的重叠或冲突，并给出唯一入口建议。
3. 检查活文档 frontmatter、命名、链接和更新时间风险；区分项目既有约定与 forge-doc-policy 建议，不擅自迁移既有 `docs/pm/` 体系。
4. 对每个拟整理项标注建议动作、风险等级、是否需要用户确认、是否可能影响未提交工作。
5. 明确给出可直接安全处理项与必须先询问用户项；本任务不修改、创建、移动、删除任何文件。
6. 所有结论可由 `rg --files`、文件元数据、Git 跟踪状态、现有文档内容和目录关系复核。

允许修改的文件范围：无，只读审计。

禁止事项：
- 不得修改、创建、移动、删除或重命名任何文件。
- 不得运行格式化、构建、清理或会写入项目的命令。
- 不得把未跟踪文件直接认定为垃圾。
- 不得建议绕过用户确认删除疑似用户产物。

依赖：T-DOC-QA-001。

### T-DOC-AUDIT-002-R1

任务ID：T-DOC-AUDIT-002-R1

目标：在缩小范围后，只读完成可操作的文件治理审计。

背景：T-DOC-AUDIT-002 因全仓视觉资产数量过大未及时收敛，现按失败协议拆小重派给原 Agent；只审计项目根目录、`docs/pm/`、`.playwright-cli/`、`output/playwright/` 和 `dist/` 的一级分类。

验收标准：
1. 根目录疑似临时/诊断文件、服务日志、输入资料、权威入口和未跟踪配置目录均有建议动作、风险与确认要求。
2. `docs/pm/` 的当前权威、历史节点总结、运行日志/截图和内容重叠已分类，并给出唯一入口顺序。
3. `.playwright-cli/`、`output/playwright/`、`dist/` 已按可再生成性、验收证据属性和确认要求完成目录级分类。
4. 明确区分可直接安全处理项与必须先询问用户项，不把未跟踪文件直接认定为垃圾。
5. 不修改、创建、移动、删除或重命名任何文件，不运行写入命令。
6. 报告可在三分钟内读完。

允许修改的文件范围：无，只读审计。

禁止事项：
- 不得递归分析 `docs/assets/` 具体文件。
- 不得修改、清理、构建或扩大到 `craft-demo`。

依赖：T-DOC-AUDIT-002。

### T-DOC-AUDIT-002-R1 审计结论

只读审计已完成。当前首要治理冲突是 `PROJECT_BOARD.md`、`docs/pm/wave-0-control-board.md` 与 `docs/pm/agent-roster.md` 同时记录任务或编制；建议入口顺序为 `README.md` → `docs/pm/current-software-status.md` → 当前任务看板 → PM 决策 → 路线图/PRD/历史节点资料。根目录诊断 JSON、服务日志、`.playwright-cli/`、`output/playwright/` 与 `dist/` 具有诊断、QA 证据或待交付属性，未获用户确认前保持原位。`DOC-Alpha` 转入待命。

### T-DOC-ASSETS-003

任务ID：T-DOC-ASSETS-003

目标：在既有说明文档中建立唯一的项目设计物料地图，使后续 Agent 能直接定位宠物设计、宠物蛋、App 界面设计源、Flutter 运行时资产、Craft 可编辑源与 QA 证据。

背景：素材已本地保存，但 README 与当前状态页只零散提及“像素资产已接入”，没有按“视觉事实源、派生运行时资产、可编辑界面源、验收证据”区分位置。不得复制或移动已有素材，避免产生第二份事实源。

验收标准：
1. `docs/pm/current-software-status.md` 新增清晰的“设计物料地图”，覆盖宠物/宠物蛋最终视觉源、五阶段界面设计物料、Flutter 运行时 PNG、Craft 公共资产、Craft 可编辑画板源、两仓 QA 截图位置。
2. 每一类均列出准确路径、用途、事实源等级和修改注意事项；外部 `craft-demo` 使用绝对路径。
3. 明确最终宠物与蛋的当前文件：`checklist-creature-pixel-evolution-v3-r3.png`、`egg-turnaround-pixel-v7.png`、`egg-glow-states-pixel-v3.png`。
4. 明确 `docs/assets/visuals/**` 是设计事实与过程资产，`packages/sprite_runtime/assets/monsters/**` 和 `craft-demo/public/assets/**` 是派生运行时副本，`output/playwright/**` 只作 QA 证据而非设计事实源。
5. `README.md` 增加一个短入口，指向当前状态页的物料地图，不重复长清单。
6. 所有列出的本地路径均存在；不创建、复制、移动、重命名或删除物料，不修改设计、源码、运行时资产或 QA 证据。

允许修改的文件范围：
- `README.md`
- `docs/pm/current-software-status.md`

禁止事项：
- 不得修改 `PROJECT_BOARD.md`、`docs/DESIGN.md`、素材、源码、配置、测试、截图或 `craft-demo`。
- 不得新增文档或目录，不得把 QA 截图标成可编辑源文件。
- 不得把历史草稿版本标为当前最终物料。

依赖：T-DOC-QA-001。

### T-DOC-ASSETS-003 最终裁决

独立 QA-DOC-003 已通过且无范围违规：物料地图完整覆盖最终宠物与蛋视觉源、五阶段界面设计物料、Flutter 运行时资产、Craft 公共资产、Craft 可编辑画板源及两仓 QA 证据；所有列出路径均存在，事实源层级清楚，未复制、移动、删除或修改任何物料。DOC-Alpha 转入待命。

### T-DOC-HANDOFF-004

任务ID：T-DOC-HANDOFF-004

目标：建立一套可并行、可追溯、可由任意 Agent 续接的任务交接记录体系，并提供用户可直接复用的一句话更新指令。

背景：当前 Agent 完工后只在会话中返回摘要，仓库没有 `.features` 任务交接目录；`PROJECT_BOARD.md`、`wave-0-control-board.md` 与 `agent-roster.md` 还存在全局状态职责重叠。多个 Agent 不能同时写同一日志，因此采用“全局 PM 看板 + 每任务独立 status”的分层机制。

验收标准：
1. `AGENTS.md` 明确四层事实源：README 入口、当前状态快照、`PROJECT_BOARD.md` 全局任务/QA 裁决、`.features/{任务ID}/status.md` 任务级改动与接手记录。
2. `AGENTS.md` 在全员公约中规定：实现 Agent 在最终报告前必须创建或更新自己的任务 `status.md`；任务卡必须把该文件列入允许修改范围；禁止修改其他任务记录。
3. 任务记录模板至少包含任务身份、当前状态、变更文件、行为变化、验证证据、风险/未决事项、下一接手点、最近更新时间与负责人；状态枚举和追加/覆盖规则清楚。
4. QA Inspector 保持只读，不写任务记录；PM 把 QA 裁决写入 `PROJECT_BOARD.md`，返工仍由原实现 Agent 续写同一任务记录。
5. 新建 `.features/_registry.md` 作为协议与索引说明，新建 `.features/T-DOC-HANDOFF-004/status.md` 作为合规样例和本任务真实交接记录；两份活文档带合规 frontmatter。
6. README 和 `docs/pm/current-software-status.md` 增加明确接手顺序与可复制的一句话指令：把改动更新到 `.features/<任务ID>/status.md`，按 `AGENTS.md` 模板记录改动、验证、风险和下一接手点。
7. 解决看板职责冲突：`PROJECT_BOARD.md` 是唯一当前全局任务与 QA 裁决看板；`wave-0-control-board.md`、`agent-roster.md` 作为历史节点/旧名册参考，不再承担当前任务状态。
8. 明确并发规则：每张任务卡的实现文件与其独立 status 文件组成互斥范围；禁止多个并行任务共享同一 status 文件；全局看板仅 PM 修改。
9. 所有新增/修改链接存在，未修改产品源码、设计素材、运行时资产、测试、配置或 QA 证据。

允许修改的文件范围：
- `AGENTS.md`
- `README.md`
- `docs/pm/current-software-status.md`
- `.features/_registry.md`
- `.features/T-DOC-HANDOFF-004/status.md`

禁止事项：
- 不得修改 `PROJECT_BOARD.md`、`wave-0-control-board.md`、`agent-roster.md`、`pm-decisions.md` 或其他文件。
- 不得创建新的 docs 分类、迁移历史文档或清理工作树。
- 不得要求 QA Agent 写文件，不得让并行任务共享同一 status 文件。
- 不得修改源码、配置、素材、构建产物或外部 `craft-demo`。

依赖：T-DOC-QA-003。

### T-DOC-HANDOFF-004-R1

任务ID：T-DOC-HANDOFF-004-R1

目标：补齐任务交接索引的自包含协议，并消除 README 对历史看板职责的混淆。

背景：QA-DOC-004 判定首轮两项阻断：`.features/_registry.md` 只链接 AGENTS，未直接列出状态枚举和必填字段；README 仍把 `wave-0-control-board.md` 与当前看板并列为当前依据，违反“PROJECT_BOARD 唯一当前全局看板”。

验收标准：
1. `.features/_registry.md` 直接列出完整状态枚举及语义，不依赖跳转 AGENTS 才能理解。
2. `.features/_registry.md` 直接列出每个任务 `status.md` 的全部必填字段、追加/覆盖规则、QA/PM 边界和用户复制指令。
3. README 明确 `PROJECT_BOARD.md` 是唯一当前全局任务与 QA 裁决看板；`wave-0-control-board.md` 和 `agent-roster.md` 仅为历史节点/旧名册参考，不得并列为当前依据。
4. `.features/T-DOC-HANDOFF-004/status.md` 追加 R1 返工记录，保留首轮历史，更新变更、验证、风险与下一接手点，状态回到 `ready_for_qa`。
5. README、AGENTS、当前状态页和 registry 对四层事实源的表述一致，链接存在。
6. 仅修改授权三份文件，不修改全局看板、产品文件或外部 Craft。

允许修改的文件范围：
- `README.md`
- `.features/_registry.md`
- `.features/T-DOC-HANDOFF-004/status.md`

禁止事项：
- 不得修改 `AGENTS.md`、`docs/pm/**`、`PROJECT_BOARD.md` 或其他文件。
- 不得删除首轮记录，不得扩大体系范围或引入脚本/依赖。

依赖：T-DOC-QA-004。

### T-DOC-HANDOFF-004 最终裁决

首轮 QA-DOC-004 因 registry 协议不自包含、README 混淆历史看板职责而未通过；原 DOC-Alpha 完成 R1 后，由全新 QA-DOC-004-R1 独立复验通过。当前体系已实现：README 统一入口、状态页里程碑快照、`PROJECT_BOARD.md` 唯一全局任务与 QA 裁决、`.features/{任务ID}/status.md` 独立任务交接记录。状态枚举、必填字段、追加规则、QA/PM 边界、并发互斥与用户复制指令均完整，新 Agent 接手模拟通过。DOC-Alpha 转入待命。

完成态收口已由 QA-DOC-004-CLOSE 只读复核通过：registry 与任务 status 均为 `completed`，首轮、R1、QA 通过及 PM 收口证据保留，本任务无剩余工作。DOC-Alpha 已转入待命。

### T-DOC-HANDOFF-004-CLOSE

任务ID：T-DOC-HANDOFF-004-CLOSE

目标：按已通过 QA 的协议，将交接体系示例从待质检状态正式收口为完成状态。

背景：QA-DOC-004-R1 已通过且无阻断；协议规定 QA 通过后，由 PM 明确下发收口指令，再由原实现 Agent 更新同一任务记录。

验收标准：
1. `.features/T-DOC-HANDOFF-004/status.md` 当前状态更新为 `completed`。
2. 状态记录保留首轮与 R1 历史，追加 QA-DOC-004-R1 通过及 PM 收口指令证据。
3. 下一接手点改为“本任务无剩余工作”，并说明新任务按 registry 新建独立记录。
4. `.features/_registry.md` 中该任务状态同步为 `completed`，最近更新时间保持正确。
5. 只修改两份授权文件，不改协议正文、全局看板或其他项目文件。

允许修改的文件范围：
- `.features/_registry.md`
- `.features/T-DOC-HANDOFF-004/status.md`

禁止事项：
- 不得修改状态枚举、模板字段、README、AGENTS、docs、源码或外部 Craft。
- 不得删除任何历史记录或验证证据。

依赖：T-DOC-QA-004-R1。

### T-DIGIPET-007A

任务ID：T-DIGIPET-007A

目标：建立五阶段共享界面骨架，并先交付“初诺契茧”完整高保真界面稿。

背景：怪兽页基线为 443×980、深墨栖息舱、暖纸信息区与四项底部导航；蛋页主状态为三个承诺点亮 2/3。

验收标准：
1. 交付 443×980 的 stage-00-egg.png，原样使用最终蛋像素素材。
2. 包含身份、承诺 2/3、下一次点亮条件、三阶段孵化轨迹、两条近期回响和无压力说明；不出现抚摸。
3. 关键中文可读、无乱码重叠，正文对比度不低于 4.5:1。
4. 建立 shared-stage-layout.md，明确共享区、阶段可变区、Token、角色安全区、375px 与 200% 大字适配。
5. 更新 DESIGN.md、DESIGN-CHANGELOG.md 与可追踪 meta；不覆盖既有资产。

允许修改的文件范围：docs/DESIGN.md、docs/DESIGN-CHANGELOG.md、docs/assets/visuals/checklist-creature-evolution/ui-integration/**。

禁止事项：不修改 craft-demo；不修改原宠物/蛋资产；不启动 Craft 实现。

依赖：T-DIGIPET-QA-006-R4、已确认“掌上回响站”方向。

### T-DIGIPET-007A-R1

任务ID：T-DIGIPET-007A-R1

目标：修正蛋页蛋体纵向拉长变形的观感，恢复最终蛋资产的自然比例与稳定视觉重心。

验收标准：
1. 新增非覆盖式 443×980 R1 蛋页及 source/meta，旧稿保留。
2. 蛋体等比显示，有效像素包围盒宽高比与源裁切差异不超过 1%，禁止非等比压扁。
3. 调整裁切、容器和浅色光晕，使蛋体相较旧稿更短、更稳，不遮挡蜡封、绿光与缝线。
4. 保留 2/3、下一点亮、孵化轨迹、回响证据及无压力边界。
5. 提供旧版/新版对照图；必要时同步生成非覆盖式 R1 总览。
6. 不修改四张宠物阶段稿、craft-demo 或原始蛋资产。

允许修改的文件范围：DESIGN.md、DESIGN-CHANGELOG.md、ui-integration/stage-00-egg-r1*、ui-integration/stage-overview-r1*。

禁止事项：不覆盖旧稿；不通过非等比缩放解决问题；不扩大到其他阶段。

依赖：T-DIGIPET-QA-007A、用户视觉反馈。

### T-DIGIPET-QA-007A-R1

任务ID：T-DIGIPET-QA-007A-R1

目标：只读复验蛋页纵向拉长观感修正，确认没有通过非等比压扁原素材达成。

验收标准：对照查看旧稿、R1 和比较图；核验 443×980、源/显示宽高比差异不超过 1%、蛋体高度与光晕变化、关键特征、原有业务信息、4.5:1 对比度、来源记录及范围边界。

允许修改的文件范围：无。

禁止事项：不修改任何文件；不直接采信设计 Agent 自测。

依赖：T-DIGIPET-007A-R1。

### T-DIGIPET-007A-R2

任务ID：T-DIGIPET-007A-R2

目标：移除蛋页横向光晕，只保留宠物蛋本体。

验收标准：
1. 新增非覆盖式 443×980 R2 蛋页及 source/meta，R1 与旧稿保留。
2. 主舱中去掉横向/纵向光晕、椭圆观察窗、额外落地影和装饰性背景形状，只显示蛋本体。
3. 蛋本体直接来自最终蛋素材，等比显示，不重画、不变形、不改原始资产。
4. 保留初诺契茧、2/3、下一点亮、三阶段轨迹、两条回响与无压力语义。
5. 中文、对比度、尺寸合格；更新设计基线记录，不修改四阶段稿、总览、craft-demo 或原始资产。

允许修改的文件范围：DESIGN.md、DESIGN-CHANGELOG.md、ui-integration/stage-00-egg-r2*。

禁止事项：不覆盖旧稿；不保留任何横向光晕、观察窗、额外落地影或替代装饰。

依赖：T-DIGIPET-007A-R1、用户视觉反馈。

### T-DIGIPET-CRAFT-008

任务ID：T-DIGIPET-CRAFT-008

目标：将已通过质检的 R2 宠物蛋设计同步为 Craft.js 中可编辑的独立页面。

背景：R2 主舱只保留宠物蛋本体，去除横向光晕、观察窗、额外阴影和装饰；现有 Craft 工作区已有 15 个页面及“回响站·怪兽”旧页面，本任务新增独立“蛋阶段 R2”页面，不覆盖旧页面。

验收标准：
1. 新增稳定 ID 的 443×980 Craft 页面，名称明确体现蛋阶段 R2。
2. 使用现有 Craft 组件化节点和可编辑 Asset 节点，不将整张 443×980 PNG 扁平化为唯一内容。
3. 蛋本体等比显示，主舱无光晕、观察窗、额外阴影、星点、装饰线或替代图形。
4. 保留身份、2/3 承诺进度、下一点亮条件、孵化轨迹、两条回响、无压力说明和底部导航；不加入抚摸互动 CTA。
5. 原有 15 个页面及旧怪兽页可继续切换，内容和尺寸不回归。
6. 通过项目适用的 workspace/model 校验、lint/build，并用真实浏览器确认新页可见、可选中编辑、旧页可切换。

允许修改的文件范围：仅限 `C:\Users\Administrator\Documents\craft-demo\src\data\listMonsterEchoWorkspace.js` 及该 Craft 项目既有资源约定下新增的 R2 蛋本体资源文件；不得修改构建产物或 Flutter 项目。

禁止事项：不覆盖旧页面或原始资产；不新增依赖；不把全页截图作为唯一页面内容；不修改 `tool/craft-echo-preview/assets/*.js`；不越出允许文件范围。

依赖：T-DIGIPET-QA-007A-R2。

### T-DIGIPET-QA-007A-R2

任务ID：T-DIGIPET-QA-007A-R2

目标：只读复验 R2 蛋页是否只保留宠物蛋本体，并确认没有通过拉伸或重画达成。

验收标准：实际查看 R2 与 R1；核对 443×980、无光晕/观察窗/额外阴影/舱内装饰、最终素材来源、等比显示、原有业务信息、中文可读性、4.5:1 对比度、来源追踪和范围边界。

允许修改的文件范围：无。

禁止事项：不修改任何文件；不直接采信设计 Agent 自测。

依赖：T-DIGIPET-007A-R2。

### T-DIGIPET-QA-007A

任务ID：T-DIGIPET-QA-007A

目标：只读独立质检初诺契茧界面稿与五阶段共享骨架。

验收标准：实际查看 443×980 PNG；核对最终蛋素材一致性、2/3 三方格、下一点亮条件、三状态轨迹、两条真实完成证据、无惩罚边界、正文 4.5:1 对比度、共享骨架响应式规则及来源记录一致性。

允许修改的文件范围：无。

禁止事项：不修改任何文件；不直接采信实现 Agent 的自测声明。

依赖：T-DIGIPET-007A。

### T-DIGIPET-007B

任务ID：T-DIGIPET-007B

目标：基于 007A 骨架完成诺卷仔、联页契灵、履契拳师、万策卷贤四张阶段稿与五阶段总览。

背景：蛋页视觉与响应式基线已通过独立质检；四阶段必须直接使用最终像素角色图层，并保持真实任务驱动成长规则。

验收标准：
1. 交付四张 443×980 PNG 及一张五阶段总览 PNG。
2. 对应角色来自最终四形态像素图，只允许无损裁切与放大，不重画、不变形、不混用旧“小单”。
3. 诺卷仔表达初期陪伴；联页契灵表达行动/复盘两路等权；履契拳师表达直接履约；万策卷贤表达规划复盘。
4. 四页均包含阶段身份、真实任务关系、下一变化、近期证据、互动入口与“互动不增加 XP”。
5. 不出现饥饿、货币、惩罚、战斗数值、武器、法力或魔法 CTA。
6. 关键中文可读，普通正文对比度不低于 4.5:1；完成 375px 与 200% 大字风险审计。
7. 每页保存 source SVG、source.md、meta.json，并更新设计事实源。

允许修改的文件范围：docs/DESIGN.md、docs/DESIGN-CHANGELOG.md、docs/assets/visuals/checklist-creature-evolution/ui-integration/**。

禁止事项：不修改 craft-demo；不修改原宠物资产；不把四页做成只换标题的同一模板。

依赖：T-DIGIPET-007A、T-DIGIPET-QA-007A。

### T-DIGIPET-QA-007B

任务ID：T-DIGIPET-QA-007B

目标：只读独立质检四张宠物阶段稿与五阶段总览。

验收标准：逐张查看尺寸与排版；核对最终像素角色一致性、四阶段信息差异、双路等权、任务完成证据、互动不加 XP、无战斗/魔法/惩罚边界、4.5:1 对比度、响应式规则、来源记录和设计事实源映射。

允许修改的文件范围：无。

禁止事项：不修改任何文件；不直接采信设计 Agent 自测。

依赖：T-DIGIPET-007B、T-DIGIPET-QA-007A。

### T-DIGIPET-007

任务ID：T-DIGIPET-007

目标：将最终确认的宠物蛋与契响卷灵四阶段人设融入“掌上回响站”，产出五张独立高保真界面稿和一张总览图。

背景：现有回响站怪兽页仍使用旧“小单”占位；新稿沿用 443×980、深墨栖息舱、暖纸任务区和真实任务驱动成长规则。

验收标准：
1. 交付初诺契茧、诺卷仔、联页契灵、履契拳师、万策卷贤五张 443×980 PNG 和一张总览 PNG。
2. 使用已通过质检的最终像素素材本身，无损裁切/放大，不重画、不变形、不混用旧角色。
3. 蛋页呈现承诺 2/3、下一次点亮条件和三阶段孵化轨迹，不提前露出幼年体。
4. 四个宠物阶段的信息结构分别体现初期陪伴、双向续页、直接履约、规划复盘，不做换标题模板。
5. 每张稿包含阶段身份、真实任务关系、下一步变化或分支、近期回响证据；宠物互动明确不增加 XP，蛋页不出现抚摸。
6. 不新增饥饿、战斗装备、虚构货币、惩罚、羞辱或连续中断扣除。
7. 关键中文可读，无乱码、重叠；完成 375px、200% 大字、4.5:1 对比度与反 AI 模板审计。
8. 更新 DESIGN.md、DESIGN-CHANGELOG.md，并保存非覆盖式设计来源记录。

允许修改的文件范围：
- docs/DESIGN.md
- docs/DESIGN-CHANGELOG.md
- docs/assets/visuals/checklist-creature-evolution/ui-integration/**

禁止事项：不修改 craft-demo；不修改既有最终宠物/蛋素材；不启动 Craft 实现。

依赖：T-DIGIPET-QA-006-R4、T-DIGIPET-005、已确认“掌上回响站”方向。

### T-DIGIPET-004

目标：设计一只由完成清单而成长的原创二维精灵，并形成幼年体与两个完全体分支的统一概念设定及可视化概念图。

背景：

- 幼年体是羊皮纸合同化成的小动物。
- 完全体分为“木乃伊拳击选手”和“书本组成的大学者”两条路线。
- 三形态必须能看出同一血统，并服务于“清单完成推动成长”的产品主题。

验收标准：

1. 给出原创的族系名、三个形态名、属性、性格、成长条件、能力和一句图鉴文案。
2. 明确三形态共享的血统锚点，至少覆盖眼睛、清单符号、封印/装订结构和主色传承。
3. 幼年体保持小动物比例与羊皮纸合同材质，轮廓可爱、可识别，不只是一张长了四肢的纸。
4. 拳击分支呈木乃伊式缠带与拳手体态，体现“行动、执行、连续完成”的成长逻辑；不得使用血腥、恐怖或直接复刻既有 IP 的元素。
5. 学者分支由书本、书页与装订结构构成，体现“规划、积累、长期清单”的成长逻辑；轮廓与拳击分支显著区分。
6. 产出一张横向二维游戏角色概念图：同一画面完整展示幼年体、分支箭头和两个完全体；使用干净浅色设定稿背景，不依赖小字标签表达核心设计。
7. 图像中三个角色不裁切、无额外角色、无水印、无现有动漫或游戏商标；视觉风格适合原创精灵收集养成游戏。
8. 保存最终图片、最终生图提示词、设计说明与生成元数据；逐项自检视觉一致性和进化分支可读性。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\**`

禁止事项：

- 不得修改产品源码、现有设计事实源、PRD、其他视觉资产或 `PROJECT_BOARD.md`。
- 不得直接模仿或点名要求复刻数码宝贝、宝可梦、幻兽帕鲁等现有 IP 的具体角色或画风。
- 不得新增第三方依赖。

依赖：无。

### T-DIGIPET-QA-004

目标：只读独立质检“清单成长精灵”设定与双分支完全体概念图，并输出结构化裁决。

背景：

- T-DIGIPET-004 已生成设定说明、概念图、最终提示词和生成元数据。
- 本轮只核验交付物是否满足任务卡，不进行任何修复。

验收标准：

1. 逐条核验 T-DIGIPET-004 的 8 项验收标准，并为每项给出 `pass` 或 `fail` 及简短证据。
2. 必须实际查看最终 PNG，核验角色数量、完整入镜、幼年小动物轮廓、Y 形分支可读性、两完全体区分和三形态血统锚点。
3. 核验设计说明是否完整包含族系名、三个形态名、属性、性格、成长条件、能力和图鉴文案。
4. 核验图像无水印、商标、额外角色、恐怖血腥表现或明显既有 IP 复刻。
5. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得生成替代图、修复说明或代码。
- 不得以实现 Agent 的自测结论替代独立视觉检查。

依赖：T-DIGIPET-004。

### T-DIGIPET-004-R1

目标：依据用户反馈定向重绘“契响卷灵”概念图，消除幼年体的狐狸感，并强化拳击分支的纸包木乃伊识别。

背景：

- 首版已通过结构性验收，但用户指出幼年体更像小狐狸而非羊皮纸小怪兽。
- 用户希望幼年体更抽象；拳击完全体的头部由纸完整包裹，仅露出绿色眼睛。
- 学者分支、横向双分支构图及核心色彩血统总体保持。

验收标准：

1. 产出非覆盖式 V2 概念图及对应 V2 设计说明、最终提示词和生成元数据。
2. 幼年体不出现狐狸式尖耳、狐狸面罩花纹、明显兽吻、蓬松兽尾或写实犬猫爪；第一眼应识别为由羊皮纸合同、卷边、折痕、缝线和蜡封组成的抽象小怪兽。
3. 幼年体仍保留“小动物般可亲、可活动”的生命感与清晰剪影，但不能只是平面纸张加四肢。
4. 拳击完全体的整个头部由交叠羊皮纸绷带严密包覆，不露口鼻、毛发、兽耳或面部皮肤，只留下两只绿色发光眼睛。
5. 拳击完全体仍具备明确拳击架势和契纸拳套；整体可有木乃伊神秘感，但不血腥、不尸骸化、不惊悚。
6. 学者分支保持由书本、书页和装订结构构成的大学者身份，不因重绘退化成普通穿袍动物。
7. 三形态继续共享羊皮纸材质、绿色勾选光、珊瑚蜡封和靛青缝线；幼年体必须能合理进化为两个分支。
8. 横向画面仅展示三个完整角色与清楚的 Y 形分支关系；无裁切、额外角色、文字标签、水印、商标或既有 IP 标识。
9. 实际查看 V2 后逐项自检；若幼年体仍明显像狐狸，或拳手头部仍露出正常兽脸，必须进行一次针对性迭代再提交。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\**`

禁止事项：

- 不得覆盖或删除 V1 交付物。
- 不得修改产品源码、现有设计事实源、PRD、其他视觉资产或 `PROJECT_BOARD.md`。
- 不得新增第三方依赖。
- 不得直接模仿或复刻现有动漫、游戏 IP。

依赖：T-DIGIPET-QA-004。

### T-DIGIPET-QA-004-R1

目标：只读独立质检 V2 概念图是否准确落实用户提出的去狐狸化与全头纸封要求。

背景：

- T-DIGIPET-004-R1 已产出非覆盖式 V2 图片、设计说明、提示词和元数据。
- 实现 Agent 报告曾发现幼体残留鼻口并完成一次定向迭代，本轮必须独立核验最终文件。

验收标准：

1. 逐条核验 T-DIGIPET-004-R1 的 9 项验收标准，并为每项给出 `pass` 或 `fail` 及简短证据。
2. 必须实际查看 V2 PNG，不得仅依据设计说明或实现 Agent 自测。
3. 幼年体不得仍被一眼识别为狐狸、犬或猫；不得具有尖兽耳、兽吻、面罩花纹、蓬松尾或写实兽爪。
4. 幼年体应首先被识别为羊皮纸合同、卷边、折痕、缝线和蜡封构成的抽象小怪兽，同时保持生命感。
5. 拳手的整个头部必须被纸绷带封住，只露绿色发光双眼；若可见口鼻、兽耳、毛发或正常兽脸则判定失败。
6. 学者分支、三形态血统、Y 形分支、角色数量、完整入镜和无水印等不变量必须保持。
7. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得生成替代图或提出超出用户反馈的新审美要求。
- 不得以实现 Agent 自测替代独立视觉裁决。

依赖：T-DIGIPET-004-R1。

### T-DIGIPET-004-R2

目标：保留 V2 已通过的拳手与学者方向，彻底重构幼年体，使其第一眼成为抽象羊皮纸合同怪兽而非纸质犬猫。

背景：

- V2 的拳手全头纸封、学者结构、血统与分支构图均通过独立质检。
- 唯一阻断项是幼体仍因双侧耳状页瓣、四足宠物姿态和卷尾呈现纸质小狗轮廓。
- 本轮只解决幼体的基础剪影和面部组织，不推翻已通过方向。

验收标准：

1. 产出非覆盖式最终候选图与对应返工提示词、说明和元数据；保留 V1、V2。
2. 幼体不得具有成对耳状结构、四条宠物腿、犬猫爪、卷曲兽尾、突出兽吻、鼻头或对称宠物脸。
3. 幼体的主体必须由卷起的合同、折叠页束、条款分段、缝线和蜡封形成非传统、非犬科的抽象生命轮廓。
4. 幼体仍需可爱且有小动物般的行动感，但生命感应来自纸页开合、卷边弹跳、悬浮或非对称支点，不依赖犬猫解剖。
5. 幼体必须能在不看材质说明时被描述为“合同纸小怪兽”，而不是“小狗、小猫、小狐狸换了纸材质”。
6. 拳手保持 V2 已通过的不变量：全头羊皮纸绷带包覆，仅露绿色发光双眼，拳击姿态清楚。
7. 学者保持 V2 已通过的不变量：由书本、书页、书脊和装订结构组成的大学者，不恢复普通兽脸或宠物轮廓。
8. 三形态继续共享羊皮纸、绿色勾选光、珊瑚蜡封和靛青缝线，并维持清楚的 Y 形双分支关系。
9. 画面仅含三个完整角色，无裁切、额外角色、文字标签、水印、商标或既有 IP 标识。
10. 实际查看最终候选图并以“遮住材质细节只看黑色剪影”的方式自检；若剪影仍能直接读成常见犬猫，则不得提交。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\**`

禁止事项：

- 不得覆盖或删除 V1、V2 交付物。
- 不得修改产品源码、设计事实源、PRD、其他视觉资产或 `PROJECT_BOARD.md`。
- 不得新增第三方依赖。
- 不得改变已经通过质检的拳手全头纸封要求。

依赖：T-DIGIPET-QA-004-R1。

### T-DIGIPET-QA-004-R2

目标：只读独立裁决 V3 是否彻底消除幼体犬猫剪影，并保持已通过的拳手、学者与分支不变量。

背景：

- V2 因幼体仍像纸质小狗而未通过独立质检。
- V3 声称移除成对耳、四足、尾巴、兽吻和宠物脸，并改用悬浮合同卷轴结构。

验收标准：

1. 必须实际查看 V3 PNG，并逐条核验 T-DIGIPET-004-R2 的 10 项验收标准。
2. 单看幼体黑色剪影，不得直接读成狐狸、狗、猫或常见四足宠物。
3. 幼体必须首先表现为由合同卷筒、折页、缝线和蜡封构成的抽象纸生命，同时仍有可爱和行动感。
4. 拳手必须维持全头纸绷带，仅露绿色发光双眼；学者必须维持书本构成的大学者身份。
5. 核验三个角色完整、Y 形关系清楚、无额外角色、标签、水印、商标或既有 IP 标识。
6. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得依据实现 Agent 自测直接放行。
- 不得提出超出本轮用户反馈的新审美要求。

依赖：T-DIGIPET-004-R2。

### T-DIGIPET-004-R3

目标：仅调整 V3 中大学者形态的头部，使其与幼年体、拳手的抽象纸契生命语言一致，其余内容保持不变。

背景：

- 用户确认其余内容保持不变，只要求大学者头部与另外两个形态对齐。
- V3 大学者仍保留明显动物脸、鼻口与耳状轮廓，和幼年体的抽象纸面、拳手的纸封暗面不统一。

验收标准：

1. 以 V3 为编辑目标，产出非覆盖式 V4 图片及对应提示词、说明和元数据；保留 V1-V3。
2. 只改变大学者的头部与连接头部所必需的极小邻接区域。
3. 大学者头部去除动物鼻口、毛发、兽耳、猫犬脸型和普通宠物表情。
4. 新头部必须由书页、书脊、装订线或折叠纸层构成；绿色发光眼从深色页缝或纸层暗面中显现，与幼年体和拳手的生命核心语言对齐。
5. 大学者仍需保持沉静、睿智、友善，不得因无口鼻变成恐怖或邪恶角色。
6. 大学者的页冠、书肩、书袍、胸前清单板、手势、身体比例、位置和整体大学者剪影保持 V3 不变。
7. 幼年体、拳手、Y 形分支箭头、背景、构图、色彩、光效、三个角色的位置与尺寸保持 V3 不变。
8. 三形态头部均应体现“纸层暗面＋绿色发光视觉核心＋装订结构”，但不得把大学者直接复制成拳手的木乃伊包头。
9. 最终画面仍仅含三个完整角色，无裁切、额外角色、文字标签、水印、商标或既有 IP 标识。
10. 实际对照 V3 与 V4 进行不变量自检；若大学者头部之外出现明显重构、角色位移或构图漂移，则必须定向迭代后再提交。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\**`

禁止事项：

- 不得覆盖或删除 V1-V3。
- 不得改动产品源码、设计事实源、PRD、其他视觉资产或 `PROJECT_BOARD.md`。
- 不得改变幼年体、拳手或大学者身体设计。
- 不得新增第三方依赖。

依赖：T-DIGIPET-QA-004-R2。

### T-DIGIPET-QA-004-R3

目标：只读独立裁决 V4 是否只改变大学者头部，并使三形态头部语言对齐。

背景：

- 用户明确要求其余保持不变，只调整大学者头部。
- V4 声称移除大学者动物脸，改为书页装订头壳与绿色页缝眼。

验收标准：

1. 必须实际对照查看 V3 与 V4 PNG，并逐条核验 T-DIGIPET-004-R3 的 10 项标准。
2. 大学者头部不得残留动物鼻口、兽耳、毛发、猫犬脸型或普通宠物表情。
3. 新头部必须清晰由书页、书封、书脊或装订结构组成，绿色眼睛从纸层暗面显现。
4. 三形态应共享纸层暗面、绿色视觉核心和装订结构，同时大学者不能成为拳手包头的复制品。
5. 大学者必须保持沉静、睿智、友善，不出现恐怖或邪恶感。
6. 核验大学者身体、幼年体、拳手、箭头、背景、构图、色彩、光效、位置与尺寸没有明显改变。
7. 核验只有三个完整角色，无裁切、额外角色、标签、水印、商标或既有 IP 标识。
8. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得依据实现 Agent 自测直接放行。
- 不得提出用户未要求的新改动。

依赖：T-DIGIPET-004-R3。

### T-DIGIPET-004-R4

目标：保留 V4 已通过的大学者新头部设计，将其严格局部合成到 V3，确保允许区域之外逐像素不变。

背景：

- V4 的大学者头部设计已通过：无动物脸、书页装订头壳、绿色页缝眼、气质友善。
- V4 未通过的唯一原因是画布从 1693×929 变为 1692×929，且全图存在轻微像素漂移。
- 用户要求“其余保持不变”，因此本轮使用 V3 作为不可变底图。

验收标准：

1. 产出非覆盖式 V5 图片及对应说明、处理记录和元数据；保留 V1-V4。
2. V5 尺寸必须与 V3 完全一致，为 1693×929。
3. V5 以 V3 原图作为底图，只允许修改大学者头部及其必要的窄边缘融合区。
4. 允许修改区之外的每一个像素必须与 V3 完全一致；必须提供机器可复核的差异边界或等价证据。
5. 局部合成后的大学者头部继续满足 V4 已通过方向：无动物鼻口、兽耳、毛发或猫犬脸；由书页、书封、装订线和深色页缝组成，绿色眼睛从暗面显现。
6. 合成边界不得出现硬切边、重影、尺寸错位、断裂页冠或异常色带。
7. 幼年体、拳手、大学者身体、Y 形箭头、背景、构图、位置、尺寸、色彩和光效必须保持 V3 原始像素。
8. 画面仍仅含三个完整角色，无裁切、额外角色、文字标签、水印、商标或既有 IP 标识。
9. 实际查看 V5，并完成 V3/V5 尺寸、像素差异范围和视觉接缝三项自检后再提交。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\**`

禁止事项：

- 不得覆盖或删除 V1-V4。
- 不得再次整图重绘或改变画布尺寸。
- 不得修改产品源码、设计事实源、PRD、其他视觉资产或 `PROJECT_BOARD.md`。
- 不得新增第三方依赖。

依赖：T-DIGIPET-QA-004-R3。

### T-DIGIPET-QA-004-R4

目标：只读独立裁决 V5 的大学者新头部及“其余逐像素不变”要求。

背景：

- V4 头部设计通过，但因整图像素漂移未通过。
- V5 声称以 V3 为底图，仅在 `(1101,517)–(1308,683)` 头部区域合成，区域外差异为 0。

验收标准：

1. 实际查看 V3 与 V5，核验 V5 尺寸为 1693×929。
2. 独立计算 V3/V5 像素差异边界；允许头部区域之外差异必须为 0。
3. 核验大学者新头部无动物脸，由书页装订结构和绿色页缝眼组成，气质沉静友善。
4. 核验局部边缘无硬切、重影、错位、页冠断裂或异常色带。
5. 核验幼年体、拳手、大学者身体、箭头、背景和构图与 V3 保持不变。
6. 核验画面仅有三个完整角色，无裁切、额外角色、标签、水印、商标或既有 IP 标识。
7. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得直接采信实现 Agent 的处理记录，必须独立计算。
- 不得提出用户未要求的新改动。

依赖：T-DIGIPET-004-R4。

### T-DIGIPET-QA-004-R4B

目标：接替未返回裁决的上一质检实例，只读独立裁决 V5 的大学者新头部及“其余逐像素不变”要求。

背景：

- 上一质检实例长时间运行但未产出裁决，已中止。
- V5 声称以 V3 为底图，仅在 `(1101,517)–(1308,683)` 头部区域合成，区域外差异为 0。

验收标准：

1. 实际查看 V3 与 V5，核验 V5 尺寸为 1693×929。
2. 独立计算 V3/V5 像素差异边界；允许头部区域之外差异必须为 0。
3. 核验大学者新头部无动物脸，由书页装订结构和绿色页缝眼组成，气质沉静友善。
4. 核验局部边缘无硬切、重影、错位、页冠断裂或异常色带。
5. 核验幼年体、拳手、大学者身体、箭头、背景和构图与 V3 保持不变。
6. 核验画面仅有三个完整角色，无裁切、额外角色、标签、水印、商标或既有 IP 标识。
7. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得直接采信实现 Agent 的处理记录，必须独立计算。
- 不得提出用户未要求的新改动。

依赖：T-DIGIPET-004-R4。

### T-DIGIPET-005

目标：为“契响卷灵”补充一个分支前的共同成长体，形成“幼年体 → 成长体 → 双分支完全体”的完整进化链。

背景：

- 当前最终基线为 V5：抽象悬浮合同幼体、全头纸封拳手、书页装订大学者。
- 成长体是两个完全体分支共享的过渡阶段，尚未选择行动或规划路线。
- 既有三个形态已经通过独立质检，成长体设计不得推翻其视觉语言。

验收标准：

1. 给出成长体名称、阶段、属性、性格、成长条件、能力、图鉴文案及其在分支选择前的叙事作用。
2. 成长体必须明显继承幼年体的抽象合同卷筒、绿色视觉核心、珊瑚蜡封、靛青装订与条款勾选结构。
3. 成长体在体量、结构复杂度、稳定性和行动能力上明显高于幼年体，但低于两个完全体；不得只是幼年体等比放大。
4. 同时预示两条路线：具备可延展为拳手缠带/拳臂的纸带结构，也具备可展开为学者书页/书脊的层叠装订结构；两类暗示权重均衡，不提前偏科。
5. 成长体不得出现犬猫狐狸等常见宠物脸、兽耳、兽吻、毛发、四足兽骨架或普通人类面孔。
6. 头部语言与现有三形态一致：纸层暗面中出现绿色发光视觉核心，并通过装订结构形成生命感；不得直接复制拳手包头或学者书匣头。
7. 剪影应具备独立识别度，同时能合理解释幼年体的卷页、纸簧如何演化为完全体的直立结构、拳臂与书袍。
8. 产出一张独立成长体概念图，以及一张完整四形态进化图；完整图清楚表达“幼年体 → 成长体 → Y 形双分支”。
9. 完整进化图中的 V5 幼年体、拳手、大学者身份与外观保持，不得恢复旧版动物脸或改变已确认头部设计。
10. 两张图片均无裁切、额外角色、文字标签、水印、商标或既有 IP 标识；背景保持干净浅色概念稿风格。
11. 保存最终图片、设计说明、最终提示词和生成元数据，并实际查看验证阶段递进、分支公平性和血统一致性。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\growth-stage\**`

禁止事项：

- 不得覆盖或删除既有 V1-V5 交付物。
- 不得修改产品源码、设计事实源、PRD、其他视觉资产或 `PROJECT_BOARD.md`。
- 不得新增第三方依赖。
- 不得把成长体设计成第三个完全体分支或直接混合两个完全体的成品装备。

依赖：T-DIGIPET-QA-004-R4B。

### T-DIGIPET-QA-005

目标：只读独立质检成长体“联页契灵”及完整四形态进化图。

背景：

- T-DIGIPET-005 已交付独立成长体概念图、四形态进化图、说明、提示词和元数据。
- 核心裁决点是成长体能否作为幼年体和两个完全体之间的共同过渡，而非第三分支或偏科形态。

验收标准：

1. 逐条核验 T-DIGIPET-005 的 11 项验收标准，并为每项给出 `pass` 或 `fail` 及简短证据。
2. 必须实际查看两张 PNG；核验成长体的独立剪影、结构复杂度和阶段递进。
3. 核验成长体同时具备拳手纸带与学者装订页层的前兆，且视觉权重均衡。
4. 核验成长体无犬猫狐狸特征、四足兽骨架或普通人脸，头部与三个既有形态同族但不直接复制。
5. 核验完整图清楚表达“幼年体 → 成长体 → Y 形双分支”，并保留 V5 三个既有角色的确认身份。
6. 核验两图角色数量、完整入镜、无文字标签、水印、商标、额外角色或既有 IP 标识。
7. 核验设计说明包含名称、属性、性格、成长条件、能力、图鉴文案和叙事作用。
8. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得依据实现 Agent 自测直接放行。
- 不得提出用户未要求的新形态或路线。

依赖：T-DIGIPET-005。

### T-DIGIPET-006

目标：设计一枚可孵化幼年体“诺卷仔”的物种专属宠物蛋，并建立可与其他宠物蛋区分的花纹语法。

背景：

- App 中不同宠物蛋会孵化出不同幼年体，因此玩家应能从蛋的轮廓、材质和纹样预判其所属物种。
- 本任务只设计“契响卷灵”族系的一个宠物蛋，不设计其他物种宠物蛋。
- 宠物蛋应继承幼年体与成长链的羊皮纸、合同条款、勾选、蜡封、缝线和绿色回响元素，但不提前暴露拳手或学者分支。

验收标准：

1. 给出宠物蛋名称、来源、孵化条件、孵化表现和一句图鉴文案。
2. 轮廓保持“蛋/茧”的可读性，但不是普通光滑鸟蛋；应由卷起羊皮纸、折页壳层或装订茧结构形成原创非对称轮廓。
3. 花纹至少整合四种物种锚点：合同条款线、勾选格/勾印、珊瑚蜡封、靛青装订缝线；绿色回响光作为孵化进度提示。
4. 花纹必须服从壳体曲面和结构，不得像随意贴上去的 UI 图标；远看可识别主花纹，近看有纸张纤维、压痕和细条款层次。
5. 不得出现兽耳、眼睛、嘴、四肢或完整角色面孔；宠物蛋不能像把幼年体直接塞进壳里露出来。
6. 不得出现拳套、拳击缠带成品、完整书本、页冠或书袍等分支专属符号；宠物蛋只预示共同幼年血统。
7. 建立可供未来其他宠物蛋复用的花纹编码框架，至少说明“基础材质、主识别纹、封印节点、孵化光路”四层如何随物种变化；本蛋给出对应取值。
8. 设计清楚的孵化变化：未唤醒、回响积累、临近孵化三个状态，变化应由勾选逐项点亮、光路推进或装订张力体现，不使用破坏性惩罚语义。
9. 产出一张宠物蛋多视角概念图，以及一张三状态孵化序列图；两图中的宠物蛋必须为同一设计。
10. 两张图无文字标签、水印、商标、额外宠物、完整幼年体或既有 IP 标识；主体完整入镜，背景为干净浅色概念稿。
11. 保存设计说明、最终提示词和生成元数据，并实际查看验证物种识别、花纹曲面贴合与三状态一致性。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\pet-egg\**`

禁止事项：

- 不得覆盖或删除既有进化链和成长体交付物。
- 不得修改产品源码、设计事实源、PRD、其他视觉资产或 `PROJECT_BOARD.md`。
- 不得新增第三方依赖。
- 不得设计其他物种的宠物蛋或扩展成蛋池 UI。

依赖：T-DIGIPET-QA-005。

### T-DIGIPET-QA-006

目标：只读独立质检“初诺契茧”多视角设计、孵化状态与可扩展花纹系统。

背景：

- T-DIGIPET-006 已交付多视角概念图、三状态孵化图、说明、提示词和元数据。
- 核心裁决点是宠物蛋能否从纹样识别为“契响卷灵”族系，同时保持蛋/茧可读性并避免露出角色面孔。

验收标准：

1. 逐条核验 T-DIGIPET-006 的 11 项验收标准，并为每项给出 `pass` 或 `fail` 及简短证据。
2. 必须实际查看两张 PNG；核验多视角与三状态是否为同一枚宠物蛋。
3. 核验轮廓既像蛋/茧又不是普通光滑鸟蛋，且无眼睛、嘴、兽耳、四肢、面孔或幼年体外露。
4. 核验合同条款、勾选、蜡封、缝线与绿色光路服从壳体曲面，不是 UI 图标贴纸。
5. 核验未唤醒、积累、临近孵化三状态通过光路和勾选推进表达，不依赖碎裂或惩罚语义。
6. 核验没有拳手或学者分支专属符号，图像中无额外角色、文字、水印、商标或既有 IP 标识。
7. 核验设计说明包含名称、来源、孵化条件、孵化表现、图鉴文案及四层花纹编码框架。
8. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得依据实现 Agent 自测直接放行。
- 不得扩展到其他物种蛋或蛋池 UI。

依赖：T-DIGIPET-006。

### T-DIGIPET-006-R1

目标：根据用户反馈，将宠物蛋重构为全物种共用的圆润恐龙蛋标准模板；不同宠物蛋仅使用不同配色。

背景：

- 上一版卷页装订茧虽然符合物种元素，但第一眼不像蛋，被用户否决。
- 用户要求后续所有宠物蛋形状完全一致，只有颜色不同。
- 因此物种差异不得再通过轮廓、结构、接缝、浮雕图标或花纹布局变化表达。

验收标准：

1. 设计一个圆润、饱满、完整闭合、明显类似恐龙蛋的标准外形；顶部与底部均连续圆滑，不得出现卷页冠、纸簧底座、装订凸起或茧形开口。
2. 建立唯一标准轮廓：正面、侧面、三分之四视角必须证明是同一颗旋转对称或近旋转对称的圆润蛋体。
3. 建立固定通用花纹模板，使用圆润有机大斑块与细小斑点；未来所有宠物蛋的花纹形状、数量、尺寸、分布和材质均保持一致。
4. 不得使用合同线、勾选格、蜡封、缝线、书页、拳带等物种专属几何符号；宠物归属只通过颜色映射表达。
5. 当前“契响卷灵”配色固定为：暖象牙底色、靛青主斑、珊瑚副斑、青柠绿微光点；综合色量需平衡，第一眼仍是自然恐龙蛋而非 UI 物件。
6. 蛋壳材质统一为圆润半哑光硬壳，带细微蛋壳孔隙和柔和高光；不得呈羊皮纸、布料、金属、石头或书本材质。
7. 提供全宠物蛋颜色槽规范，至少包含 `base`、`primary_spot`、`secondary_spot`、`hatch_glow` 四个固定槽位；未来只允许替换槽位颜色值。
8. 保留未唤醒、回响积累、临近孵化三个状态，但蛋体、花纹几何和观察角度完全一致，仅改变固定光点/光晕的亮度和颜色强度。
9. 产出一张标准恐龙蛋多视角图，以及一张契响配色三状态孵化图；两张图必须使用同一轮廓、同一花纹模板。
10. 两张图无文字标签、水印、商标、额外宠物、幼年体、裂壳碎片或既有 IP 标识；所有蛋完整入镜，背景干净浅色。
11. 非覆盖式保存新版图片、设计规范、最终提示词与生成元数据；旧版文件完整保留。
12. 实际查看并核验三个硬条件：第一眼像圆润恐龙蛋；多视角外形一致；未来其他宠物蛋可只换色而不改任何几何。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\pet-egg\standard-template\**`

禁止事项：

- 不得覆盖或删除上一版宠物蛋文件。
- 不得修改产品源码、设计事实源、PRD、其他视觉资产或 `PROJECT_BOARD.md`。
- 不得为当前宠物保留任何专属结构或专属花纹几何。
- 不得新增第三方依赖。

依赖：T-DIGIPET-QA-006。

### T-DIGIPET-QA-006-R1

目标：只读独立质检统一圆润恐龙蛋模板，以及“未来仅换色、不改几何”的规则。

背景：

- 用户明确否决卷页纸茧，要求圆润恐龙蛋外形。
- 后续所有宠物蛋必须形状、花纹布局和材质一致，仅颜色不同。

验收标准：

1. 逐条核验 T-DIGIPET-006-R1 的 12 项验收标准，并为每项给出 `pass` 或 `fail` 及简短证据。
2. 必须实际查看两张 PNG；确认第一眼是圆润、完整闭合的恐龙蛋，而非纸茧、容器或 UI 物件。
3. 核验三个视角使用同一标准轮廓，顶部和底部连续圆滑，无卷页、装订、底座或开口。
4. 核验花纹为固定圆润有机斑块与细小斑点，不包含任何物种专属符号或结构。
5. 核验契响配色仅通过暖象牙、靛青、珊瑚、青柠颜色槽表达，蛋壳为半哑光硬壳。
6. 核验三孵化状态的蛋体、观察角度、花纹形状和位置一致，仅光效强度变化。
7. 核验规范明确 `base`、`primary_spot`、`secondary_spot`、`hatch_glow` 四个固定槽位，并禁止未来改变几何。
8. 核验两图无文字标签、水印、商标、额外宠物、幼年体、裂壳碎片或既有 IP 标识。
9. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得依据实现 Agent 自测直接放行。
- 不得提出超出用户反馈的新蛋型或系统。

依赖：T-DIGIPET-006-R1。

### T-DIGIPET-006-R2

目标：保留全物种共用的白色圆润恐龙蛋母型，将上一版传统恐龙蛋斑点替换为直接提炼自幼年体“诺卷仔”的物种专属壳面图案。

背景：

- 用户进一步澄清：统一的是白色、圆润、闭合的恐龙蛋形状，不是传统斑点或固定花纹。
- 每个物种都应在同一白蛋母型上拥有由其幼年体设定提炼的颜色与图案语言。
- 当前物种图案应来自诺卷仔的单眼绿光、勾形符文、珊瑚蜡封、靛青装订和斜向条款带；只能转译为壳面二维图形，不得改变蛋体结构。
- 本轮正式废止 T-DIGIPET-006-R1 中“固定 `SPOTMAP_STD_01`、未来仅换色”的物种区分规则；旧版文件继续保留作为过程记录。

验收标准：

1. 蛋体仍为圆润、饱满、完整闭合、第一眼明显类似恐龙蛋的标准外形；正面、侧面、三分之四视角使用同一白色蛋体母型。
2. 基础蛋壳保持干净白色或极浅暖白色的半哑光硬壳，白色必须在整体视觉中占主导；不得改为羊皮纸、布料、金属、石头或书本材质。
3. 完全移除上一版传统随机大斑块、碎斑点和常规恐龙蛋豹纹式图案，不得以普通圆斑换色冒充物种设计。
4. 当前物种壳面纹样须从幼年体“诺卷仔”提炼：不对称青柠绿回响核椭圆或环形、青柠绿勾形符文、珊瑚色蜡封花章式平面徽记、靛青装订缝线式虚线或环线、斜向细窄合同条带或清单节奏；允许抽象组合，但必须可追溯到幼年体。
5. 所有物种图案均为印刷、彩绘或极浅发光的二维壳面纹样，并随蛋壳曲率产生透视、遮挡和明暗变化；不得出现浮雕、凸起蜡封、真实接缝、开口、纸页层、书本零件、木乃伊绷带或其他结构性附件。
6. 图案构图须不对称、具有幼年体的可爱节奏与识别焦点，但不得组成五官脸谱，不得露出幼年体或让蛋体变成生物头部。
7. 建立新版可复用系统：全物种固定项为白色圆润蛋体几何、白色蛋壳材质、比例、镜头、灯光及孵化状态规则；物种可变项为 `motif_palette`、`primary_motif`、`secondary_motif`、`emissive_motif`，且均须由对应幼年体提炼。
8. 当前“契响卷灵”建议色槽为：白色或极浅暖白蛋壳、靛青 `#283C58`、珊瑚 `#CF6B55`、青柠绿 `#B8D94A`，可少量使用暖纸色 `#E8D8B7` 作为纹样辅助色，但不得让暖纸色成为蛋壳底色。
9. 提供未唤醒、回响积累、临近孵化三个状态；蛋体几何、观察角度及全部图案的位置与形状完全一致，只允许青柠绿发光纹样与周边柔光逐级增强，不出现裂纹或碎片。
10. 产出一张新版多视角图和一张新版三状态孵化图；两张图必须使用同一白蛋母型和同一套诺卷仔专属纹样。
11. 两张图无文字标签、水印、商标、额外宠物、幼年体、裂壳碎片或既有 IP 标识；所有蛋完整入镜，背景干净浅色。
12. 非覆盖式保存新版 PNG、设计规范、最终提示词与生成元数据；必须实际查看并自检三个硬条件：第一眼是白色恐龙蛋、图案能对应幼年体、完全没有传统恐龙蛋斑点感。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\pet-egg\juvenile-motif-template\**`

禁止事项：

- 不得覆盖、删除或修改 `pet-egg\standard-template\**`、`pet-egg\first-promise-contract-cocoon-*.png` 及任何旧版宠物蛋文件。
- 不得修改产品源码、设计事实源、PRD、其他视觉资产或 `PROJECT_BOARD.md`。
- 不得沿用传统随机斑点、固定通用斑块或仅换色的旧规则。
- 不得新增第三方依赖。

依赖：T-DIGIPET-QA-006-R1。

### T-DIGIPET-QA-006-R2

目标：只读独立质检白色圆润恐龙蛋母型，以及由幼年体“诺卷仔”派生的物种专属壳面纹样系统。

背景：

- 用户要求全物种统一白色圆润恐龙蛋形状，但每个物种拥有由其幼年体设定提炼的颜色与图案。
- 上一版固定传统斑点、只换色的规则已被废止。
- T-DIGIPET-006-R2 已交付新版多视角图、三状态孵化图、设计规范、最终提示词和生成元数据。

验收标准：

1. 逐条核验 T-DIGIPET-006-R2 的 12 项验收标准，并为每项给出 `pass` 或 `fail` 及简短证据。
2. 必须实际查看两张 PNG；确认第一眼是白色、圆润、完整闭合的恐龙蛋，白色蛋壳占主导，且无卷页、装订凸起、开口或其他结构附件。
3. 确认不存在传统随机大斑块、碎斑点、豹纹式或普通恐龙蛋斑纹。
4. 确认壳面图案可明确追溯至幼年体元素：偏轴绿色回响核、绿色勾符、珊瑚花章、靛青装订式线段、斜向合同或清单节奏。
5. 确认所有图案均为贴合蛋壳曲率的二维印色或浅发光纹样，具有合理透视与遮挡；不得形成浮雕、真实接缝、纸页、蜡封凸块或书本、绷带部件。
6. 确认不对称构图不会组合成脸谱、生物头部或暴露幼年体。
7. 核验设计规范已将固定项定义为白色蛋体几何、材质、比例、镜头、灯光和状态规则，将物种可变项定义为 `motif_palette`、`primary_motif`、`secondary_motif`、`emissive_motif`。
8. 确认三孵化状态的蛋体、观察角度、所有纹样形状及位置一致，仅青柠绿发光层和周边柔光逐级增强；无裂纹、碎片或形变。
9. 确认两张图无文字标签、水印、商标、额外宠物、幼年体或既有 IP 标识，且新版未覆盖旧版文件。
10. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得依据实现 Agent 自测直接放行。
- 不得恢复传统斑点或“仅换色”的旧规则。
- 不得提出超出当前物种蛋与复用系统的新增设计。

依赖：T-DIGIPET-006-R2。

### T-DIGIPET-006-R3

目标：仅修正三状态孵化图，使三枚蛋严格使用同一蛋体、同一观察角度和同一纹样投影，只保留青柠绿发光强度变化。

背景：

- T-DIGIPET-QA-006-R2 已确认白蛋母型、幼年体派生纹样、材质、配色、多视角图及复用系统均通过。
- 唯一视觉阻断是三状态图中的蛋体宽度、观察角度以及主环、珊瑚花章、靛青短划相对轮廓的位置存在漂移。
- 元数据把三状态一致性标为通过，但实际图像不符，必须在修图后按真实结果更新。

验收标准：

1. 保留已通过的白蛋外形、白色硬壳材质、偏轴绿色回响核、绿色勾符、珊瑚花章、靛青装订式短划及斜向合同条带设计，不改变图案语言。
2. 三状态图中的三枚蛋必须来自同一个固定基础蛋实例；外轮廓、宽高、观察角度、阴影方向、主环、勾符、花章、短划和斜向条带的形状、尺寸及相对位置一致。
3. 未唤醒状态保持现有平面色；回响积累状态只增强既有青柠绿色环、勾符和指定短划的亮度及局部柔光；临近孵化状态在完全相同的像素基底上进一步增强同一发光层。
4. 不得让白色蛋壳、靛青线、珊瑚花章、暖纸色条带、蛋体阴影或背景产生状态间设计变化；不得新增裂纹、碎片、开口、幼体或其他纹样。
5. 使用 imagegen 图像编辑工作流，并将固定基础蛋作为参考；生成后必须实际查看三状态图，优先保证状态一致性而不是重新创作。
6. 多视角 PNG、design-spec.md、final-prompts.txt 保持不变；仅在确有必要时更新三状态 PNG 与 generation-metadata.json。
7. generation-metadata.json 必须更新三状态 PNG 的真实尺寸、字节数和 SHA-256，并仅在实际复核通过后记录几何、角度、纹样投影一致。
8. 交付前放大查看并逐项比较三枚蛋的外轮廓、绿色主环、勾符、花章、靛青短划和斜向条带；不得再次以主观相似替代实际一致。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\pet-egg\juvenile-motif-template\white-dinosaur-egg-juvenile-motif-hatching-states.png`
- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\pet-egg\juvenile-motif-template\generation-metadata.json`

禁止事项：

- 不得修改多视角 PNG、design-spec.md、final-prompts.txt、旧版宠物蛋文件、其他视觉资产、产品源码、PRD 或 `PROJECT_BOARD.md`。
- 不得重构白蛋母型或物种纹样设计。
- 不得通过裁切隐藏纹样，也不得更换图案位置来制造状态差异。
- 不得新增第三方依赖。

依赖：T-DIGIPET-QA-006-R2。

### T-DIGIPET-QA-006-R3

目标：只读独立复验修正后的三状态孵化图，确认三枚蛋使用同一像素基底且仅青柠绿发光层发生变化。

背景：

- T-DIGIPET-QA-006-R2 已通过白蛋母型与幼年体派生纹样设计，但发现三状态视角、宽度和纹样投影漂移。
- T-DIGIPET-006-R3 仅修改三状态 PNG 与生成元数据；多视角图、规范和提示词保持不变。
- 实现 Agent 声明三态来自同一 541×969 基础蛋实例，发光掩膜外差异像素为 0；本轮不得依赖该声明，须独立核验。

验收标准：

1. 逐条核验 T-DIGIPET-006-R3 的 8 项验收标准，并为每项给出 `pass` 或 `fail` 及简短证据。
2. 必须实际查看修正后的三状态 PNG；确认三枚蛋的外轮廓、宽高、观察角度、阴影方向及背景完全一致。
3. 确认绿色主环、勾符、珊瑚花章、靛青短划和斜向条带的形状、尺寸及相对位置完全一致。
4. 确认状态变化仅发生在既有青柠绿色发光区域及其局部柔光；白壳、靛青、珊瑚、暖纸色、阴影和背景无设计变化。
5. 确认没有裂纹、碎片、开口、幼体、新纹样、文字、水印、商标或既有 IP 标识。
6. 只读核验 generation-metadata.json 中修正后 PNG 的尺寸、字节数、SHA-256 和一致性声明与实际文件相符。
7. 确认多视角 PNG、design-spec.md 与 final-prompts.txt 未被本轮修改。
8. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得依据实现 Agent 的像素差声明直接放行。
- 不得重新评价已经在上一轮通过的物种纹样方向，除非发现本轮造成回归。
- 不得扩展到其他宠物蛋或 UI。

依赖：T-DIGIPET-006-R3。

### T-DIGIPET-006-R4

目标：将当前白色恐龙蛋母型进一步锁定为绕竖直轴旋转时外轮廓与画面占比完全不变的轴对称蛋体；旋转只能改变壳面纹样的可见位置与透视。

背景：

- 用户明确要求：蛋不管旋转到哪个角度，大小都不变。
- 当前多视角图中侧面蛋明显更窄，容易被理解为不同尺寸或非标准母型。
- 三状态图已经严格锁定同一蛋体像素基底，本轮不得修改或破坏。
- 正确规则是：蛋体几何为竖直轴旋转体，镜头、缩放、中心点和包围盒固定；不同角度只体现纹样绕壳体旋转。

验收标准：

1. 将标准蛋体定义为绕竖直中心轴的旋转对称几何；任意水平旋转角度下，外轮廓、高度、最大宽度、顶部圆度、底部圆度和画面占比保持不变。
2. 多视角图至少展示正面、侧面、三分之四三个旋转角度；三枚蛋的可见外轮廓必须来自同一固定像素轮廓或同一严格包围盒，宽度与高度误差均不得超过 1 像素。
3. 三枚蛋使用相同正交镜头或等效无透视缩放方案，固定相机距离、焦距、俯仰角、中心点、地面基线和单体占位；不得因三分之四或侧面视角缩小、变窄、后退或下沉。
4. 旋转时只允许壳面纹样改变可见位置、遮挡与横向透视压缩：偏轴绿色回响环、勾符、珊瑚花章、靛青短划和斜向合同条带应像印在同一颗蛋壳上并随表面绕轴移动。
5. 不得让三个角度呈现同一张正面纹样贴图的简单平移复制；侧面和三分之四视角必须能证明纹样在曲面上旋转，但蛋壳轮廓完全不变。
6. 保留已经通过的白色半哑光硬壳、诺卷仔专属纹样、颜色、材质、浅色背景和整体质感；不得恢复传统恐龙蛋斑点，不得改变图案语言。
7. 使用 imagegen `precise-object-edit` 工作流，将现有多视角 PNG 作为编辑目标并先实际查看；优先锁定几何与构图不变量，仅重做旋转展示。
8. 非覆盖式保存新版多视角图为 `white-dinosaur-egg-juvenile-motif-rotation-locked-multiview.png`；旧版多视角图继续保留。
9. 更新 design-spec.md：明确新增 `ROTATION_LOCK_STD_01`，固定旋转轴、正交镜头、像素包围盒和“轮廓不随角度变化”的规则；物种纹样仍是可变层。
10. 更新 final-prompts.txt 与 generation-metadata.json，使其记录实际使用的精确编辑提示词、新版图片尺寸、字节数、SHA-256、三枚蛋的像素包围盒及宽高差。
11. 三状态 PNG 保持字节级不变；不得修改其图像、孵化逻辑或元数据真实性。
12. 新版图无文字标签、水印、商标、额外宠物、幼体、裂纹、碎片或既有 IP；所有蛋完整入镜，边距一致。
13. 交付前必须实际查看并独立测量三枚蛋的轮廓包围盒；第一眼应理解为同一颗等尺寸蛋在原地旋转，而不是三颗胖瘦不同的蛋。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\pet-egg\juvenile-motif-template\white-dinosaur-egg-juvenile-motif-rotation-locked-multiview.png`
- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\pet-egg\juvenile-motif-template\design-spec.md`
- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\pet-egg\juvenile-motif-template\final-prompts.txt`
- `C:\Users\Administrator\Documents\清单怪兽app\docs\assets\visuals\checklist-creature-evolution\pet-egg\juvenile-motif-template\generation-metadata.json`

禁止事项：

- 不得修改或覆盖原版多视角 PNG 与三状态 PNG。
- 不得修改旧版宠物蛋文件、其他视觉资产、产品源码、PRD 或 `PROJECT_BOARD.md`。
- 不得通过把不同角度缩放到相近大小来掩盖非轴对称造型；必须先统一轮廓几何，再旋转纹样。
- 不得新增第三方依赖。

依赖：T-DIGIPET-QA-006-R3。

### T-DIGIPET-QA-006-R4

目标：只读独立质检旋转锁定后的白蛋母型，确认任意展示角度不改变外轮廓、宽高与画面占比。

背景：

- 用户明确要求宠物蛋不管旋转到哪个角度，大小都不变。
- T-DIGIPET-006-R4 新增非覆盖式多视角图，并将白蛋定义为绕竖直轴旋转的轴对称母型。
- 实现 Agent 声明三视图控制框均为 395×639 像素、宽高差 0；不得依据该声明直接放行。
- 上一轮已通过的三状态 PNG 不在本轮修改范围内，必须保持字节与哈希不变。

验收标准：

1. 逐条核验 T-DIGIPET-006-R4 的 13 项验收标准，并为每项给出 `pass` 或 `fail` 及简短证据。
2. 必须实际查看新版多视角 PNG；确认正面、侧面、三分之四三枚蛋的外轮廓、顶部和底部圆度、高度、最大宽度、画面占比及地面基线一致。
3. 独立测量三枚蛋的可见轮廓或固定控制框；宽度与高度误差均不得超过 1 像素，且不得用不同缩放掩盖非轴对称轮廓。
4. 确认三视图的差异来自纹样绕曲面旋转：侧面纹样靠边、受遮挡或横向压缩，三分之四视角处于正面与侧面之间；不得是同一正面贴图的平移复制。
5. 确认白色半哑光硬壳、绿色回响环、勾符、珊瑚花章、靛青短划、斜向合同条带及配色保持，且无传统斑点回归。
6. 核验 design-spec.md 已定义 `ROTATION_LOCK_STD_01`，固定竖直旋转轴、正交镜头、像素包围盒和轮廓不随角度变化规则。
7. 核验 final-prompts.txt 与 generation-metadata.json 已记录精确编辑流程、新版图片尺寸、字节数、SHA-256、三个包围盒及宽高差，且与实际文件一致。
8. 确认旧版多视角 PNG 与三状态 PNG 未被覆盖；三状态 PNG 的字节数和 SHA-256 与上一轮基线一致。
9. 确认新版图无文字标签、水印、商标、额外宠物、幼体、裂纹、碎片或既有 IP；所有蛋完整入镜。
10. 只输出一个 JSON 对象，顶层必须包含 `task_id`、`verdict`、`criteria`、`blocking_issues`；`verdict` 只能为 `pass` 或 `fail`。

允许修改的文件范围：无，只读。

禁止事项：

- 不得修改任何文件。
- 不得依据实现 Agent 的包围盒数据直接放行。
- 不得重新设计蛋或纹样。
- 不得扩展到其他宠物蛋或 UI。

依赖：T-DIGIPET-006-R4。

### T-DIGIPET-003A

目标：把用户确认写入设计事实源，形成可供 Craft 组件化实现的冻结基线。

背景：

- 用户认可“掌上回响站”整体观感，并明确要求用 Craft 重新生成组件化版本。
- 新版本必须覆盖现有 Craft 中全部产品功能和编辑器能力。
- “专注 / 坚持 / 共鸣”不属于当前 PRD，不能作为真实指标落地。
- 旧版 Craft 工作区必须保留；新版本以独立“清单怪兽·回响站”工作区存在。

验收标准：

1. 将设计状态更新为已确认进入 Craft 原型实现，记录用户确认范围。
2. 明确新版本用 PRD 已有的 XP、等级、阶段、连续天数替代三项实验指标；保留历史决策记录，不抹除审计轨迹。
3. 明确新工作区完整覆盖现有 15 个画板：5 个页面、2 个弹层、5 个桌宠状态、3 个 Widget 尺寸。
4. 明确保留全部 Craft 编辑器能力：组件、图层、拖拽、属性、撤销重做、画板管理、视口导航和 AI JSON 导出。
5. 列出 15 个画板应用“掌上回响站”设计体系时的最小视觉映射和不改业务逻辑边界。
6. 本任务不删除、不隐藏、不覆盖任何既有文档、画板、按钮或素材。

允许修改的文件范围：

- `docs/DESIGN.md`
- `docs/DESIGN-CHANGELOG.md`

禁止事项：

- 不得修改 Craft、Flutter、PM 文档或视觉图片。
- 不得删除历史记录，不得新增 PRD 未定义的业务指标。

依赖：T-DIGIPET-001。

### T-DIGIPET-003B

目标：在现有 Craft 工程中新增一套完整、可编辑的“清单怪兽·回响站”工作区。

背景：

- 外部 Craft 工程：`C:\Users\Administrator\Documents\craft-demo`。
- 旧“清单怪兽”工作区与 15 个画板必须原样保留。
- 新版本以 `docs/DESIGN.md` 为设计事实源，视觉稿只用于观感参考。
- 本任务只做 Craft 原型层的组件、布局与静态状态实现，不改变 Flutter 或领域业务逻辑。

验收标准：

1. 新增独立“清单怪兽·回响站”入口，不覆盖“演示”或旧“清单怪兽”入口。
2. 新工作区包含不少于现有 15 个对应画板：今日、长期、怪兽、我的、今日移动端、2 个弹层、5 个桌宠状态、3 个 Widget。
3. 今日与怪兽画板实现宠物主场、暖纸任务台、原创小单和真实 XP / 等级 / 阶段 / 连续天数；不得出现专注、坚持、共鸣三个实验数值。
4. 其余画板使用同一 Token、栖息舱、回响核、排版、颜色和组件语言，全部既有可见功能与状态均有对应表达。
5. 所有画面由 Craft 节点和既有通用物料组成，可在图层树选中、拖拽、编辑属性和导出；不得以整张截图充当不可编辑页面。
6. 保持组件面板、图层、物料拖入、自由拖动、跨容器移动、属性编辑、撤销重做、复制 / 删除画板、滚轮 / 拖动画布、工作区切换和 AI JSON 导出正常。
7. 不删除、改名或减少旧版 15 个画板及其节点；新版本不影响旧工作区加载。
8. 新增真实浏览器回归，验证新入口、画板数量、关键文案、无实验指标、可编辑节点、旧版完整性及控制台 0 error。
9. 构建、Lint、既有专项回归和新增回归全部通过；实现后生成今日、怪兽及至少一个桌宠 / Widget 的真实截图。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\src\data\**`
- `C:\Users\Administrator\Documents\craft-demo\src\components\**`
- `C:\Users\Administrator\Documents\craft-demo\src\utils\**`
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\public\assets\list-monster-echo/**`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`
- `C:\Users\Administrator\Documents\craft-demo\dist\**`（仅构建产物）
- `C:\Users\Administrator\Documents\craft-demo\node_modules\.vite-temp\**`（仅工具运行时产物）
- `C:\Users\Administrator\Documents\craft-demo\output\playwright\list-monster-echo-*.png`

禁止事项：

- 不得修改清单怪兽 Flutter、领域包、PRD、设计文档或旧版输出。
- 不得新增第三方依赖。
- 不得删除、覆盖、改名旧工作区、旧画板、旧按钮或旧素材。
- 不得用整张视觉稿图片替代 Craft 节点。
- 不得新增专注 / 坚持 / 共鸣业务字段或第二套 XP / 能量账本。
- 不得提交或推送。

依赖：T-DIGIPET-003A。

### T-DIGIPET-003C

目标：在两份既有回归文件中追加“清单怪兽·回响站”断言，补齐自动化验证缺口。

背景：

- T-DIGIPET-003B 已新增独立回响站工作区的部分源码。
- 主实现线程两次更新回归文件均被审批器拒绝，产品源码与回归文件现已拆成互斥任务。
- 本任务只允许修改两份既有测试文件，不创建新脚本、不触碰产品源码。

验收标准：

1. 保留全部旧“清单怪兽”静态与浏览器断言，不降低原有覆盖。
2. 静态断言覆盖第三工作区入口、新工作区 15 画板、PRD 指标、无实验指标、旧版 15 画板不变。
3. 浏览器断言覆盖进入“清单怪兽·回响站”、切换关键画板、节点可编辑、导出可用和控制台 0 error。
4. 不依赖位置猜测；使用稳定可见文案、画板标签或既有测试标识。
5. 两份脚本语法检查及对应回归通过。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\scripts\verify-list-monster-workspace.mjs`
- `C:\Users\Administrator\Documents\craft-demo\scripts\list-monster-browser-flow.js`

禁止事项：

- 不得修改任何产品源码、配置、设计文档或输出。
- 不得删除或改写旧断言，不得创建新文件，不得新增依赖。
- 不得提交或推送。

依赖：T-DIGIPET-003B 的部分实现可读。

### T-DIGIPET-003D

目标：在不写入 `.vite-temp` 的前提下完成 Craft 构建，并将 5173 预览切换到新版本。

背景：

- T-DIGIPET-003B 源码、Lint、静态结构校验及旧回归已通过。
- 默认 Vite 构建因配置打包需要写 `.vite-temp` 而被系统拒绝。
- Vite 提供无需该临时配置产物的官方配置加载模式；不得通过修改依赖或配置规避。

验收标准：

1. 使用现有本地 Vite 与官方非临时配置加载模式完成生产构建。
2. 不修改源码、配置、依赖或测试文件。
3. 构建产物包含第三个“清单怪兽·回响站”入口。
4. 安全停止旧 5173 预览后，以隐藏后台服务启动新构建；最终只有一个监听进程。
5. HTTP 返回 200，浏览器可见第三入口和 15 个新画板。
6. 生成今日、怪兽及至少一个桌宠 / Widget 的真实截图。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\dist\**`
- `C:\Users\Administrator\Documents\craft-demo\output\playwright\list-monster-echo-*.png`
- 系统临时目录运行日志

禁止事项：

- 不得修改 `src/**`、`scripts/**`、`package.json`、Vite 配置、依赖或旧输出。
- 不得新增依赖、创建替代构建脚本、删除项目文件。
- 不得留下重复 5173 服务，不得提交或推送。

依赖：T-DIGIPET-003B 源码完成。

### T-DIGIPET-003E

目标：将 Craft 新版本构建到当前项目的独立预览目录，并让 5173 提供这份构建。

背景：

- 外部 `craft-demo/dist` 因权限无法清理，旧构建必须保留。
- 当前项目目录可写，可承载独立、可恢复的新预览构建。
- T-DIGIPET-003C 已补齐回响站静态与浏览器断言。

验收标准：

1. 使用现有 Craft 源码、Vite 官方非临时配置加载模式和独立输出目录完成构建。
2. 输出位于当前项目 `tool/craft-echo-preview/**`，不覆盖旧 Craft dist。
3. 安全停止旧 5173 服务并隐藏启动新预览；最终只保留一个监听进程。
4. HTTP 200，第三工作区入口与 15 个新画板可见。
5. 执行新增浏览器断言并通过，控制台 0 error。
6. 保存今日、怪兽及至少一个桌宠 / Widget 的真实截图到当前项目设计视觉目录。

允许修改的文件范围：

- `tool/craft-echo-preview/**`（构建产物）
- `docs/assets/visuals/2026-07-29-craft-echo-*.png`（真实截图）
- 系统临时目录运行日志

禁止事项：

- 不得修改或删除 Craft 源码、脚本、配置、依赖、旧 dist 或旧输出。
- 不得删除当前项目其他文件，不得留下重复 5173 服务。
- 不得提交或推送。

依赖：T-DIGIPET-003B、T-DIGIPET-003C。

### T-DIGIPET-003F

目标：恢复并稳定保持新版 Craft 预览在 `http://127.0.0.1:5173/` 可访问，供根会话浏览器验收。

背景：
- T-DIGIPET-003E 的独立产物已经生成在 `tool/craft-echo-preview`。
- 子 Agent 结束后 5173 当前无法连接；旧 Craft dist 必须继续保留。
- 根会话将独立完成可视化浏览器验收。

验收标准：
1. 以可持续的后台进程提供 `tool/craft-echo-preview`，监听 `127.0.0.1:5173`。
2. HTTP 请求返回 200，入口 HTML 引用 `index-bt7h69fG.js`。
3. Agent 回报后服务仍持续可访问，不依赖 Agent 会话存活。
4. 不修改任何源代码，不删除或覆盖旧 dist，不删除任何按钮、组件或文件。

允许修改的文件范围：不允许修改文件；仅允许启动或管理 5173 预览进程。

禁止事项：
- 不得删除文件或修改源码。
- 不得占用其他端口。
- 不得停止非本项目进程；若发现 5173 被未知进程占用，先回报。

依赖：T-DIGIPET-003E。

### T-DIGIPET-QA-003

目标：以全新视角独立裁决“清单怪兽·回响站”是否满足组件化、功能完整、PRD 一致和可交付预览要求。

背景：
- 新工作区已作为第三入口加入 Craft，旧“演示”和旧“清单怪兽”工作区保留。
- 实现方报告 15 个画板、209 个 Craft 节点、32 条有效引用，静态回归、Lint 与生产构建通过。
- 新构建由 `tool/craft-echo-preview` 提供，并稳定运行在 `http://127.0.0.1:5173/`。
- 根会话浏览器已观察到第三入口、15 个画板、可编辑属性面板和控制台 0 error；这些仅作为线索，不能替代 QA 自身验证。

验收标准：
1. 只读核验实际变更范围，没有删除、覆盖、改名旧工作区、旧 15 画板、旧按钮、组件、素材或旧 dist。
2. 第三工作区“清单怪兽·回响站”独立存在，恰有 15 个画板：5 Page、2 Overlay、5 Window、3 Widget。
3. 新版所有画面均由 Craft 节点和通用物料组成，可在图层树选中、拖拽、编辑属性和导出；不得以整张截图替代页面。
4. “今日”和“怪兽”使用 PRD 已有的 XP、等级、阶段、连续天数；“专注 / 坚持 / 共鸣”不得作为业务指标出现。
5. 组件、图层、物料拖入、自由拖动、跨容器移动、属性编辑、撤销重做、画板创建/复制/删除、视口导航、工作区切换和 AI JSON 导出均未回归。
6. 旧工作区专项回归、新静态回归、Lint、生产构建通过；可执行时完成浏览器回归，并核对控制台 0 error。
7. 5173 返回新版页面；真实页面观感符合 `docs/DESIGN.md` 的暖纸任务台、宠物主场和回响站设计体系。
8. 若浏览器自动化受环境限制，须以可复核的静态证据和现有实页观察明确区分“通过”“未验证”，不得无依据判 pass。

允许修改的文件范围：无，只读质检。

禁止事项：
- 不得修改、创建或删除任何文件。
- 不得修复实现问题，不得提交或推送。
- 不得把设计视觉稿当成运行时证据。

依赖：T-DIGIPET-003B、T-DIGIPET-003C、T-DIGIPET-003E、T-DIGIPET-003F。

### T-DIGIPET-003B-R1

目标：修复“回响站桌宠 · 提醒”画板中提醒文案与气泡背景同色导致不可见的问题，并建立可复核回归证据。

背景：
- 独立 QA 判定 `echo-reminder-habitat` 的提醒文案与暖纸气泡背景均为 `#fff9ed`，对比度 1:1。
- 根会话真实浏览器截图复核确认气泡呈空白，关键提醒不可读。
- 其余结构、15 画板、Craft 节点、PRD 指标、静态校验与 HTTP 均通过。
- 旧工作区、旧 dist、全部按钮和组件必须继续保留。

验收标准：
1. 提醒气泡中的提醒文案在真实页面清晰可见；前景与背景达到正文可读对比度，且符合回响站深色桌宠窗 + 暖纸气泡视觉体系。
2. 不改变该画板业务文案、尺寸、节点类型和交互语义；不影响其余 14 个新画板或旧 15 画板。
3. 为静态回归补充明确断言：提醒文案存在，且其文字颜色不能等于气泡背景颜色；旧断言全部保留。
4. Lint、新旧静态回归和生产构建全部通过。
5. 重新构建到 `tool/craft-echo-preview` 并稳定刷新 5173；HTTP 200。
6. 生成“回响站桌宠 · 提醒”的真实页面截图，截图必须能看见提醒文案；控制台 0 error。
7. 不删除、覆盖、改名任何旧工作区、旧画板、旧按钮、组件、素材或旧 dist。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\data\listMonsterEchoWorkspace.js`
- `C:\Users\Administrator\Documents\craft-demo\scripts\verify-list-monster-workspace.mjs`
- `tool/craft-echo-preview/**`（仅生产构建产物）
- `docs/assets/visuals/2026-07-29-craft-echo-reminder-r1.png`

禁止事项：
- 不得修改其他源码、脚本、配置、依赖或文档。
- 不得删除任何文件、按钮、组件、画板或旧产物。
- 不得新增第三方依赖，不得提交或推送。

依赖：T-DIGIPET-QA-003。

### T-DIGIPET-003B-R2

目标：让提醒文字修复在已有本地保存数据的真实预览中生效，同时保留旧数据且不清空工作区。

背景：
- R1 已把默认节点文字颜色改为 `#171c26`，静态回归、Lint 和构建通过。
- 根会话真实浏览器复核仍显示空白气泡；目标文本 DOM 存在，但计算样式仍为 `rgb(255, 249, 237)`。
- 原因线索是浏览器继续载入修复前已保存的回响站工作区数据，而非新的默认工厂数据。
- 用户只授权修改回响站数据文件与静态回归文件。

验收标准：
1. 不清空、不覆盖、不删除旧本地工作区数据；通过非破坏性兼容或版本化方式，让真实预览加载到文字颜色已修复的回响站版本。
2. 5173 重新加载后，“A gentle check-in is ready.”在暖纸气泡中肉眼清晰可见，计算文字颜色不再是 `rgb(255, 249, 237)`。
3. 仍保留第三工作区、15 个画板、209 个节点、32 条引用及全部旧工作区；不改变其他文案、尺寸、节点类型或交互语义。
4. 静态回归新增对保存槽/版本兼容的可复核断言，同时保留 R1 颜色与文案断言以及全部旧断言。
5. Lint、新旧静态回归、相关专项回归和生产构建通过。
6. 重建到 `tool/craft-echo-preview`，5173 HTTP 200 且加载新 bundle；不得留下重复服务。
7. 不删除、改名、覆盖任何按钮、组件、画板、素材、旧 dist 或旧保存数据。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\data\listMonsterEchoWorkspace.js`
- `C:\Users\Administrator\Documents\craft-demo\scripts\verify-list-monster-workspace.mjs`
- `tool/craft-echo-preview/**`（仅生产构建产物）

禁止事项：
- 不得修改其他源码、脚本、配置、依赖或文档。
- 不得清空 localStorage 或删除任何文件、按钮、组件、画板、素材、旧产物和旧保存数据。
- 不得新增第三方依赖，不得提交或推送。

依赖：T-DIGIPET-003B-R1。

### T-DIGIPET-QA-003-R2

目标：由全新质检员最终复验回响站组件化工作区及提醒文字兼容修复，给出可交付裁决。

背景：
- 首轮 QA 除提醒气泡文字不可读和独立浏览器未验证外，其余结构、节点、指标、静态校验与 HTTP 均通过。
- R2 已对旧回响站保存数据先归档再精确迁移，真实浏览器确认提醒文字为 `rgb(23, 28, 38)`、肉眼可见、控制台 0 error。
- 新构建运行于 `http://127.0.0.1:5173/`，bundle 为 `index-BlKMgcqU.js`。

验收标准：
1. 第三工作区独立存在，恰有 15 个画板：5 Page、2 Overlay、5 Window、3 Widget；旧工作区与旧 15 画板保持完整。
2. 15 个画板均由可编辑 Craft 节点和通用物料组成；不得使用整张截图替代界面。
3. 今日/怪兽仅使用 XP、等级、阶段、连续天数等 PRD 指标，不出现专注、坚持、共鸣业务指标。
4. 提醒气泡文案在源码、保存数据兼容结果和真实构建中均为深色可读；旧保存数据存在版本化备份，迁移幂等且不清空数据。
5. 组件、图层、物料拖入、节点选择、属性编辑、拖拽、撤销重做、画板管理、视口导航、工作区切换和 AI JSON 导出没有结构性回归。
6. 新旧静态回归、Lint、专项回归、生产构建和 HTTP 均通过；核对 5173 加载 `index-BlKMgcqU.js`。
7. 尽力独立执行浏览器验收；若自身浏览器不可用，可核对根会话的真实页面证据，但必须明确证据来源。阻断缺陷未消除不得判 pass。
8. 没有删除、覆盖、改名旧工作区、画板、按钮、组件、素材、旧 dist 或旧保存数据。

允许修改的文件范围：无，只读质检。

禁止事项：
- 不得修改、创建或删除任何文件。
- 不得修复问题，不得提交或推送。
- 不得把设计视觉稿当作运行时证据。

依赖：T-DIGIPET-003B-R2。

### T-DIGIPET-001

目标：将“清单怪兽”从清单工具附加养成，重构为以原创新时代电子宠物为主角、
清单完成作为培养方式的完整设计方案，并产出可判断的高保真视觉稿。

背景：

- 当前真实界面与 Craft 复现都以白底、薄荷绿卡片和蛋形占位为主，电子宠物成长缺少主场感。
- 产品核心意图是“任务完成 = 投喂 / 训练 / 共鸣”，建立用户成长与宠物进化的双向通道。
- 飞书 PRD 当前需要登录，仓库内 PRD、状态文档、真实截图和 Craft 导出截图作为可用事实源。
- 必须使用原创角色与世界观，不模仿或复刻现有动漫、游戏 IP。

验收标准：

1. 完成 L1 设计审计，形成 5-10 个高影响发现和 3-5 个快速胜利。
2. 产出至少 3 个美学方向，完整说明情绪、关键词、配色、字体、适用场景和风险，并推荐 1 个方向。
3. 建立三层设计 Token、移动端信息架构、今日 / 怪兽页核心布局和任务到进化的交互闭环。
4. 生成 1-3 张高保真移动端视觉稿，至少覆盖“今日主场”和“怪兽 / 进化主场”。
5. 图片、prompt、meta 归档到 `docs/assets/visuals/`，设计文档清楚标记 draft、决策用途和待用户确认项。
6. 删除交互必须包含明确后果、成功通知、5-10 秒撤销入口和恢复区；本任务不得删除任何现有元素。
7. L1 自评达到 B 或以上。

允许修改的文件范围：

- `docs/DESIGN.md`
- `docs/DESIGN-CHANGELOG.md`
- `docs/assets/visuals/**`

禁止事项：

- 不得修改 `PROJECT_BOARD.md`、`docs/pm/**`、`apps/**`、`packages/**` 或外部 Craft 工程。
- 不得新增依赖、编写业务代码、删除或覆盖现有素材。
- 不得使用现有动漫 / 游戏 IP，不得把视觉稿当作 QA 证据。

依赖：无。

### T-DIGIPET-002A

目标：只读确认本次设计最终应优先落到 Craft 复现工程还是 Flutter App，
并形成可执行、互斥的实现文件边界。

背景：

- 用户明确提到 `http://127.0.0.1:5173/` 的 Craft 复现界面，但当前预览未运行。
- Craft 工程位于 `C:\Users\Administrator\Documents\craft-demo`，
  Flutter 产品代码位于 `apps/list_monster_app`。
- 视觉方向尚待确认，本任务仅做侦察，防止过早修改错误目标。

验收标准：

1. 盘点 Craft 的画板数据、视觉组件入口、构建与预览边界。
2. 盘点 Flutter 今日页、怪兽页、全局壳、删除 / 恢复反馈和资产入口。
3. 比较“先改 Craft 再改 Flutter”和“直接改 Flutter”的成本、风险与可验证性，给出推荐顺序。
4. 输出后续互不重叠的实现任务文件范围，并区分纯样式与业务逻辑变更。
5. 标出全部删除入口；任何移除动作必须先上报 PM / 用户，本任务不得删除。

允许修改的文件范围：无。

禁止事项：

- 不得修改、创建或删除任何文件。
- 不得新增依赖、启动长期服务、提交或推送。

依赖：无。

### T-VIS-001

目标：完成清单怪兽现有界面与 Craft 可视化工具组件能力的逐项覆盖审计。

背景：

- 清单怪兽项目：`C:\Users\huawei\Documents\清单怪兽app`
- Craft 工具：`C:\Users\Administrator\Documents\craft-demo`
- 审计必须同时依据源代码、现有截图和编辑器物料面板，不可只凭组件名称判断。

验收标准：

1. 盘点清单怪兽所有页面、弹层、导航、表单、列表、状态反馈和桌面宠物界面元素。
2. 盘点 Craft 工具现有可拖拽组件及其可配置属性。
3. 形成“完全覆盖、部分覆盖、无法覆盖”三级矩阵，并说明判定依据。
4. 对部分覆盖和无法覆盖项给出最小缺失组件清单、优先级和复用建议。
5. 明确在补齐组件前，是否可以开始高保真复现，并给出审计结论。

允许修改的文件范围：

- `docs/pm/craft-list-monster-coverage-audit.md`

禁止事项：

- 不得修改任何 Flutter、React、Craft.js 或样式源码。
- 不得新增依赖。
- 不得开始界面复现。

依赖：无。

### T-VIS-002A

目标：补齐高保真复现所需的视觉原语与公共外观能力。

背景：

- T-VIS-001 判定现有工具无法覆盖怪兽资产、完整文本排版、精确面板外观和按钮变体。
- 本任务只建设通用物料，不开始复现清单怪兽页面。

验收标准：

1. Asset 支持 Icon、SVG、Image、Sprite 四种模式及尺寸、着色、fit、对齐和资源 ID。
2. Text 支持字重、字体、行高、最大行数、溢出和字距。
3. Container、Card 共用可配置 Surface 能力：背景、圆角、各边边框、边框宽度、阴影、内边距、透明度和溢出。
4. Button 支持 filled、outlined、text、icon，前后图标、排版、内边距及 enabled、disabled、selected、loading 状态。
5. 新能力接入物料面板、属性面板、Craft resolver、图层树和 AI JSON 导出，旧画布可继续加载。
6. 构建、Lint、专项验证和真实浏览器验收全部通过。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\src\components\**`
- `C:\Users\Administrator\Documents\craft-demo\src\utils\**`
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：

- 不得修改清单怪兽项目源码。
- 不得新增第三方依赖。
- 不得开始页面复现。
- 不得删除或破坏现有物料、自由拖拽、图层拖拽、撤销重做和导出能力。

依赖：T-VIS-001。

## 风险与决策

- Craft 工具位于另一个目录，第一阶段仅只读审计。
- 清单怪兽包含 Windows 桌面宠物独立窗口，需要与主 App 界面分开评估。
- 是否增补组件、增补范围及复现顺序，以 T-VIS-001 审计结论为准。
- QA-002A-1 未发现具体代码缺陷，但因质检命令无边界等待、独立证据不足而判 fail；
  二次质检必须使用有时限的命令和现成专项脚本。
- QA-002A-2 确认视觉原语与导出链路通过，但 Asset、Text 从物料面板拖入 ROOT 后
  节点数量不增加，判定为阻断问题并退回 FE-Alpha。
- 最终 QA-R2 通过：15 个画板、200 个节点、30 条有效引用；浏览器检查 0 重叠、
  0 越界、0 文本截断、0 控制台错误，只读回归前后项目文件哈希完全一致。
- 实际项目预览运行于 `http://127.0.0.1:5173/`，服务 PID 4276，入口名称“清单怪兽”。
- QA-004 已通过：滚轮、背景拖动、空格拖动和中键拖动均可导航画板；视口导航不修改节点坐标或撤销历史，既有编辑交互正常，控制台 0 error，清单怪兽项目哈希前后一致。

### T-VIS-004

目标：让中心工作区支持拖动画板视口和滚轮浏览超出可视区域的页面。

背景：

- 当前 15 个清单怪兽画板可以编辑，但大画板在中心工作区内无法整体平移或滚动查看。
- 本任务改变的是编辑器视口，不得改变 ROOT 或组件在 Craft 数据中的坐标。

验收标准：

1. 鼠标滚轮可纵向浏览画板，`Shift + 滚轮` 可横向浏览；触控板双轴滚动可用。
2. 从工作区空白背景拖动可双向平移视口；按住空格后从任意非输入区域拖动也可平移。
3. 中键拖动可平移；拖动期间显示明确抓取光标，并避免文本误选。
4. 平移与滚动只改变视口位置，不修改 ROOT/节点坐标，不进入撤销重做历史。
5. 普通组件自由拖动、物料拖入、图层拖拽、表单输入和属性面板滚动不受影响。
6. 视口在边界内稳定停止；切换画板后可查看完整顶部、底部和横向边缘。
7. 增加自包含浏览器回归，覆盖大画板滚轮、双向拖动、组件拖动隔离和切板；
   build、lint、既有回归通过，控制台 0 error、无服务残留。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\src\components\editor\**`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：

- 不得修改清单怪兽 workspace 数据或清单怪兽 App。
- 不得新增第三方依赖。
- 不得通过修改 ROOT 的 X/Y 来伪装视口平移。
- 不得让背景拖动抢占组件拖动或输入控件操作。

依赖：T-VIS-PREVIEW。

### T-VIS-002A-R1

目标：修复从物料面板拖入 Asset、Text 等物料时不创建 Craft 节点的问题。

背景：

- QA-002A-2 验证 Asset、Text 的属性与导出均通过。
- 真实浏览器中拖入 ROOT 后节点数量不变，撤销按钮保持禁用，控制台无错误。

验收标准：

1. Asset 和 Text 拖入 ROOT 空白区域后节点数量各增加 1，撤销按钮变为可用。
2. 物料面板全部入口均能创建正确类型节点，不重复创建。
3. 撤销后新节点消失，重做后恢复。
4. 不破坏画布自由移动、图层栏拖拽、跨容器移动和旧画布加载。
5. 增加可重复的拖入创建回归验证，并完成真实浏览器复测，控制台无错误。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\src\components\Toolbox.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\components\editor\**`
- `C:\Users\Administrator\Documents\craft-demo\src\components\user\**`
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：

- 不得修改清单怪兽项目。
- 不得新增依赖。
- 不得进入 T-VIS-002B 或页面复现。
- 不得绕过 Craft 节点树直接向 DOM 插入静态元素。

依赖：T-VIS-002A、T-VIS-QA-002A-2。

### T-VIS-002A-R2

目标：建立一条可由独立 QA 重复执行、不会因开发服务器而无边界等待的物料拖入浏览器回归入口。

背景：

- FE-Alpha 已人工验证拖入修复。
- QA-002A-R1 的构建、Lint 和专项脚本均通过，但无法稳定启动服务并完成浏览器证据。

验收标准：

1. 提供单一、有限时、可重复执行的浏览器回归命令。
2. 命令自行完成服务启动、健康检查、浏览器拖拽、断言和服务关闭。
3. 覆盖 7 类物料创建、正确节点类型、无重复、撤销和重做。
4. 覆盖自由移动、图层拖拽、跨容器移动的最小回归，并断言控制台 0 error。
5. 任一步失败时非零退出并输出具体失败项，不残留服务进程。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：

- 不得修改业务组件和样式源码。
- 不得新增第三方依赖。
- 不得跳过真实浏览器交互。
- 不得让验证命令长期驻留。

依赖：T-VIS-002A-R1、T-VIS-QA-002A-R1。

### T-VIS-002B

目标：补齐清单怪兽高保真复现所需的表单、选择、导航、列表、进度和反馈控件。

背景：

- T-VIS-002A 已通过独立 QA，视觉原语和物料拖入链路稳定。
- 本任务仍只建设通用组件，不开始复现清单怪兽页面。

验收标准：

1. FormField 支持 text、time、date；label、hint、value、error、前后 Asset；
   normal、focused、error、disabled、readOnly 状态。
2. SelectionControl 支持 checkbox、switch、chip、segmented；标签、副标题、图标；
   on/off、selected 和 disabled 状态。
3. NavigationBar 支持 2-5 项、图标、标签、选中项、指示器样式和目标页面 ID。
4. ListRow 支持 leading、title、subtitle、trailing、密度、分隔线、选中、禁用和展开区。
5. Progress 支持 linear、circular、确定值与不确定态，并可配置厚度、轨道、颜色和圆角。
6. OverlayFeedback 支持 dialog、snackbar、tooltip、reminder bubble，以及遮罩、锚点、
   层级、位置和 visible 状态。
7. 所有组件接入 Toolbox、属性面板、resolver、图层树、AI JSON 和物料浏览器回归；
   build、lint、专项测试和真实浏览器验收通过，控制台 0 error。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\src\components\**`
- `C:\Users\Administrator\Documents\craft-demo\src\utils\**`
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：

- 不得修改清单怪兽项目。
- 不得新增第三方依赖。
- 不得开始多画板模型或页面复现。
- 不得让组件承载清单怪兽业务状态机，只表达可见状态和原型语义。

依赖：T-VIS-002A、T-VIS-QA-002A-R2。

### T-VIS-002C

目标：建立可管理清单怪兽多页面、弹层、桌宠窗口和 Widget 状态的多画板模型。

背景：

- 视觉原语和 13 类物料均已通过独立 QA。
- 当前单 ROOT 模型无法同时表达四个主页面、独立窗口、Widget 尺寸和状态变体。

验收标准：

1. 支持创建、选择、重命名、复制和删除多个画板；至少包含 page、overlay、window、
   widget 四种画板类型，最后一个画板和当前 ROOT 不可误删。
2. 每个画板独立保存名称、类型、平台、宽高、背景色、variant 名称和 Craft 节点树；
   切换画板不丢失未导出的编辑内容。
3. 支持清单怪兽需要的 Desktop、Tablet、Mobile、自定义、Desktop Pet 和 Android
   Widget 尺寸预设，Widget 支持多个尺寸画板。
4. NavigationBar 的目标页面 ID 和 OverlayFeedback 的目标/锚点可以引用画板；
   删除被引用画板时给出明确处理或阻止。
5. AI JSON 可一次导出完整 workspace，包含画板目录、各自节点树、类型、平台、
   variant 和跨画板引用；旧单画板数据能迁移为默认画板。
6. 撤销重做、图层树、属性面板和物料拖入在当前画板内工作，不串改其他画板。
7. 提供自包含浏览器回归入口，覆盖多画板增删改切换、数据隔离、旧数据迁移和完整导出；
   build、lint、专项验证通过，控制台 0 error、无服务残留。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\src\**`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：

- 不得修改清单怪兽项目。
- 不得新增第三方依赖。
- 不得开始清单怪兽页面复现。
- 不得把多个画板伪装成同一 ROOT 下的普通容器。

依赖：T-VIS-002B、T-VIS-QA-002B。

### T-VIS-003

目标：使用已补齐的 Craft 可视化工具，高保真复现清单怪兽当前软件界面。

背景：

- 目标界面依据清单怪兽 Flutter 源码、现有预览截图和桌宠/Widget 实现。
- 复现结果必须保留为 Craft workspace，可继续编辑并导出 AI JSON。
- 本任务不修改清单怪兽 App，只在 craft-demo 中创建可视化设计数据和必要的模板装载入口。

验收标准：

1. 创建四个主页面画板：今日、长期、怪兽、我的；统一复现标题栏、中/EN 分段、
   内容区和四项底部导航，并建立正确页面目标引用。
2. 今日页覆盖怪兽快照、状态 Chip、快速创建、新任务选项、任务列表、正向反馈、
   无压清理、恢复区及提醒时间弹层。
3. 长期页覆盖空态/列表、展开任务、每日拆解、创建编辑弹层、日期字段和选择状态；
   怪兽页覆盖主视觉、等级 XP、状态 Chip 和互动；“我的”覆盖账号、合并、注销和桌宠入口。
4. 创建独立桌宠窗口画板，覆盖正常、提醒、勿扰和加载/空态中的代表状态；
   创建 Android Widget S/M/L 画板，覆盖快照状态、怪兽区、今日进度和反馈。
5. 至少增加一个 390×844 的今日页移动端画板，验证窄屏内容无重叠、无横向截断。
6. 使用新增的 Asset、FormField、SelectionControl、NavigationBar、ListRow、Progress、
   OverlayFeedback 等真实物料，不得用普通矩形和文字假冒关键控件。
7. 提供可一键装载的 List Monster workspace，并保留原空白/演示 workspace 入口；
   完整导出 JSON 中无断引用、无内部类型名泄漏、无空资源 ID。
8. 真实浏览器逐画板截图验收，关键文字、层级、颜色、间距和状态接近当前 App；
   所有画板无元素重叠、越界或不可读文本，控制台 0 error。
9. build、lint、现有组件回归及新增 workspace 完整性验证全部通过，无服务残留。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\src\data\**`
- `C:\Users\Administrator\Documents\craft-demo\src\components\workspace\**`
- `C:\Users\Administrator\Documents\craft-demo\src\components\Topbar.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`
- `C:\Users\Administrator\Documents\craft-demo\output\playwright\list-monster-**`

禁止事项：

- 不得修改清单怪兽项目源码。
- 不得新增第三方依赖。
- 不得修改已经通过 QA 的通用物料 API；若确有阻断，先上报 PM。
- 不得以截图作为画布主体代替可编辑组件。
- 不得虚构尚未存在于当前 App 的功能。

依赖：T-VIS-002C、T-VIS-QA-002C。

### T-VIS-003-R1

目标：修复最终 QA 发现的四项高保真与验收阻断问题。

背景：

- 四主页面、关键控件、workspace 导出和布局断言已经通过。
- QA 发现桌宠四态、Widget S 尺寸、怪兽蛋造型和只读回归入口不符合目标。

验收标准：

1. 桌宠正常态、提醒态、勿扰态严格遵循 `desktop_pet.dart` 的条件显示；
   加载态与无快照空态拆为互斥的两个独立画板。
2. 勿扰态使用夜间图标、低动效外观且不显示提醒气泡；提醒态只显示真实通用提醒气泡，
   不增加目标 App 中不存在的铃铛、标题或文案。
3. Widget S 调整到不小于 Android 声明的 250×160，M/L 保持合法并重新验收布局。
4. 今日、怪兽、移动端和桌宠统一使用接近 `egg_alt_outlined` 的双轮廓蛋形资源。
5. 浏览器回归支持把截图与下载输出定向到系统临时目录；只读 QA 可完整复跑且不修改项目。
6. 更新对应 workspace、完整性断言和截图；无悬空引用、重叠、越界或文本截断。
7. build、lint、全部组件/workspace/浏览器回归通过，控制台 0 error、无服务残留。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\src\data\listMonsterWorkspace.js`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`
- `C:\Users\Administrator\Documents\craft-demo\output\playwright\list-monster-**`

禁止事项：

- 不得修改清单怪兽项目。
- 不得修改通用组件 API、App 壳或其他已通过画板。
- 不得用整张截图替代资源或组件。
- 不得保留与目标状态机冲突的文案或同时展示加载与空态。

依赖：T-VIS-003、T-VIS-QA。

### T-VIS-003-R2

目标：确保所有只读浏览器回归的 Playwright 会话文件也写入系统临时目录。

背景：

- 界面、状态、尺寸、资源、导出和全部功能回归已经通过。
- QA 仅发现 `.playwright-cli` 新增两份会话文件，导致项目哈希变化。

验收标准：

1. Playwright CLI 的工作目录、会话文件、截图和下载全部定向到系统临时目录。
2. 运行只读回归前后 craft-demo 全量文件清单与哈希完全一致。
3. 清理 QA 本轮新增的两份会话文件，不删除任何此前存在的文件。
4. 只读回归仍完整覆盖 15 个画板，控制台 0 error，退出码为 0。
5. 回归结束后无新增服务或浏览器进程残留。

允许修改的文件范围：

- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`
- `C:\Users\Administrator\Documents\craft-demo\.playwright-cli\console-2026-07-27T21-02-52-235Z.log`
- `C:\Users\Administrator\Documents\craft-demo\.playwright-cli\page-2026-07-27T21-02-52-595Z.yml`

禁止事项：

- 不得修改任何界面、workspace 数据或通用组件。
- 不得删除 `.playwright-cli` 中任务卡未明确列出的文件。
- 不得放宽项目零写入断言。

依赖：T-VIS-003-R1、T-VIS-QA-R1。

### T-DIGIPET-OPS-004

目标：恢复并稳定保持“清单怪兽·回响站”新版 Craft 预览在 `http://127.0.0.1:5173/` 可访问。

背景：
- 用户截图显示 `ERR_CONNECTION_REFUSED`，页面无法连接。
- 只读诊断确认 `tool/craft-echo-preview/index.html` 与最新版 `index-BlKMgcqU.js` 均存在，但 5173 没有监听进程。
- 本任务只恢复服务，不改动界面、源码或构建产物。

验收标准：
1. 使用现有 `tool/craft-echo-preview` 启动隐藏、可持续的后台静态预览服务，监听 `127.0.0.1:5173`。
2. 服务在实现 Agent 完成后仍持续存活，不依赖 Agent 会话。
3. HTTP 返回 200，入口 HTML 加载 `assets/index-BlKMgcqU.js`。
4. 最终仅有一个 5173 监听进程，不停止任何无关进程。
5. 不修改、创建或删除任何项目文件，不删除任何按钮、组件、画板、素材或保存数据。

允许修改的文件范围：无；仅允许启动或管理本项目 5173 预览进程。

禁止事项：
- 不得重新构建或修改源码、配置、依赖、预览产物和文档。
- 不得删除任何文件或清理用户数据。
- 若发现 5173 被未知进程占用，先回报 PM，不得强行终止。

依赖：T-DIGIPET-003E、T-DIGIPET-003B-R2。

### T-DIGIPET-QA-OPS-004

目标：独立确认 5173 本地预览恢复结果真实、稳定且未造成文件或数据变更。

背景：
- 实现线程报告 PID 17536 已隐藏后台监听 `127.0.0.1:5173`。
- 根会话只读检查已得到 HTTP 200，HTML 引用最新版 `assets/index-BlKMgcqU.js`。
- 浏览器安全策略阻止根会话代替用户刷新现有错误页，因此质检以服务、HTTP、产物和进程证据为主。

验收标准：
1. `127.0.0.1:5173` 只有一个 LISTENING 进程，且进程命令行指向本项目预览目录。
2. 连续多次 HTTP 请求均返回 200，入口 HTML 引用 `assets/index-BlKMgcqU.js`，该资源也返回 200。
3. 服务在等待后仍持续可用，不依赖实现 Agent 会话。
4. 预览目录文件清单、大小和时间未被本任务修改；没有新增、删除或覆盖项目文件。
5. 未停止无关进程，未删除按钮、组件、画板、素材或保存数据。

允许修改的文件范围：无，只读质检。

禁止事项：不得修改、创建或删除文件；不得重启、停止服务；不得修复问题。

依赖：T-DIGIPET-OPS-004。

### T-VIS-005

目标：保留顶部页面切换按钮切换前的画板视口位置，避免用户浏览到页面下方后被强制跳回起始位置。

背景：
- 用户已确认：滚轮浏览当前页面后，点击顶部页面按钮切换到其他页面，再切回原页面时，原页面视口应恢复到切换前位置。
- 该任务只调整 Craft 可视化预览的视口状态管理，不改变清单怪兽业务数据或节点布局。

验收标准：
1. 页面通过滚轮、Shift+滚轮或已有平移手势移动画板后，切换其他页面再切回，恢复原页面上次视口位置。
2. 不同页面分别保存各自视口位置；未浏览页面使用合理初始位置，不继承其他页面位置。
3. 页面切换、组件拖拽、物料拖入、属性编辑、图层操作和撤销历史保持正常。
4. 视口保存与恢复不修改节点坐标、Craft 序列化数据或页面业务状态。
5. 桌面宽屏、窄窗口和移动尺寸下无越界、跳闪或持续重置。
6. build、lint、既有浏览器回归及新增页面切换视口回归通过。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\components\workspace\**`
- `C:\Users\Administrator\Documents\craft-demo\src\components\editor\**`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`
- `C:\Users\Administrator\Documents\craft-demo\output\playwright\list-monster-**`

禁止事项：
- 不得修改清单怪兽原始 Flutter 项目。
- 不得新增第三方依赖。
- 不得修改与本需求无关的已通过通用组件 API。

依赖：T-VIS-004。

### T-VIS-005-R1

目标：修复独立 QA 发现的页面快速切换丢失画板视口位置问题，并隔离回归脚本中的宽泛标签选择器。

背景：
- QA-005 真实浏览器确认页面 A 从 `top=420` 切换后回到 `top=0`，核心恢复失败。
- QA 同时发现回响站标签选择器匹配多个标签，导致相关回归提前中止；实现 Agent 需按画板 ID 隔离选择器。

验收标准：
1. 页面 A/B 视口位置同步保存并恢复，快速切换也不丢失位置。
2. 未浏览页面不继承其他页面位置；桌面与移动尺寸均无越界或持续重置。
3. 既有滚轮、Shift 滚轮、背景拖动、Space 拖动和中键拖动，以及编辑/历史能力无回归。
4. 节点坐标、Craft 数据和撤销历史不因视口切换改变。
5. lint、build、`T_VIS_004_PASS`、`T_VIS_003_R1_PASS` 和页面切换回归通过，标签选择器按画板 ID 隔离。
6. 临时测试进程清理完成，不停止现有 5173 预览服务。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\components\editor\CanvasViewport.jsx`
- `C:\Users\Administrator\Documents\craft-demo\scripts\viewport-browser-flow.js`
- `C:\Users\Administrator\Documents\craft-demo\scripts\list-monster-browser-flow.js`

禁止事项：
- 不得修改清单怪兽原始 Flutter 项目。
- 不得新增第三方依赖。
- 不得停止现有 5173 预览服务或删除无关文件。

依赖：T-VIS-QA-005。

### T-VIS-005-R2

目标：修复移动尺寸下页面切换导致横向画板视口丢失的问题。

背景：
- QA-005-R1 在 390×844 真实浏览器中复现 A 页横向 `left=117` 切换后回到 `left=0`，0/10/50/100ms 均失败。
- 桌面位置、既有手势、编辑能力和数据不变量已通过，本轮聚焦移动端容器尺寸稳定后的恢复时机。

验收标准：
1. 390×844 下 0/10/50/100ms 快速切换均恢复 A/B 独立横向位置。
2. 桌面、窄窗口和移动尺寸无越界、跳闪或持续重置。
3. 滚轮、Shift 滚轮、双轴滚轮及三种平移手势通过。
4. 节点、Craft 数据、业务状态、撤销历史和编辑操作无回归。
5. lint、build、`T_VIS_004_PASS`、`T_VIS_003_R1_PASS`、移动专项回归通过，consoleErrors=0。
6. 只读回归写入为 0，临时测试资源清理，现有 5173 服务保持可访问。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\components\editor\CanvasViewport.jsx`
- `C:\Users\Administrator\Documents\craft-demo\scripts\mobile-viewport-browser-flow.js`
- `C:\Users\Administrator\Documents\craft-demo\scripts\viewport-browser-flow.js`
- `C:\Users\Administrator\Documents\craft-demo\scripts\list-monster-browser-flow.js`
- `C:\Users\Administrator\Documents\craft-demo\package.json`

禁止事项：
- 不得修改清单怪兽原始 Flutter 项目。
- 不得新增依赖、停止现有 5173 服务或删除无关文件。

依赖：T-VIS-QA-005-R1。

### T-VIS-QA-005-R2

目标：独立复验移动端及快速切换时页面视口恢复。

验收标准：
1. 真实浏览器在 390×844 下验证 0/10/50/100ms 快速切换的 A/B 非零横向位置恢复。
2. 验证桌面、窄窗口、未浏览页面和既有导航/编辑回归。
3. 验证节点、Craft 数据、业务状态、撤销历史及 console errors。
4. 验证只读哈希、临时进程清理和现有 5173 服务可访问。
5. 返回结构化 JSON 裁决，不修改项目。

允许修改的文件范围：无，只读质检。

禁止事项：
- 不得修改、创建或删除项目文件。
- 不得修复问题或停止现有 5173 服务。

依赖：T-VIS-005-R2。

### T-VIS-005-R3

目标：让用户实际打开的 `127.0.0.1:5173` 预览真正使用页面视口记忆修复，并解决移动端页面标签被画板类型控件遮挡的问题。

背景：
- QA-005-R2 在真实 5173 预览中仍观察到桌面 A/B 切回后 `top=0`，说明新实现可能未进入用户正在访问的服务，或恢复逻辑仍有实际挂载时序问题。
- 390×844 下页面标签被新画板类型下拉框遮挡，B 无法通过真实 UI 点击切换。
- build/Playwright 曾受临时目录写入 EPERM 阻断，需区分实际服务构建与只读验证环境，不得把临时测试服务当成 5173 预览。

验收标准：
1. 确认 `http://127.0.0.1:5173/` 返回的实际资源包含本轮视口修复，并在该地址真实验证桌面 A/B 切换恢复非零位置。
2. 在 390×844 下页面标签可点击且不被画板类型下拉框遮挡；A/B 0/10/50/100ms 快速切换均恢复独立横向位置。
3. 保持滚轮、Shift 滚轮、双轴滚轮、空白拖动、Space 拖动、中键拖动和编辑操作正常。
4. 节点、Craft 数据、业务状态、撤销历史和 console errors 无回归。
5. 使用可写的系统临时目录完成 build/Playwright 回归；临时资源和进程可清理，现有 5173 服务保持唯一且可访问。
6. 最终报告明确 5173 服务的资源版本/入口证据与测试服务的区别。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\components\editor\CanvasViewport.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\components\workspace\**`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：
- 不得修改清单怪兽原始 Flutter 项目。
- 不得新增依赖。
- 不得停止或覆盖未知的 5173 进程；先确认命令行指向本项目，再按需要更新同一预览服务。
- 不得删除无关项目文件或用户数据。

依赖：T-VIS-QA-005-R2。

### T-VIS-005-R3-R1

目标：将用户当前访问的 5173 预览对齐到最新 Craft 项目，并完成最终页面视口恢复验证准备。

背景：
- 实现 Agent 已确认 5173 返回旧资源 `index-BlKMgcqU.js`。
- 当前 PID 17536 的命令行指向已不存在的 `tool\craft-echo-preview`，已确认不是当前 Craft 项目有效服务。
- 最新临时构建资源为 `index-CTOWhvNz.js`，移动端标签遮挡已在临时真实回归中修复。

验收标准：
1. 仅停止或替换已确认指向失效旧路径的 5173 进程，不触碰其他监听进程。
2. 重新启动当前 Craft 项目预览于 `127.0.0.1:5173`，入口与资源返回 200，资源为最新构建版本。
3. 在真实 5173 上验证桌面 A/B 视口切换恢复，以及 390×844 标签无遮挡和 0/10/50/100ms 快速切换恢复。
4. 保留全部滚轮/拖动手势、编辑能力、数据与历史不变量，console errors 为 0。
5. 5173 最终只有一个指向当前项目的监听服务；测试临时服务和浏览器资源清理完成。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`
- 允许管理已确认失效的旧 5173 预览进程及当前项目预览进程；不得停止无关进程。

禁止事项：
- 不得修改清单怪兽原始 Flutter 项目。
- 不得新增依赖。
- 不得停止未知或无关进程，不得删除用户文件。

依赖：T-VIS-005-R3。

### T-VIS-QA-005-R3

目标：最终验收用户实际访问的 5173 预览是否使用最新资源，并确认桌面与移动端页面视口恢复。

验收标准：
1. 确认 5173 唯一监听进程指向当前 Craft 项目，入口及最新资源返回 200。
2. 真实桌面 A/B 非零视口切换恢复；390×844 页面标签无遮挡，0/10/50/100ms 快速切换恢复 A/B 独立横向位置。
3. 滚轮、Shift 滚轮、双轴滚轮、背景拖动、Space 拖动、中键拖动和编辑操作正常。
4. 节点、Craft 数据、业务状态、撤销历史不变，console errors 为 0。
5. build、lint、既有视口与 workspace 回归通过；临时测试资源清理，不停止当前 5173。
6. 只读质检并返回结构化 JSON 裁决。

允许修改的文件范围：无，只读质检。

禁止事项：
- 不得修改、创建或删除项目文件。
- 不得修复问题或停止当前 5173 服务。

依赖：T-VIS-005-R3-R1。

### T-VIS-005-R4

目标：修复实际 5173 预览中的画布拖动回归，并补齐最终构建、状态与文件完整性证据。

背景：
- QA-005-R3 已确认 5173 新资源、桌面/移动页面切换恢复、滚轮行为和页面标签均通过。
- 但空白背景拖动、Space+左键拖动、中键拖动在实际 5173 未产生视口变化；Craft 数据仅间接验证，完整 build/lint/哈希证据未补齐。
- 工作区仍显示旧入口字符串属于静态产物一致性风险，需要说明或修正，不得影响实际 5173 加载的新资源。

验收标准：
1. 在实际 5173 上空白背景拖动、Space+左键拖动和中键拖动均产生双向视口变化，且不改变节点坐标或历史。
2. 页面 A/B 桌面及 390×844 快速切换恢复保持通过，滚轮/Shift/双轴滚轮保持通过。
3. 直接比对 Craft 序列化数据、节点坐标、撤销历史、业务状态，编辑操作无回归，consoleErrors=0。
4. 完成 build、lint、`T_VIS_004_PASS`、`T_VIS_003_R1_PASS` 和相关 workspace 回归。
5. 给出项目文件清单与 SHA-256 前后证据；只读回归写入为 0，临时资源可清理；5173 保持唯一可访问。
6. 解释旧入口字符串与实际 `index-CTOWhvNz.js` 的关系；如需修改仅限允许范围内的构建/文档脚本，不破坏当前服务。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\components\editor\CanvasViewport.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：
- 不得修改清单怪兽原始 Flutter 项目。
- 不得新增依赖。
- 不得停止当前有效 5173 服务，除非先确认需要无损重启且仍保持唯一当前项目监听。
- 不得删除用户文件或无关产物。

依赖：T-VIS-QA-005-R3。

### T-VIS-QA-005-R4

目标：最终独立验收实际 5173 视口导航、页面位置记忆、拖动手势及完整回归。

验收标准：
1. 5173 唯一监听指向当前 Craft 项目，入口与最新 `index-C7rrYG31.js` 返回 200。
2. 桌面 A/B 和 390×844 A/B 页面切换位置独立恢复，0/10/50/100ms 快速切换通过，标签无遮挡。
3. 普通/Shift/双轴滚轮、空白背景拖动、Space+左键拖动、中键拖动均真实产生视口变化。
4. 节点坐标、Craft 序列化数据、业务状态、撤销历史、编辑能力保持不变，consoleErrors=0。
5. build、lint、`T_VIS_004_PASS`、`T_VIS_003_R1_PASS`、workspace 和专项回归通过。
6. 只读写入为 0，项目哈希/关键文件证据前后一致，临时资源清理，5173 不停止。
7. 返回结构化 JSON 裁决，不修改项目。

允许修改的文件范围：无，只读质检。

禁止事项：
- 不得修改、创建或删除项目文件。
- 不得修复问题或停止当前 5173 服务。

依赖：T-VIS-005-R4。

### T-VIS-005 最终裁决

最终独立 QA 已通过：实际 5173 资源、桌面与移动页面位置记忆、滚轮与三类拖动均正常；项目文件 696→696、SHA-256 前后一致、projectWrites=0，节点/坐标/业务文本/撤销历史前后保持一致，consoleErrors=0。原始 Craft JSON Blob 受浏览器下载 API 限制未做字节级直比对，已用导出成功状态与结构化业务快照替代。

### T-VIS-006

目标：保持顶部页面切换栏自身的横向滚动位置，点击其他页面按钮时不再瞬移回第一个按钮。

背景：
- 用户确认问题发生在顶部切换栏整体，不是每个页面的画板滚动位置。
- 顶部切换栏横向滚动到后面的按钮后，点击其他页面按钮会回到最左侧；期望是切换页面只更新当前页面，顶部栏保持原有横向位置，并作为全局共享状态保存。

验收标准：
1. 真实浏览器中顶部栏滚动到后面的按钮后，点击可见其他按钮，切换前后 scrollLeft 保持，不回到 0。
2. 不同位置按钮和连续快速切换后，顶部栏继续保持最近一次横向位置，不按页面分别重置。
3. 每页面画板视口恢复、页面内容和顶部栏位置互不覆盖，均保持正常。
4. 新增、复制、删除、页面类型下拉、窄窗口/390×844 标签布局保持可用且无遮挡。
5. 节点坐标、Craft 数据、业务状态、撤销历史不因切换按钮改变，consoleErrors=0。
6. build、lint、顶部栏/页面切换浏览器回归通过，并有 scrollLeft 前后断言。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\components\Topbar.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\components\workspace\**`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：
- 不得修改清单怪兽原始 Flutter 项目。
- 不得新增第三方依赖。
- 不得修改与顶部切换栏无关的已通过业务模型。
- 不得把顶部栏位置写入页面业务数据或节点数据。
- 不得破坏当前 `http://127.0.0.1:5173/` 预览服务。

依赖：T-VIS-005。

### T-VIS-006-R1

目标：修复页面切换时顶部工具栏“含 Craft 数据”复选状态丢失，同时保持顶部栏横向位置修复。

背景：
- QA-006 已确认桌面/390×844 顶部栏 scrollLeft 保持、画板视口恢复和顶部控制正常。
- QA 发现勾选“含 Craft 数据”后切换页面，返回检查时复选状态变为未勾选，业务状态未保持。

验收标准：
1. 勾选“含 Craft 数据”后切换多个页面，复选状态保持；取消勾选后切换页面，仍保持取消状态。
2. 顶部栏桌面和 390×844 横向位置继续保持，不回到第一个按钮。
3. 页面画板视口恢复、顶部新增/复制/删除/类型下拉正常。
4. 节点、Craft 数据、业务状态和撤销历史不因切换改变，consoleErrors=0。
5. build、lint、顶部栏和 workspace 回归通过，并补充复选状态跨页面切换断言。

允许修改的文件范围：
- `C:\Users\Administrator\Documents\craft-demo\src\App.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\components\workspace\BoardManager.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\components\Topbar.jsx`
- `C:\Users\Administrator\Documents\craft-demo\src\index.css`
- `C:\Users\Administrator\Documents\craft-demo\scripts\**`
- `C:\Users\Administrator\Documents\craft-demo\package.json`
- `C:\Users\Administrator\Documents\craft-demo\docs\QA.md`

禁止事项：
- 不得修改清单怪兽原始 Flutter 项目。
- 不得新增第三方依赖。
- 不得回退顶部栏 scrollLeft 保持修复。
- 不得把 UI 复选状态写入节点数据或 Craft 业务数据。

依赖：T-VIS-QA-006。

### T-VIS-QA-006-R1

目标：独立复验顶部栏横向位置和“含 Craft 数据”状态跨页面切换保持。

验收标准：
1. 真实 5173 桌面与 390×844 中顶部栏滚到后面后，连续切换页面，scrollLeft 保持。
2. 勾选/取消“含 Craft 数据”后切换多个页面，状态分别保持。
3. 页面画板视口恢复、顶部新增/复制/删除/类型下拉和 workspace CRUD 正常。
4. 节点、Craft 数据、业务状态、撤销历史无回归，consoleErrors=0。
5. build、lint、顶部栏和页面切换回归通过；返回结构化 JSON 裁决，不修改项目。

允许修改的文件范围：无，只读质检。

禁止事项：
- 不得修改、创建或删除项目文件。
- 不得修复问题或停止当前 5173 服务。

依赖：T-VIS-006-R1。

### T-VIS-006 最终裁决

独立 QA-006-R1 已通过：桌面与 390×844 顶部栏横向位置跨页面保持，“含 Craft 数据”勾选/取消状态跨 4 个页面保持，画板视口、顶部 CRUD、workspace、build/lint 均正常，consoleErrors=0。不可见左侧标签被点击时浏览器自动将目标滚入可视区域属于正常浏览器行为。

### T-VIS-QA-006

目标：独立验收顶部页面切换栏整体横向滚动位置保持。

验收标准：
1. 在真实 `http://127.0.0.1:5173/` 中将顶部切换栏滚动到后面的按钮，点击其他页面按钮，切换前后顶部栏 scrollLeft 保持，不回到 0。
2. 连续切换多个页面后顶部栏仍保持最近一次全局位置，不按页面分别重置。
3. 画板每页面视口恢复与顶部栏位置互不影响；桌面和 390×844 窄窗口均可用，标签不遮挡。
4. 新增、复制、删除、页面类型下拉等顶部栏控制正常；节点、Craft 数据、业务状态、撤销历史和 consoleErrors 无回归。
5. 运行现有顶部栏、页面切换和 workspace 回归，返回结构化 JSON 裁决；只读不修改项目。

允许修改的文件范围：无，只读质检。

禁止事项：
- 不得修改、创建或删除项目文件。
- 不得修复问题或停止当前 5173 服务。

依赖：T-VIS-006。

### T-CRAFT-SAVE-001

任务ID：T-CRAFT-SAVE-001

目标：为 Craft 编辑器增加显式“保存当前版本”闭环，把用户当前可见工作区保存为 Agent 可读取的固定项目文件，并在刷新时恢复该存档。

背景：用户明确不要实时自动保存、版本合并或复杂冲突系统。现有手动编辑主要停留在 Craft 内部状态，浏览器 localStorage 也不是 Agent 可稳定读取的项目事实源。本任务采用固定项目存档：用户点击保存后，Agent 以该文件为修改基线。

验收标准：
1. 顶部新增“保存当前版本”，沿用现有样式；保存中防重复提交。
2. 点击时保存当前 Craft 最新节点及活动工作区全部画板，而非旧 React 快照。
3. 固定写入 `C:/Users/Administrator/Documents/craft-demo/.craft-saves/current-workspace.json`，包含 schema、时间、工作区与当前画板信息；禁止任意路径写入。
4. 仅显式点击写项目存档；编辑、拖动、等待、刷新均不得自动写该文件。
5. 保存成功显示时间；再次修改显示“有未保存改动”；失败有可见提示且不破坏编辑状态。
6. 刷新优先恢复合法项目存档；缺失或无效时安全回退，不覆盖坏文件或现有数据。
7. Agent 修改合法存档后，用户刷新即可看到结果。
8. `craft-demo/AGENTS.md` 固化 Agent 开工前读取存档、记录 savedAt/工作区/画板、禁止无授权清空及保留未涉及节点的规则。
9. 不做实时自动保存、多版本、自动合并、远端服务或新增依赖；画布 App 设计和现有工作区 CRUD 不回归。
10. 自动验证覆盖显式保存、未保存文件不变、刷新恢复、外部文件更新、自建/内置工作区、异常回退和既有回归。
11. lint、build、workspace model、workspace browser 和新增验证全部通过；浏览器控制台零错误并产出真实截图。
12. 实现 Agent 完整维护 `.features/T-CRAFT-SAVE-001/status.md`，自测后标记 `ready_for_qa`。

允许修改的文件范围：
- `C:/Users/Administrator/Documents/craft-demo/vite.config.js`
- `C:/Users/Administrator/Documents/craft-demo/package.json`
- `C:/Users/Administrator/Documents/craft-demo/src/App.jsx`
- `C:/Users/Administrator/Documents/craft-demo/src/components/Topbar.jsx`
- `C:/Users/Administrator/Documents/craft-demo/src/components/workspace/{WorkspaceProvider.jsx,useWorkspace.js}`
- `C:/Users/Administrator/Documents/craft-demo/src/utils/workspaceSave.js`
- `C:/Users/Administrator/Documents/craft-demo/src/index.css`
- `C:/Users/Administrator/Documents/craft-demo/scripts/{craft-save-plugin.mjs,verify-workspace-save.mjs,workspace-save-browser-flow.js}`
- `C:/Users/Administrator/Documents/craft-demo/output/playwright/T-CRAFT-SAVE-001/**`
- `C:/Users/Administrator/Documents/craft-demo/.craft-saves/**`
- `C:/Users/Administrator/Documents/craft-demo/AGENTS.md`
- `.features/T-CRAFT-SAVE-001/status.md`
- `.features/_registry.md`

任务记录：`.features/T-CRAFT-SAVE-001/status.md`

禁止事项：不修改 `src/data/**`、`public/**`、既有工作区验证脚本、`package-lock.json`、其他任务记录；不新增依赖、不初始化 Git、不自动写项目存档；测试不得覆盖已有用户存档。

依赖：T-CRAFT-WS-CRUD-001（QA-CRAFT-WS-CRUD-004 已通过）。

### BF-0810-1

任务ID：BF-0810-1

目标：修复用户点击“保存当前版本”成功后，顶部“已保存时间”必须在本次点击完成时立即更新，无需手动刷新页面。

背景：用户截图显示顶部仍为“已保存08:33:47”；对应项目存档基线为 `savedAt=2026-08-10T00:33:47.026Z`、工作区“清单怪兽·回响站”、当前画板 `lme-page-today`。当前现象是再次点击保存后文件已更新，但界面时间只有刷新重新读取存档后才更新。`craft-demo` 无 Git，不能创建 forge-bugfix worktree；本任务沿用既有互斥文件范围、RED/GREEN、独立 QA 与截图证据替代，不初始化 Git。

验收标准：
1. 先在隔离测试存档中稳定复现：点击保存后磁盘 `savedAt` 已变化，但同一页面的显示时间未变化；记录 RED 证据与根因，确认后再修改。
2. 保存成功响应成为当前显示时间的事实源；单次点击完成后，同一页面立即显示本次新的本地时间，不依赖刷新、轮询或第二次点击。
3. 时间显示与实际落盘 `savedAt` 一致；连续两次保存分别即时更新，不能沿用旧闭包或启动水合时间。
4. 保存中、保存失败、未保存改动和初始水合行为保持：失败不得显示伪造的新成功时间，后续编辑仍显示“有未保存改动”。
5. 不引入实时自动保存、定时器或刷新；不改变顶部样式、工作区 CRUD、画布节点及项目存档格式。
6. 测试只使用证据沙箱，运行前后真实 `.craft-saves/current-workspace.json` 的字节与时间戳完全不变。
7. lint、临时目录 build、`verify:workspace-model`、`verify:workspace-browser`、`verify:workspace-save`、`verify:workspace-save-browser` 及新增即时更新时间断言全部通过，console error=0；提供点击前、点击后截图。
8. 创建并维护 `docs/bugfix/reviews/BF-0810-1.md`，包含用户原话、基线、复现、5 Whys、RED/GREEN、配置/数据就绪、QA 证据占位、至少三条人工验收指南；实现阶段维护 `.features/BF-0810-1/status.md` 至 `ready_for_qa`。

允许修改的文件范围（诊断阶段只允许测试、报告、证据和任务记录；源文件须 PM 确认根因后另发实施卡）：
- `C:/Users/Administrator/Documents/craft-demo/scripts/workspace-save-browser-flow.js`
- `C:/Users/Administrator/Documents/craft-demo/output/playwright/BF-0810-1/**`
- `C:/Users/Administrator/Documents/craft-demo/output/playwright/T-CRAFT-SAVE-001/workspace-save-success.png`（仅本次既有 runner 首轮误写的精确证据文件，须登记哈希；后续截图全部路由 BF 目录）
- `docs/bugfix/reviews/BF-0810-1.md`
- `.features/BF-0810-1/status.md`
- `.features/_registry.md`

任务记录：`.features/BF-0810-1/status.md`

禁止事项：诊断阶段不得修改功能源码、样式、package 文件、dist、存档服务、默认数据、公共资产或真实项目存档；不得初始化 Git、新增依赖、自动刷新或定时轮询；不得修改其他任务记录。

依赖：T-CRAFT-SAVE-001（已完成，QA-CRAFT-SAVE-001-R2 通过）。

QA 裁决（QA-BF-0810-1）：`pass`。六组独立验证、同秒/跨秒即时更新、写入失败边界、桌面与 760px 窄屏视觉、控制台零错误及范围核验全部通过；真实存档与项目源码在质检前后不变。User Gate：用户拒绝毫秒显示，要求保持 `HH:mm:ss`；原任务退回 FE-Gamma 做最小视觉返工，仍须保证跨秒保存成功后同页立即更新。

R1 实施结果：秒级显示已恢复；同秒连续保存允许显示相同秒值但响应/隔离磁盘分别更新，跨秒保存同页立即变化。实现方六组验证通过；本轮开始时真实存档已由用户更新为新的基线，R1 验证前后长度、mtime 与 SHA-256 不变。待 QA-BF-0810-1-R1 独立裁决。

QA 裁决（QA-BF-0810-1-R1）：`fail`。功能、六组回归、视觉、范围、真实存档与旧截图均通过；唯一阻塞是 Bug 报告“人工验收指南”仍保留已被用户拒绝的毫秒要求。退回原实现 Agent 仅修正文档验收口径，禁止再次修改功能源码与证据。

复验裁决（QA-BF-0810-1-R1-DOC）：`pass`。当前人工验收严格为 `HH:mm:ss`；同秒 UI 可相同、跨秒同页立即更新，历史毫秒方案已明确标为 User Gate 否决。文档返工期间 Craft 功能文件、证据、真实存档与旧截图均未变化。等待用户 User Gate。

### T-VIS-QA-005-R4-R3

目标：以最小只读流程补齐操作后快照与项目 after hash。

验收标准：
1. 对项目做 before 快照；只进行一次有限的真实 5173 页面切换和视口操作；再做 after 快照，条目数、SHA-256 和 projectWrites 可复核。
2. 从同一浏览器页面读取操作前后的 Craft 序列化、节点坐标、业务状态和撤销历史，确认视口操作/页面切换不改变业务快照。
3. 不运行 build、lint、Playwright CLI 或长循环；不产生项目下载文件；只使用内存或系统临时目录。
4. 复用已通过的核心回归证据，确认 5173 返回 200；返回结构化 JSON 裁决。

允许修改的文件范围：无，只读质检。

禁止事项：
- 不得修改、创建或删除项目文件。
- 不得运行构建或长时间命令。
- 不得修复问题或停止当前 5173。

依赖：T-VIS-005-R4。

### T-VIS-QA-005-R4-R2

目标：只读补齐项目后置哈希和 Craft 序列化/业务状态前后直比对。

验收标准：
1. 对当前项目做质检前快照和质检后快照，记录文件条目数、SHA-256 汇总和 projectWrites；本轮不运行会写项目的命令。
2. 在实际 5173 上导出或读取 Craft 序列化、节点坐标、业务状态和撤销历史快照；执行一次视口滚动、拖动、页面切换后再次读取，确认业务快照不变。
3. 可复用已通过的页面/手势/回归证据，不再运行长跑专项；确认 5173 返回 200，临时资源清理完成。
4. 返回结构化 JSON 裁决，不修改、不创建、不删除项目文件。

允许修改的文件范围：无，只读质检；不得写项目或系统临时目录。

禁止事项：
- 不得修改、创建或删除任何项目文件。
- 不得修复问题、运行构建或停止当前 5173。

依赖：T-VIS-005-R4。

### T-VIS-QA-005-R4-R1

目标：补齐最终验收中因执行策略和长跑超时未取得的独立证据，不修改项目。

验收标准：
1. 在真实 `http://127.0.0.1:5173/` 的 390×844 浏览器中，分别执行一次 0、10、50、100ms 延迟的 A/B 快速切换，记录每次 A/B 独立横向位置恢复；禁止无限循环。
2. 使用 `npm.cmd` 或等价可执行入口完成 lint；build 使用可写系统临时输出，不污染项目文件。
3. 运行 `T_VIS_004_PASS`、`T_VIS_003_R1_PASS` 及既有 workspace 回归，记录 console errors。
4. 直接比对 Craft 序列化数据、节点坐标、业务状态和撤销历史；确认编辑交互无回归。
5. 质检前后记录项目清单与 SHA-256，确认只读写入为 0；清理本轮临时资源，不停止当前 5173。
6. 返回结构化 JSON 裁决；不修改、不修复项目。

允许修改的文件范围：无，只读质检；只允许写系统临时目录。

禁止事项：
- 不得修改、创建或删除项目文件。
- 不得运行无限循环或长时间无界命令。
- 不得修复问题或停止当前 5173 服务。

依赖：T-VIS-005-R4。

### T-VIS-QA-005-R1

目标：独立复验页面切换后的画板视口恢复及返工后的相关回归。

验收标准：
1. 真实浏览器中验证页面 A/B 各自保存并恢复非零视口位置。
2. 验证桌面与移动尺寸、未浏览页面初始位置及所有已有导航手势。
3. 验证节点坐标、Craft 序列化数据、业务状态和撤销历史不变，编辑交互正常。
4. 验证 build、lint、既有回归、精确页面选择器、console errors 和服务清理。
5. 只读质检，返回结构化 JSON 裁决；不修改项目。

允许修改的文件范围：无，只读质检。

禁止事项：
- 不得修改、创建或删除项目文件。
- 不得修复问题或停止现有 5173 服务。

依赖：T-VIS-005-R1。

### T-VIS-007

目标：恢复当前 Craft 项目在 `http://127.0.0.1:5173/` 的本地预览服务。

验收标准：
1. 5173 监听当前状态清楚；若无监听，使用当前 Craft 项目已有预览产物启动隐藏、可持续服务。
2. 根路径与入口资源返回 200，浏览器不再显示 `ERR_CONNECTION_REFUSED`。
3. 仅保留一个指向当前 Craft 项目的 5173 监听进程，不停止无关进程。
4. 服务不依赖 Agent 会话，完成后持续运行。
5. 项目源文件、配置、文档、workspace 数据和构建产物前后无变化。

允许修改的文件范围：无；仅允许管理已确认属于当前 Craft 项目的 5173 预览进程。

禁止事项：
- 不得修改、创建或删除项目文件。
- 不得新增依赖或重建覆盖构建产物。
- 不得停止未知或无关进程。

依赖：T-VIS-006。
