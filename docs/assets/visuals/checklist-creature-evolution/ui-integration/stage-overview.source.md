---
title: stage-overview 来源与制作说明
date: 2026-08-05
status: ready_for_qa
task_id: T-DIGIPET-007B
---

# `stage-overview` 来源与制作说明

## 决策用途

让设计、实现与 QA 一眼比较初诺契茧、诺卷仔、联页契灵、履契拳师和万策卷贤的角色本体、阶段职责与专属界面结构，并看清共同路径到等权双分支的关系。

## 角色来源

- 初诺契茧：`role-crops/role-stage-00-egg.png`，源自最终三状态蛋图中间状态。
- 后四形态：`role-crops/role-stage-01-juvenile.png`、`role-stage-02-growth.png`、`role-stage-03-fighter.png`、`role-stage-04-scholar.png`，均源自 `checklist-creature-pixel-evolution-v3-r3.png`。
- 总览只引用已透明化的确定性派生裁切，不使用旧“小单”、AI 变体或重新绘制角色。

## 构图

- 共同路径为“初诺契茧 → 诺卷仔 → 联页契灵”。
- 联页契灵后以同线宽、同亮度 Y 形路径进入履契拳师与万策卷贤，避免暗示路线优劣。
- 每个角色同时展示阶段、体验重点与专属界面结构；底部统一列出真实完成、互动和中断三条业务边界。

## 响应式风险审计

- 该图是 1600×900 设计比较板，不是生产页面。
- 375px 查看时应改为“共同路径三项纵列 → 两个等权分支纵列”，不缩成不可读五列；允许纵向滚动。
- 200% 大字时隐藏装饰箭头，使用文字“共同路径”“等权分支”保持语义；每个阶段内容自然增高。
- 风险结论：中。主要风险是缩略阅读，不应把本图直接作为移动端实现界面。

## 导出

- SVG：`stage-overview.source.svg`。
- PNG：1600×900，258,456 bytes。
- SHA-256：`c8a297150f5c0624f29112e2b72ce96880a4fe9040ee51e21942dd0fcaa8f261`
- 渲染器：Microsoft Edge 151，无界面模式，设备像素比 1。

