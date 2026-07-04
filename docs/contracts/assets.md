# Assets Contract v0.1.3

## 怪兽资源路径

建议路径：

```text
assets/sprites/monsters/{speciesKey}/{styleLine}/{stage}/{actionKey}.png
```

示例：

```text
assets/sprites/monsters/lister/soft/child/idle_01.png
```

## Sprite Sheet 规范

每个动作资源必须配套元数据：

| 字段 | 说明 |
|---|---|
| `actionKey` | 动作 key |
| `frameCount` | 帧数 |
| `fps` | 播放帧率 |
| `loop` | 是否循环 |
| `anchorX` | 锚点 X，0-1 |
| `anchorY` | 锚点 Y，0-1 |
| `widgetFrameAssetId` | Widget 静态状态帧 |

客户端不得自行从动画里猜测 Widget 静态帧，必须使用 `widgetFrameAssetId`。

## 枚举

| 字段 | 取值 |
|---|---|
| `speciesKey` | `lister` |
| `styleLine` | `cool` / `soft` / `neutral` |
| `stage` | `egg` / `child` / `teen` / `adult` |

## 动作 key

MVP 动作：

1. `idle_01`
2. `idle_02`
3. `idle_03`
4. `happy_01`
5. `happy_02`
6. `happy_03`
7. `eat`
8. `sleep`
9. `wake_up`
10. `missing`
11. `pet_01`
12. `pet_02`
13. `hatch`
14. `level_up`
15. `evolve`
16. `task_milestone`
17. `notify`

## 睡觉互动

睡觉状态下：

1. 抚摸一两次不打断睡眠，可播放轻微翻身或梦话反应。
2. 多次抚摸触发 `wake_up`，表现为从睡觉到醒来的过渡。
3. 该过程不产生 XP。

## 禁止动作

禁止出现以下动作或资源命名：

1. `sick`
2. `dead`
3. `hungry`
4. `angry`
5. `leave`
6. `punish`

## 音效

建议路径：

```text
assets/audio/sfx/{sfxKey}.wav
```

MVP 音效：

1. `task_check`
2. `energy_fly`
3. `monster_eat`
4. `milestone`
5. `level_up`
6. `hatch`
