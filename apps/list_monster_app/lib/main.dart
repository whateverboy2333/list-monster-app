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
      LongTermTab(controller: _taskSystem),
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
            icon: Icon(Icons.calendar_month_outlined),
            label: '长期',
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
  final TextEditingController _reminderTimeController = TextEditingController(
    text: '20:00',
  );
  bool _withTaskReminder = false;
  bool _withRepeatPlaceholder = false;
  String? _reminderTimeError;

  @override
  void dispose() {
    _titleController.dispose();
    _reminderTimeController.dispose();
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
              _NewTaskOptions(
                reminderEnabled: _withTaskReminder,
                repeatEnabled: _withRepeatPlaceholder,
                reminderTimeController: _reminderTimeController,
                reminderTimeError: _reminderTimeError,
                onReminderEnabledChanged: (value) {
                  setState(() {
                    _withTaskReminder = value;
                    if (!value) {
                      _reminderTimeError = null;
                    }
                  });
                },
                onRepeatChanged: (value) =>
                    setState(() => _withRepeatPlaceholder = value),
                onReminderTimeChanged: (_) =>
                    setState(() => _reminderTimeError = null),
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
                const Text('今日没有待处理任务。已放下或删除的任务可在下方恢复。'),
              if (todayTasks.isNotEmpty)
                ...todayTasks.map(
                  (task) => _TaskTile(
                    task: task,
                    onComplete: () => controller.completeTask(task.id),
                    onUndo: () => controller.undoCompletion(task.id),
                    onCancel: () => controller.cancelTask(task.id),
                    onDelete: () => controller.deleteTask(task.id),
                    onToggleRepeat: () => controller.setTaskRepeatPlaceholder(
                      task.id,
                      task.repeatRuleId == null,
                    ),
                    onReminderChanged: (reminderTime) =>
                        controller.setTaskReminderIntent(task.id, reminderTime),
                  ),
                ),
              if (milestone != null) ...[
                const SizedBox(height: 20),
                _MilestoneCard(milestone: milestone),
              ],
              const SizedBox(height: 24),
              _TodayCleanupActions(controller: controller),
              const SizedBox(height: 16),
              _RecoverableSection(
                title: '已放下',
                tasks: controller.cancelledTasks,
                onRestore: controller.restoreTask,
              ),
              _RecoverableSection(
                title: '已删除',
                tasks: controller.deletedTasks,
                onRestore: controller.restoreTask,
              ),
            ],
          ),
        );
      },
    );
  }

  void _createTask() {
    final reminderTime = _withTaskReminder
        ? _normalizeReminderTimeInput(_reminderTimeController.text)
        : null;
    if (_withTaskReminder && reminderTime == null) {
      setState(() => _reminderTimeError = '请输入 00:00-23:59');
      return;
    }

    widget.controller.createTask(
      _titleController.text,
      reminderTime: reminderTime,
      repeatRuleId: _withRepeatPlaceholder
          ? TaskSystemController.repeatPlaceholderRuleId
          : null,
    );
    _titleController.clear();
  }
}

class _NewTaskOptions extends StatelessWidget {
  const _NewTaskOptions({
    required this.reminderEnabled,
    required this.repeatEnabled,
    required this.reminderTimeController,
    required this.reminderTimeError,
    required this.onReminderEnabledChanged,
    required this.onRepeatChanged,
    required this.onReminderTimeChanged,
  });

