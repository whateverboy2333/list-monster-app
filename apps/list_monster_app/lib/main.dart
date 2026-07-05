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
              subtitle: '超过一天的目标，先拆成每日可完成的小任务。',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () =>
                  _showCreateLongTermTaskDialog(context, controller),
              icon: const Icon(Icons.add_task_outlined),
              label: const Text('创建长期任务'),
            ),
            const SizedBox(height: 20),
            if (controller.longTermTasks.isEmpty)
              const Text('还没有长期任务。创建时先写目标，再拆成每天的小任务。'),
            ...controller.longTermTasks.map((task) {
              final childTasks = controller.longTermChildTasks(
                task.longTermTaskId,
              );

              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined),
                title: Text(task.title),
                subtitle: Text(
                  '${_formatDateRange(task.startDate, task.dueDate)} · '
                  '${task.completedTaskCount}/${task.totalTaskCount} · '
                  '${task.status.label}',
                ),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: task.status == LongTermTaskStatus.active
                          ? () => _showEditLongTermTaskDialog(
                              context,
                              controller,
                              task,
                              childTasks,
                            )
                          : null,
                      icon: const Icon(Icons.edit_calendar_outlined),
                      label: const Text('编辑日期与拆解'),
                    ),
                  ),
                  ...childTasks.map(
                    (childTask) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(_formatMonthDay(childTask.scheduledDate)),
                      title: Text(childTask.title),
                      subtitle: Text(childTask.status.label),
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Future<void> _showCreateLongTermTaskDialog(
    BuildContext context,
    TaskSystemController controller,
  ) async {
    final plan = await showDialog<_LongTermTaskPlan>(
      context: context,
      builder: (context) =>
          _LongTermTaskDialog(initialStartDate: controller.today),
    );
    if (plan == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    controller.createLongTermTask(
      plan.title,
      startDate: plan.startDate,
      dueDate: plan.dueDate,
      childTaskTitles: plan.childTaskTitles,
      breakdownSource: LongTermBreakdownSource.manual,
    );
  }

  Future<void> _showEditLongTermTaskDialog(
    BuildContext context,
    TaskSystemController controller,
    LongTermTask task,
    List<TaskItem> childTasks,
  ) async {
    final plan = await showDialog<_LongTermTaskPlan>(
      context: context,
      builder: (context) => _LongTermTaskDialog(
        initialStartDate: task.startDate,
        initialPlan: _LongTermTaskPlan(
          title: task.title,
          startDate: task.startDate,
          dueDate: task.dueDate,
          childTaskTitles: childTasks.map((child) => child.title).toList(),
        ),
      ),
    );
    if (plan == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    final completedOutsideRange = childTasks
        .where(
          (child) =>
              child.isCompleted &&
              !_isDateWithinRange(
                child.scheduledDate,
                plan.startDate,
                plan.dueDate,
              ),
        )
        .length;
    if (completedOutsideRange > 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('不能把已完成的拆解任务排除出长期任务日期范围。')));
      return;
    }

    final activeOutsideRange = childTasks
        .where(
          (child) =>
              child.status == TaskStatus.active &&
              !_isDateWithinRange(
                child.scheduledDate,
                plan.startDate,
                plan.dueDate,
              ),
        )
        .length;
    if (activeOutsideRange > 0) {
      final confirmed = await _confirmLongTermDateEdit(
        context,
        affectedCount: activeOutsideRange,
      );
      if (!context.mounted) {
        return;
      }
      if (!confirmed) {
        return;
      }
    }

    final updated = controller.updateLongTermTaskPlan(
      task.longTermTaskId,
      title: plan.title,
      startDate: plan.startDate,
      dueDate: plan.dueDate,
      childTaskTitles: plan.childTaskTitles,
    );
    if (!updated && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('长期任务日期没有保存，请检查日期和拆解项。')));
    }
  }

  Future<bool> _confirmLongTermDateEdit(
    BuildContext context, {
    required int affectedCount,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('调整长期任务日期'),
        content: Text('新的日期范围会排除 $affectedCount 个未完成拆解任务。保存后这些任务会被放下，不产生 XP。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消保存'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认保存'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _LongTermTaskPlan {
  const _LongTermTaskPlan({
    required this.title,
    required this.startDate,
    required this.dueDate,
    required this.childTaskTitles,
  });

  final String title;
  final DateTime startDate;
  final DateTime dueDate;
  final List<String> childTaskTitles;
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '选择$label',
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
          child: Text(_formatDateInput(value)),
        ),
      ),
    );
  }
}

class _LongTermTaskDialog extends StatefulWidget {
  const _LongTermTaskDialog({required this.initialStartDate, this.initialPlan});

  final DateTime initialStartDate;
  final _LongTermTaskPlan? initialPlan;

  @override
  State<_LongTermTaskDialog> createState() => _LongTermTaskDialogState();
}

