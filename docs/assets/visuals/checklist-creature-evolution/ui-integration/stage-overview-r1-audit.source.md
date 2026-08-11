---
title: stage-overview R1 蛋体比例影响审计
date: 2026-08-05
status: no_change_required
task_id: T-DIGIPET-007A-R1
---

# `stage-overview` R1 蛋体比例影响审计

## 结论

无需新增 `stage-overview-r1.png`。现有总览没有复用蛋页的窄长浅色观察窗，也没有对蛋体做非等比缩放；用户反馈对应的是 `stage-00-egg.png` 主舱构图，不影响总览中的角色裁切。

## 比例证据

- 总览引用：`role-crops/role-stage-00-egg.png`。
- 派生裁切尺寸：480×720；alpha 有效像素包围盒为 `[0, 0, 479, 719]`，宽高比为 `0.666667`。
- 总览显示盒：146×219，宽高比为 `0.666667`。
- SVG 变换：`preserveAspectRatio="xMidYMid meet"`。
- 显示宽高比与引用裁切有效像素宽高比差异：`0.000%`。
- 总览背景为统一深墨角色卡，没有包住蛋体的纵向椭圆光晕，因此不存在与旧蛋页相同的轮廓放大效应。

## 处置

保留 `stage-overview.png`、`stage-overview.source.svg`、`stage-overview.source.md` 与 `stage-overview.meta.json` 不变；不以无实质视觉差异的重复导出覆盖既有总览归档。