  final bool reminderEnabled;
  final bool repeatEnabled;
  final TextEditingController reminderTimeController;
  final String? reminderTimeError;
  final ValueChanged<bool> onReminderEnabledChanged;
  final ValueChanged<bool> onRepeatChanged;
  final ValueChanged<String> onReminderTimeChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('新任务选项', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            const Text('只应用到下一次新增的任务；已有任务可在任务行修改。'),
            const SizedBox(height: 8),
            SwitchListTile(
              value: repeatEnabled,
              onChanged: onRepeatChanged,
              title: const Text('新任务重复占位'),
              subtitle: const Text('保存 repeatRuleId，不生成重复实例'),
              secondary: const Icon(Icons.repeat_outlined),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              value: reminderEnabled,
              onChanged: onReminderEnabledChanged,
              title: const Text('新任务提醒意图'),
              subtitle: const Text('只记录提醒计划，不调度系统通知'),
              secondary: const Icon(Icons.notifications_outlined),
              contentPadding: EdgeInsets.zero,
            ),
            if (reminderEnabled)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: reminderTimeController,
                  decoration: InputDecoration(
                    labelText: '提醒时间',
                    hintText: '20:30',
                    errorText: reminderTimeError,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  onChanged: onReminderTimeChanged,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LongTermTab extends StatelessWidget {
  const LongTermTab({super.key, required this.controller});

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
              title: '长期任务',
              subtitle: '超过一天的目标，会自动拆成每日任务。',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => controller.createLongTermTask('读一本书'),
              icon: const Icon(Icons.add_task_outlined),
              label: const Text('创建 3 天长期任务'),
            ),
            const SizedBox(height: 20),
            if (controller.longTermTasks.isEmpty)
              const Text('还没有长期任务。长期任务会自动生成每日拆解项。'),
            ...controller.longTermTasks.map(
              (task) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined),
                title: Text(task.title),
                subtitle: Text(
                  '${task.completedTaskCount}/${task.totalTaskCount} · ${task.status.label}',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TodayCleanupActions extends StatelessWidget {
  const _TodayCleanupActions({required this.controller});

  final TaskSystemController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('无压清理', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        const Text('今天暂时做不完的任务，可以先放下，不产生 XP 惩罚。'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: controller.activeTasks.isEmpty
                  ? null
                  : controller.applyNoPressureCleanup,
              icon: const Icon(Icons.self_improvement_outlined),
              label: const Text('放下未完成'),
            ),
            OutlinedButton.icon(
              onPressed: controller.undoLastBatchCleanup,
              icon: const Icon(Icons.undo_outlined),
              label: const Text('撤销最近清理'),
            ),
          ],
        ),
      ],
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
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text('${tasks.length} 个任务'),
      children: [
        if (tasks.isEmpty)
          const Align(alignment: Alignment.centerLeft, child: Text('暂无')),
        ...tasks.map(
          (task) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(task.title),
            subtitle: Text(task.status.label),
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

extension on TaskStatus {
  String get label {
    return switch (this) {
      TaskStatus.active => '进行中',
      TaskStatus.completed => '已完成',
      TaskStatus.cancelled => '已放下',
      TaskStatus.deleted => '已删除',
    };
  }
}

extension on LongTermTaskStatus {
  String get label {
    return switch (this) {
      LongTermTaskStatus.active => '进行中',
      LongTermTaskStatus.achieved => '已完成',
      LongTermTaskStatus.cancelled => '已取消',
      LongTermTaskStatus.deleted => '已删除',
    };
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onComplete,
    required this.onUndo,
    required this.onCancel,
    required this.onDelete,
    required this.onToggleRepeat,
    required this.onReminderChanged,
  });

  final TaskItem task;
  final VoidCallback onComplete;
  final VoidCallback onUndo;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onToggleRepeat;
  final ValueChanged<String?> onReminderChanged;

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
              IconButton(
                tooltip: task.repeatRuleId == null ? '设为重复占位' : '取消重复占位',
                onPressed: onToggleRepeat,
                icon: const Icon(Icons.repeat_outlined),
              ),
              IconButton(
                tooltip: '设置提醒时间',
                onPressed: () => _showReminderDialog(context),
                icon: const Icon(Icons.notifications_outlined),
              ),
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

  Future<void> _showReminderDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) =>
          _ReminderTimeDialog(initialTime: task.dueTime ?? '20:00'),
    );

    if (result == null) {
      return;
    }
    onReminderChanged(_normalizeReminderTimeInput(result));
  }

  String get _subtitle {
    final parts = <String>[task.status.label];
    if (task.reminderId != null) {
      parts.add('提醒 ${task.dueTime ?? '已设置'}');
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

class _ReminderTimeDialog extends StatefulWidget {
  const _ReminderTimeDialog({required this.initialTime});

  final String initialTime;

  @override
  State<_ReminderTimeDialog> createState() => _ReminderTimeDialogState();
}

class _ReminderTimeDialogState extends State<_ReminderTimeDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _reminderTimeController;

  @override
  void initState() {
    super.initState();
    _reminderTimeController = TextEditingController(text: widget.initialTime);
  }

  @override
  void dispose() {
    _reminderTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('设置提醒时间'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _reminderTimeController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '提醒时间',
            hintText: '20:30',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.datetime,
          validator: (value) {
            if (_normalizeReminderTimeInput(value ?? '') == null) {
              return '请输入 00:00-23:59';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(''),
          child: const Text('清除'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(_reminderTimeController.text);
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}

String? _normalizeReminderTimeInput(String value) {
  final match = RegExp(
    r'^([01]?\d|2[0-3]):([0-5]\d)$',
  ).firstMatch(value.trim());
  if (match == null) {
    return null;
  }

  final hour = int.parse(match.group(1)!);
  final minute = match.group(2)!;
  return '${hour.toString().padLeft(2, '0')}:$minute';
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
