# Egg Glow States Pixel V1 — Processing Note

- 生成后输入：内置 image_gen 输出 `call_N7lfIEyzFwngRQJwx6ingGty.png`
- 最终输出：`egg-glow-states-pixel-v1.png`
- 图像尺寸：1672×941
- 目标背景色：RGB(254, 250, 236)
- 使用工具：Windows 自带 .NET `System.Drawing`
- 处理方法：从经确认无主体的顶部、底部、左右边带及两条蛋间空白通道提取精确背景 RGB，以画布边界为种子执行四邻域连通填充；随后仅将上述纯空白区域定值为目标色。未使用色差阈值，未处理主体。
- 四边非目标像素数：0
- 左上 400×100 区域唯一 RGB 数：1
- 左下 400×100 区域唯一 RGB 数：1
- 右侧 60×941 空白条唯一 RGB 数：1
- 改变像素数：860,119
- 差异像素中未设为目标背景色的像素数：0
- 非背景差异像素数：0
