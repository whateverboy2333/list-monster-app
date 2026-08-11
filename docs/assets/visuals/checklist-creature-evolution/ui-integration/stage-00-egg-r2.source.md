---
title: stage-00-egg-r2 来源与制作说明
date: 2026-08-05
status: implementation_baseline
task_id: T-DIGIPET-007A-R2
supersedes: stage-00-egg-r1.png
---

# `stage-00-egg-r2` 来源与制作说明

## 修订目的

响应用户“去掉横向光晕，只保留宠物蛋”的明确反馈。R2 以 R1 的已确认信息结构为基础，移除主舱内全部纵向／横向观察窗、椭圆光晕、额外落地影、横线和青色像素星点，不增加替代装饰。

## 蛋主体来源

- 最终状态资产：`../pixel-art/eggs/egg-glow-states-pixel-v3.png`，1728×972，SHA-256 `5b89d986a6a0c29ab3949a1c06cd9e49eba08312d104e54aa4d57c0e74b24a4f`。
- 结构参考：`../pixel-art/eggs/egg-turnaround-pixel-v7.png`，只读复核，不进入合成。
- R1 透明裁切 `role-crops/role-stage-00-egg.png` 为 480×720；其中本地行 `660–719` 是素材自带地面像素。
- R2 派生 `stage-00-egg-r2-asset.png` 只保留本地 `[0, 0, 480, 660]`，对应最终状态资产源坐标 `[624, 120, 1104, 780]`；尺寸及 alpha 有效包围盒均为 480×660。
- 252,864 个非透明像素与 R1 透明裁切的 RGBA 完全一致，且 RGB 与最终状态资产对应源坐标完全一致；未重画、重着色、镜像、平滑补绘或修改原素材。

## 等比显示

- SVG 显示盒：`x=157.5, y=180, width=128, height=176`。
- 蛋主体与显示盒宽高比均为 `0.727273`，差异 `0.000%`。
- 水平与垂直缩放系数均为 `0.266667`，使用 `preserveAspectRatio="xMidYMid meet"`；不存在非等比压缩。
- 蛋主体居中落在主舱上半区，与下方状态说明保持清晰间隔；边缘无空白椭圆、光晕或附加阴影。

## 保留内容

R2 完整保留初诺契茧身份、承诺 `2/3` 三方格、下一次点亮条件、未唤醒／回响积累／临近孵化轨迹、两条近期真实回响及无压力说明。页面不出现“抚摸”、幼年体或额外成长机制。

所有中文、数字和图标继续由 SVG 后期排版。正文最低对比度为 `4.77:1`，无乱码、重叠或越界。

## 导出

- 正式页面：`stage-00-egg-r2.png`，443×980，49,020 bytes，SHA-256 `691c23c8d974530986f3ee2b11b74f23f9637c8ea8424ee440a6748e8caad2c1`。
- 可重渲染源：`stage-00-egg-r2.source.svg`，SHA-256 `9a12af25935600e5133dda7a511e1bee79372cfdf5b5cfb8990f148e94723599`。
- 透明蛋主体：`stage-00-egg-r2-asset.png`，480×660，30,762 bytes，SHA-256 `081ae8096d3adb50832adc4afcb373491de2443d084579ea557fa3d1cedc85ad`。
- 旧 `stage-00-egg.*` 与 `stage-00-egg-r1.*` 全部保留；R2 取代 R1 成为后续 Craft 实现基线。
