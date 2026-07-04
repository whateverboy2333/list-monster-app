import 'package:flutter/material.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:sprite_runtime/sprite_runtime.dart';
import 'package:task_domain/task_domain.dart';
import 'package:ui_kit/ui_kit.dart';

import 'task_system_controller.dart';

void main() {
  runApp(const ListMonsterApp());
}

class ListMonsterApp extends StatelessWidget {
  const ListMonsterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '清单怪兽',
      theme: ListMonsterTheme.light(),
      home: const ListMonsterShell(),
    );
  }
}

class ListMonsterShell extends StatefulWidget {
  const ListMonsterShell({super.key});

  @override
  State<ListMonsterShell> createState() => _ListMonsterShellState();
}

class _ListMonsterShellState extends State<ListMonsterShell> {
  int _tabIndex = 0;
  late final TaskSystemController _taskSystem;

  @override
  void initState() {
    super.initState();
    _taskSystem = TaskSystemController();
  }

  @override
  void dispose() {
    _taskSystem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TodayTab(controller: _taskSystem),
      TaskListsTab(controller: _taskSystem),
      MonsterTab(controller: _taskSystem),
      const PlaceholderTab(title: '我的', message: '游客、通知、勿扰和桌宠开关会在后续节点接入。'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('清单怪兽')),
      body: tabs[_tabIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today_outlined), label: '今日'),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            label: '清单',
          ),
          NavigationDestination(
            icon: Icon(Icons.egg_alt_outlined),
            label: '怪兽',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }
}

class TodayTab extends StatefulWidget {
  const TodayTab({super.key, required this.controller});

  final TaskSystemController controller;

  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  final TextEditingController _titleController = TextEditingController();
  bool _withTonightReminder = false;
  bool _withRepeatPlaceholder = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        final milestone = controller.latestMilestone;
        final todayTasks = controller.todayTasks;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ListMonsterSectionHeader(title: '今日', subtitle: '把小事喂给小单。'),
              const SizedBox(height: 20),
              MonsterSpritePlaceholder(
                moodLabel: controller.monster.moodState.label,
                actionLabel: controller.monsterActionLabel,
              ),
              const SizedBox(height: 16),
              _MonsterStatusStrip(controller: controller),
              const SizedBox(height: 20),
              if (!controller.hasTasks)
                Text(
                  '小单正在等第一个任务',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              if (!controller.hasTasks) const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '今天要完成什么',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _createTask(),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _withTonightReminder,
                onChanged: (value) =>
                    setState(() => _withTonightReminder = value),
                title: const Text('今晚提醒意图'),
                subtitle: const Text('只记录提醒计划，不调度系统通知'),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _withRepeatPlaceholder,
                onChanged: (value) =>
                    setState(() => _withRepeatPlaceholder = value ?? false),
                title: const Text('保留重复规则占位'),
                subtitle: const Text('P0 只保存 repeatRuleId，不生成重复实例'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _createTask,
                icon: const Icon(Icons.add_task_outlined),
                label: const Text('加入今日'),
              ),
              const SizedBox(height: 24),
              Text('今日任务', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (todayTasks.isEmpty && controller.hasTasks)
                const Text('今日没有待处理任务。已放下或删除的任务可在清单页恢复。'),
              if (todayTasks.isNotEmpty)
                ...todayTasks.map(
                  (task) => _TaskTile(
                    task: task,
                    onComplete: () => controller.completeTask(task.id),
                    onUndo: () => controller.undoCompletion(task.id),
                    onCancel: () => controller.cancelTask(task.id),
                    onDelete: () => controller.deleteTask(task.id),
                  ),
                ),
              if (milestone != null) ...[
                const SizedBox(height: 20),
                _MilestoneCard(milestone: milestone),
              ],
            ],
          ),
        );
      },
    );
  }

  void _createTask() {
    widget.controller.createTask(
      _titleController.text,
      withTonightReminder: _withTonightReminder,
      repeatRuleId: _withRepeatPlaceholder ? 'repeat_placeholder' : null,
    );
    _titleController.clear();
  }
}

class TaskListsTab extends StatelessWidget {
  const TaskListsTab({super.key, required this.controller});

