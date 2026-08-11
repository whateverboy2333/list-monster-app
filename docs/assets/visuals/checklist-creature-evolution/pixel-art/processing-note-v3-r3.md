# Checklist Creature Pixel Evolution V3 R3 — Processing Note

- 输入文件：`checklist-creature-pixel-evolution-v3-r2.png`
- 输出文件：`checklist-creature-pixel-evolution-v3-r3.png`
- 图像尺寸：1693×929
- 目标背景色：RGB(254, 250, 236)
- 使用工具：Windows 自带 .NET `System.Drawing`
- 处理方法：以左上纯背景色和四边实际残留色组成精确 RGB 集合，从画布四边执行四邻域连通填充；随后仅对三个已确认无主体的空白抽样矩形做目标色定值填充。未使用色差阈值。
- 处理前四边非目标像素数：53
- 处理后四边非目标像素数：0
- 左上 400×250 区域唯一 RGB 数：1
- 底部左侧区域（x=0–499，y=800–928）唯一 RGB 数：1
- 右侧空白条（x=1650–1692，y=0–928）唯一 RGB 数：1
- 与输入文件不同的像素数：2,810
- 所有差异像素均设为目标背景色
- 非背景差异像素数：0
