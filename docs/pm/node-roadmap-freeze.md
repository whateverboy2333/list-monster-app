# 项目节点路线图冻结版

状态：已冻结

本文件是清单怪兽项目节点命名、节点目标、负责人、输出物和通过标准的唯一事实源。后续 PM、子 Agent、评审报告、工程任务拆分不得擅自更改节点编号、节点名称或节点定义。

如确需调整节点，必须由用户明确确认，并由 `AG-PM-00` 更新本文件后才能生效。

## 节点 1：契约冻结

目标：把“插头规格”正式写成 `docs/contracts/`。

负责人：`AG-CONTRACT-01`

审核：`AG-QA-01`

输出物：

```text
docs/contracts/domain-model.md
docs/contracts/events.md
docs/contracts/xp-rules.md
docs/contracts/companion-snapshot.md
docs/contracts/analytics.md
docs/contracts/assets.md
```

通过标准：

任务、怪兽、XP、Streak、桌宠、小组件、同步事件全部命名统一，没有 `daily_clear` 旧口径残留。

## 节点 2：工程骨架 + 初始 commit

目标：建立 Flutter monorepo 基础工程。

负责人：`AG-CLIENT-01`

输出物：

```text
apps/list_monster_app/
packages/core/
packages/task_domain/
packages/monster_domain/
packages/local_store/
packages/sync_domain/
packages/companion_contract/
packages/sprite_runtime/
packages/ui_kit/
```

通过标准：

项目能启动、能跑基础测试、有 lint，有初始 commit。

这个节点完成后，才能给代码型 Agent 分配独立 worktree 并行开发。

## 节点 3：核心闭环 Alpha

这是最重要的产品验证节点。

目标：跑通第一条完整体验：

```text
获得怪兽蛋
-> 创建任务
-> 完成任务
-> 能量反馈
-> XP 增长
-> 怪兽状态变化
-> 今日任务激励触发
```

负责人：

```text
AG-PROD-01：流程
AG-TASK-01：任务完成事件
AG-MONSTER-01：XP / 状态
AG-CLIENT-01：页面与动画承载
AG-QA-01：验收
```

通过标准：

不依赖云同步、不依赖桌宠，也能在本地完整跑通。

## 节点 4：任务系统 P0 完成

目标：把清单工具底座做完整。

范围：

```text
快速创建
今日视图
清单分组
任务完成 / 撤销 / 删除 / 恢复
长期任务拆解
无压清理
重复规则基础能力
提醒意图
```

关键验收：

取消 / 放下不产生 XP；`task_restored` 能正确恢复任务；长期任务不能直接完成，只能由拆解任务汇总达成。

## 节点 5：怪兽养成与激励 P0 完成

目标：把成长体系做稳定。

范围：

```text
XP 计算
每日上限
高优先级 +15 替代 +10
Streak
streak_break
今日任务激励
前日完成反馈
累计 3 天奖励
睡觉 / 想念 / 期待 / 元气状态机
抚摸与多次唤醒
```

关键验收：

所有成长都来自真实任务行为，不能被抚摸、打开 App、教学任务刷 XP。

## 节点 6：账号 / 同步 / 通知 / 陪伴场域

目标：补齐 MVP 外围能力。

范围：

```text
游客模式
登录
游客数据合并确认
云同步
本地通知
勿扰时段
15 天注销冷静期
PC 第二窗口桌宠
Android Glance Widget
CompanionSnapshot
```

关键验收：

桌宠和 Widget 只读统一快照，不自己计算任务、XP、Streak。

## 节点 7：QA 冻结与 MVP Beta

目标：进入可试用版本。

负责人：`AG-QA-01` 主导，全员修复。

验收矩阵：

```text
完成反馈链
任务撤销
task_restored
长期任务
无压清理
XP 幂等
Streak / streak_break
今日任务激励
离线完成
游客合并
通知勿扰
桌宠开关
Glance Widget
```

通过标准：

P0 全绿，核心闭环不卡顿，打勾反馈不被同步或网络阻塞。