  final TaskSystemController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const ListMonsterSectionHeader(
              title: '清单分组',
              subtitle: '管理收集箱、长期任务和可恢复任务。',
            ),
            const SizedBox(height: 16),
            ...controller.taskLists.map(
              (list) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.folder_outlined),
                title: Text(list.name),
                subtitle: Text(list.listType.contractName),
                trailing: Text('${controller.countTasksInList(list.listId)}'),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: controller.activeTasks.isEmpty
                      ? null
                      : controller.applyNoPressureCleanup,
                  icon: const Icon(Icons.self_improvement_outlined),
                  label: const Text('无压清理：放下未完成'),
                ),
                OutlinedButton.icon(
                  onPressed: controller.undoLastBatchCleanup,
                  icon: const Icon(Icons.undo_outlined),
                  label: const Text('撤销最近清理'),
                ),
                OutlinedButton.icon(
                  onPressed: () => controller.createLongTermTask('读一本书'),
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: const Text('创建 3 天长期任务'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('长期任务', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (controller.longTermTasks.isEmpty)
              const Text('还没有长期任务。长期任务会自动生成每日拆解项。'),
            ...controller.longTermTasks.map(
              (task) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined),
                title: Text(task.title),
                subtitle: Text(
                  '${task.completedTaskCount}/${task.totalTaskCount} · ${task.status.contractName}',
                ),
              ),
            ),
            const SizedBox(height: 24),
            _RecoverableSection(
              title: '已放下',
              tasks: controller.cancelledTasks,
              onRestore: controller.restoreTask,
            ),
            const SizedBox(height: 16),
            _RecoverableSection(
              title: '已删除',
              tasks: controller.deletedTasks,
              onRestore: controller.restoreTask,
            ),
          ],
        );
      },
    );
  }
}

class _RecoverableSection extends StatelessWidget {
  const _RecoverableSection({
    required this.title,
    required this.tasks,
    required this.onRestore,
  });

  final String title;
  final List<TaskItem> tasks;
  final ValueChanged<String> onRestore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (tasks.isEmpty) const Text('暂无'),
        ...tasks.map(
          (task) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(task.title),
            subtitle: Text(task.status.contractName),
            trailing: TextButton(
              onPressed: () => onRestore(task.id),
              child: const Text('恢复'),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonsterStatusStrip extends StatelessWidget {
  const _MonsterStatusStrip({required this.controller});

  final TaskSystemController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(controller.monster.stage.label)),
              Chip(label: Text(controller.monster.moodState.label)),
              Chip(label: Text('完成 ${controller.completedRewardableCount}')),
            ],
          ),
        ),
        Text('+${controller.todayXp} XP', style: textTheme.titleMedium),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onComplete,
    required this.onUndo,
    required this.onCancel,
    required this.onDelete,
  });

  final TaskItem task;
  final VoidCallback onComplete;
  final VoidCallback onUndo;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckboxListTile(
          value: task.isCompleted,
          onChanged: task.isCompleted ? null : (_) => onComplete(),
          title: Text(task.title),
          subtitle: Text(_subtitle),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: 4,
            children: [
              if (task.isCompleted)
                IconButton(
                  tooltip: '撤销完成',
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo_outlined),
                ),
              if (task.status == TaskStatus.active)
                IconButton(
                  tooltip: '放下任务',
                  onPressed: onCancel,
                  icon: const Icon(Icons.self_improvement_outlined),
                ),
              IconButton(
                tooltip: '删除任务',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
        const Divider(height: 16),
      ],
    );
  }

  String get _subtitle {
    final parts = <String>[task.status.contractName, task.listId];
    if (task.reminderId != null) {
      parts.add('今晚提醒意图');
    }
    if (task.repeatRuleId != null) {
      parts.add('重复占位');
    }
    if (task.parentLongTermTaskId != null) {
      parts.add('长期拆解');
    }
    return parts.join(' · ');
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({required this.milestone});

  final DailyTaskMilestone milestone;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                milestone.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonsterTab extends StatelessWidget {
  const MonsterTab({super.key, required this.controller});

  final TaskSystemController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final monster = controller.monster;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const ListMonsterSectionHeader(
              title: '怪兽',
              subtitle: '小单的成长只来自真实完成。',
            ),
            const SizedBox(height: 20),
            MonsterSpritePlaceholder(
              moodLabel: monster.moodState.label,
              actionLabel: monster.stage.label,
            ),
            const SizedBox(height: 20),
            Text(
              monster.stage.label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('等级 ${monster.level} · ${monster.moodState.label}'),
            const SizedBox(height: 8),
            Text('${monster.currentLevelXp} / ${monster.xpToNextLevel} XP'),
          ],
        );
      },
    );
  }
}

class PlaceholderTab extends StatelessWidget {
  const PlaceholderTab({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
