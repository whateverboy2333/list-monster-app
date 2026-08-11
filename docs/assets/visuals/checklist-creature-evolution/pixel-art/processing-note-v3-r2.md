# Checklist Creature Pixel Evolution V3 R2 — Processing Note

- 输入文件：`checklist-creature-pixel-evolution-v3-r1.png`
- 输出文件：`checklist-creature-pixel-evolution-v3-r2.png`
- 背景纯色：RGB(254, 250, 236)
- 处理工具：Windows 自带 .NET `System.Drawing`
- 处理方法：从左上 400×250 纯背景区提取 35 个实际背景 RGB，以画布外边界为种子执行四邻域连通填充；仅将匹配该精确背景调色板且与边界连通的像素统一为目标纯色。
- 左上 400×250 区域处理前唯一 RGB 数：35
- 左上 400×250 区域处理后唯一 RGB 数：1
- 处理后左上区域 RGB：RGB(254, 250, 236)
- 输入与输出尺寸：均为 1693×929
- 改变像素数：554,703
- 设为目标背景色的差异像素数：554,703
- 背景替换之外的差异像素数：0
