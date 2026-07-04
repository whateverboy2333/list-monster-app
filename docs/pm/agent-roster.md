# 清单怪兽多 Agent 协作名册

## PM 中枢

| 标识 | 名称 | Thread |
|---|---|---|
| AG-PM-00 | 项目经理中枢 | 当前对话 |

PM 中枢负责派单、收口、读取子 Agent 结果、转发跨组问题、做最终优先级裁决。

## 已招募 Agent

| 标识 | 名称 | Thread ID | 职责 |
|---|---|---|---|
| AG-CONTRACT-01 | 契约守门官 | 019f22e1-023f-7b92-a686-0bb4a4613603 | 数据模型、事件、API、资产命名、埋点契约 |
| AG-PROD-01 | 产品流程官 | 019f22e1-2d08-7c73-8832-d541cbbae573 | PRD 到页面流程、用户路径、MVP 边界 |
| AG-CLIENT-01 | 客户端架构官 | 019f22e1-46e8-7320-9661-99d89b9b0995 | Flutter/跨端架构、本地数据库、状态管理、工程骨架 |
| AG-TASK-01 | 任务系统负责人 | 019f22e1-5e4a-7c60-82d9-c60e9f6d7966 | 任务、清单、长期任务、无压清理、完成操作 |
| AG-MONSTER-01 | 怪兽养成负责人 | 019f22e1-7e84-77f3-b949-6ea3c65cd0a6 | 经验、等级、Streak、今日任务激励、状态机、互动 |
| AG-COMPANION-01 | 陪伴场域负责人 | 019f22e1-aa2a-7db1-88b2-32a49d5b6df1 | PC 桌宠、Android 小组件、状态快照读取 |
| AG-SYNC-01 | 账号同步与通知负责人 | 019f22e1-dc30-7732-88ed-6fc16b3646b0 | 游客模式、登录、云同步、通知、勿扰、合规 |
| AG-QA-01 | 审核验收官 | 019f22e1-f96b-7ee2-aa93-d8dac88aafe7 | 验收标准、测试矩阵、跨组接口审核、风险反馈 |

## 通信规则

所有跨组消息必须包含：

```text
FROM: AG-XXX-01
TO: AG-YYY-01 或 AG-PM-00
TYPE: question | proposal | decision-needed | review-request | report
TOPIC: 简短主题
BLOCKER: yes | no
```

子 Agent 不直接改其他组的方案；需要跨组协调时，发给 AG-PM-00，由 PM 中枢路由给目标 Agent。

## 工作边界

当前仓库没有初始 commit，暂时禁止子 Agent 写代码、改文件或执行 git 操作。第一轮只做 PRD 拆解、契约建议、风险识别和审核反馈。

进入代码开发前，必须先完成：

1. 项目骨架建立。
2. `docs/contracts/` 契约文件创建。
3. 初始 commit。
4. 为代码执行型 Agent 分配独立 worktree。