class _LongTermTaskDialogState extends State<_LongTermTaskDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _stepControllers = [];
  late DateTime _startDate;
  late DateTime _dueDate;
  int _dayCount = 3;

  @override
  void initState() {
    super.initState();
    final initialPlan = widget.initialPlan;
    final initialStartDate = initialPlan?.startDate ?? widget.initialStartDate;
    final initialDueDate =
        initialPlan?.dueDate ?? initialStartDate.add(const Duration(days: 2));
    _titleController.text = initialPlan?.title ?? '';
    _startDate = _dateOnly(initialStartDate);
    _dueDate = _dateOnly(initialDueDate);
    _dayCount = _dateRangeLength(_startDate, _dueDate) ?? 3;
    _syncStepControllers();
    final childTaskTitles = initialPlan?.childTaskTitles ?? const <String>[];
    for (
      var index = 0;
      index < childTaskTitles.length && index < _stepControllers.length;
      index++
    ) {
      _stepControllers[index].text = childTaskTitles[index];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialPlan == null ? '创建长期任务' : '编辑长期任务'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: '长期目标',
                    hintText: '例如：准备考试',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _hasText(value) ? null : '请输入长期目标',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerField(
                        key: const ValueKey('long-term-start-date-picker'),
                        label: '开始日期',
                        value: _startDate,
                        onTap: _pickStartDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DatePickerField(
                        key: const ValueKey('long-term-due-date-picker'),
                        label: '截止日期',
                        value: _dueDate,
                        onTap: _pickDueDate,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '当前会生成 $_dayCount 个每日拆解任务',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 12),
                Text('拆解路线', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    ChoiceChip(label: Text('手动拆解'), selected: true),
                    InputChip(label: Text('AI 拆解（后续）'), isEnabled: false),
                  ],
                ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.account_tree_outlined),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '手动拆解会按天生成对应日期的任务；AI 拆解会在后续版本根据目标生成草案。',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  _stepControllers.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _stepControllers[index],
                      decoration: InputDecoration(
                        labelText: '第 ${index + 1} 天任务',
                        hintText: _stepHint(index),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          _hasText(value) ? null : '请输入第 ${index + 1} 天任务',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.initialPlan == null ? '创建' : '保存'),
        ),
      ],
    );
  }

  void _syncStepControllers() {
    while (_stepControllers.length < _dayCount) {
      _stepControllers.add(TextEditingController());
    }
    while (_stepControllers.length > _dayCount) {
      _stepControllers.removeLast().dispose();
    }
  }

  void _applyDateRange(DateTime startDate, DateTime dueDate) {
    final nextStartDate = _dateOnly(startDate);
    final nextDueDate = _dateOnly(dueDate);
    final nextDayCount = _dateRangeLength(nextStartDate, nextDueDate);
    if (nextDayCount == null) {
      return;
    }
    setState(() {
      _startDate = nextStartDate;
      _dueDate = nextDueDate;
      _dayCount = nextDayCount;
      _syncStepControllers();
    });
  }

  Future<void> _pickStartDate() async {
    final selectedDate = await _showLongTermDatePicker(
      helpText: '选择开始日期',
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null || !mounted) {
      return;
    }

    final nextStartDate = _dateOnly(selectedDate);
    var nextDueDate = _dueDate;
    if (!nextDueDate.isAfter(nextStartDate)) {
      final preservedDays = _dayCount > 1 ? _dayCount - 1 : 1;
      nextDueDate = nextStartDate.add(Duration(days: preservedDays));
    }
    _applyDateRange(nextStartDate, nextDueDate);
  }

  Future<void> _pickDueDate() async {
    final firstDueDate = _startDate.add(const Duration(days: 1));
    final selectedDate = await _showLongTermDatePicker(
      helpText: '选择截止日期',
      initialDate: _dueDate.isBefore(firstDueDate) ? firstDueDate : _dueDate,
      firstDate: firstDueDate,
      lastDate: DateTime(2100),
    );
    if (selectedDate == null || !mounted) {
      return;
    }

    _applyDateRange(_startDate, selectedDate);
  }

  Future<DateTime?> _showLongTermDatePicker({
    required String helpText,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
      cancelText: '取消',
      confirmText: '确定',
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(
      _LongTermTaskPlan(
        title: _titleController.text.trim(),
        startDate: _startDate,
        dueDate: _dueDate,
        childTaskTitles: _stepControllers
            .map((controller) => controller.text.trim())
            .toList(growable: false),
      ),
    );
  }

  String _stepLabel(int index) {
    if (index == 0) {
      return '启动准备';
    }
    if (index == _dayCount - 1) {
      return '收尾检查';
    }
    return '推进产出';
  }

  String _stepHint(int index) {
    if (index == 0) {
      return '${_stepLabel(index)}：整理资料、明确范围、列出第一步';
    }
    if (index == _dayCount - 1) {
      return '${_stepLabel(index)}：复盘检查、完成提交、整理成果';
    }
    return '${_stepLabel(index)}：完成一个可检查的小成果';
  }
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

String _formatMonthDay(DateTime value) => '${value.month}/${value.day}';

String _formatDateRange(DateTime startDate, DateTime dueDate) {
  return '${_formatMonthDay(startDate)}-${_formatMonthDay(dueDate)}';
}

String _formatDateInput(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

int? _dateRangeLength(DateTime startDate, DateTime dueDate) {
  if (!dueDate.isAfter(startDate)) {
    return null;
  }
  return dueDate.difference(startDate).inDays + 1;
}

bool _isDateWithinRange(DateTime value, DateTime startDate, DateTime dueDate) {
  final date = DateTime(value.year, value.month, value.day);
  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
  return !date.isBefore(start) && !date.isAfter(due);
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
