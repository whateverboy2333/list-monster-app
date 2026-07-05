import 'package:flutter/foundation.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:task_domain/task_domain.dart';

enum LongTermBreakdownSource { manual, ai }

class TaskSystemController extends ChangeNotifier {
  TaskSystemController({
    DateTime? today,
    this.userId = 'local_guest',
    this.timezoneId = 'Asia/Shanghai',
  }) : today = _dateOnly(today ?? DateTime.now()),
       monster = MonsterSnapshot.initialEgg(
         monsterId: 'monster_local_egg',
         userId: userId,
       ) {
    _taskLists.add(TaskList.systemInbox(userId: userId));
    _taskLists.add(
      TaskList(
        listId: 'home',
        userId: userId,
        listType: TaskListType.custom,
        name: '生活',
        color: 'green',
        icon: 'home',
        sortOrder: 1,
        isSystem: false,
      ),
    );
  }

  static const repeatPlaceholderRuleId = 'repeat_placeholder';

  final String userId;
  final String timezoneId;
  final DateTime today;
  MonsterSnapshot monster;

  final List<TaskItem> _tasks = [];
  final List<TaskList> _taskLists = [];
  final List<LongTermTask> _longTermTasks = [];
  final List<ReminderIntent> _reminderIntents = [];
  final List<XpLedgerEntry> _xpLedger = [];
  final List<Object> _events = [];
  List<String> _lastBatchCleanupTaskIds = const [];

  int _nextTaskNumber = 1;
  int _nextEventNumber = 1;
  int _nextXpLedgerNumber = 1;
  int _nextReminderNumber = 1;
  int _nextLongTermNumber = 1;
  int _nextBatchNumber = 1;
  int _todayXp = 0;
  DailyTaskMilestone? _latestMilestone;

  List<TaskItem> get tasks => List.unmodifiable(_tasks);
  List<TaskItem> get todayTasks {
    return _tasks
        .where(
          (task) =>
              task.isVisible &&
              task.status != TaskStatus.cancelled &&
              _isSameDate(task.scheduledDate, today),
        )
        .toList(growable: false);
  }

  List<TaskItem> get activeTasks {
    return _tasks
        .where((task) => task.status == TaskStatus.active)
        .toList(growable: false);
  }

  List<TaskItem> get cancelledTasks {
    return _tasks
        .where((task) => task.status == TaskStatus.cancelled)
        .toList(growable: false);
  }

  List<TaskItem> get deletedTasks {
    return _tasks
        .where((task) => task.status == TaskStatus.deleted)
        .toList(growable: false);
  }

  List<TaskList> get taskLists => List.unmodifiable(_taskLists);
  List<LongTermTask> get longTermTasks => List.unmodifiable(_longTermTasks);
  List<TaskItem> longTermChildTasks(String longTermTaskId) {
    final childTasks = _tasks
        .where((task) => task.parentLongTermTaskId == longTermTaskId)
        .toList();
    childTasks.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    return List.unmodifiable(childTasks);
  }

  List<ReminderIntent> get reminderIntents =>
      List.unmodifiable(_reminderIntents);
  List<XpLedgerEntry> get xpLedger => List.unmodifiable(_xpLedger);
  List<Object> get events => List.unmodifiable(_events);

  int get completedRewardableCount {
    return _tasks
        .where((task) => task.isCompleted && task.rewardEligible)
        .length;
  }

  int get todayXp => _todayXp;
  DailyTaskMilestone? get latestMilestone => _latestMilestone;
  bool get hasTasks => _tasks.isNotEmpty;

  String get monsterActionLabel {
    if (_tasks.isEmpty) {
      return '获得怪兽蛋';
    }
    if (activeTasks.isNotEmpty) {
      return '期待投喂';
    }
    if (completedRewardableCount > 0) {
      return '吸收能量';
    }
    return '等待任务';
  }

  int countTasksInList(String listId) {
    return _tasks
        .where(
          (task) => task.listId == listId && task.status != TaskStatus.deleted,
        )
        .length;
  }

  void createTask(
    String title, {
    String listId = 'inbox',
    TaskPriority priority = TaskPriority.none,
    bool withTonightReminder = false,
    String? reminderTime,
    String? repeatRuleId,
    DateTime? scheduledDate,
  }) {
    final id = 'task_${_nextTaskNumber++}';
    final effectiveReminderTime =
        _normalizeReminderTime(reminderTime) ??
        (withTonightReminder ? '20:00' : null);
    final reminderId = effectiveReminderTime != null
        ? 'rem_${_nextReminderNumber++}'
        : null;
    final draft = TaskDraft(
      title: title,
      listId: listId,
      priority: priority,
      scheduledDate: scheduledDate,
      dueTime: effectiveReminderTime,
      reminderId: reminderId,
      repeatRuleId: repeatRuleId,
    );

    if (!draft.canCreate) {
      return;
    }

    final task = TaskItem.create(
      id: id,
      userId: userId,
      draft: draft,
      today: today,
    );
    _tasks.add(task);
    _events.add(
      task.toCreatedEvent(eventId: _nextEventId(), createdAt: DateTime.now()),
    );

    if (effectiveReminderTime != null && reminderId != null) {
      final reminder = ReminderIntent.localTime(
        reminderId: reminderId,
        taskId: id,
        localDate: today,
        timeOfDay: effectiveReminderTime,
      );
      _reminderIntents.add(reminder);
      _events.add(reminder);
    }

    notifyListeners();
  }

  void setTaskRepeatPlaceholder(String taskId, bool enabled) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    _tasks[index] = _tasks[index].copyWith(
      repeatRuleId: enabled ? repeatPlaceholderRuleId : null,
      clearRepeatRuleId: !enabled,
    );

    notifyListeners();
  }

  void setTaskReminderIntent(String taskId, String? reminderTime) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    final normalizedReminderTime = _normalizeReminderTime(reminderTime);
    if (normalizedReminderTime == null) {
      _tasks[index] = _tasks[index].copyWith(
        clearDueTime: true,
        clearReminderId: true,
      );
      _reminderIntents.removeWhere((intent) => intent.taskId == taskId);
      notifyListeners();
      return;
    }

    final reminderId =
        _tasks[index].reminderId ?? 'rem_${_nextReminderNumber++}';
    _tasks[index] = _tasks[index].copyWith(
      dueTime: normalizedReminderTime,
      reminderId: reminderId,
    );
    _reminderIntents.removeWhere((intent) => intent.taskId == taskId);

    final reminder = ReminderIntent.localTime(
      reminderId: reminderId,
      taskId: taskId,
      localDate: today,
      timeOfDay: normalizedReminderTime,
    );
    _reminderIntents.add(reminder);
    _events.add(reminder);

    notifyListeners();
  }

  void completeTask(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1 || _tasks[index].isCompleted) {
      return;
    }

    final task = _tasks[index];
    final nextRewardableCount =
        completedRewardableCount + (task.rewardEligible ? 1 : 0);
    final nextTodayCompletedCount =
        _tasks.where((item) => item.isCompleted).length + 1;

    final result = task.complete(
      eventId: _nextEventId(),
      completedAt: DateTime.now(),
      timezoneId: timezoneId,
      completionOrderOfDay: nextRewardableCount,
      dailyRewardableCountAfter: nextRewardableCount,
      dailyTodayTaskCountAfter: nextTodayCompletedCount,
    );

    _tasks[index] = result.task;
    _events.add(result.event);

    if (result.event.rewardEligible) {
      _grantTaskCompletionXp(result.event);
    }
    _refreshLongTermProgress(result.task.parentLongTermTaskId);
    _refreshMilestone();

    notifyListeners();
  }

  void undoCompletion(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1 || !_tasks[index].isCompleted) {
      return;
    }

    final beforeUndoCount = completedRewardableCount;
    final thresholdReverted = DailyTaskMilestone.fromCompletedCount(
      completedEligibleTaskCount: beforeUndoCount,
      localDate: today,
      timezoneId: timezoneId,
    )?.milestoneKey;

    final result = _tasks[index].undoCompletion(
      eventId: _nextEventId(),
      undoneAt: DateTime.now(),
      thresholdReverted: thresholdReverted,
    );

    _tasks[index] = result.task;
    _events.add(result.event);
    _revertXpForCompletion(result.event.originalCompletedEventId);
    _refreshLongTermProgress(result.task.parentLongTermTaskId);
    _refreshMilestone();

    notifyListeners();
  }

  void cancelTask(String taskId, {String cancelReason = 'let_go'}) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1 || _tasks[index].status != TaskStatus.active) {
      return;
    }

    final result = _tasks[index].cancel(
      eventId: _nextEventId(),
      cancelledAt: DateTime.now(),
      cancelReason: cancelReason,
    );
    _tasks[index] = result.task;
    _events.add(result.event);

    notifyListeners();
  }

  void deleteTask(String taskId, {String deleteReason = 'user_delete'}) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1 || _tasks[index].status == TaskStatus.deleted) {
      return;
    }

    final result = _tasks[index].delete(
      eventId: _nextEventId(),
      deletedAt: DateTime.now(),
      deleteReason: deleteReason,
    );
    _tasks[index] = result.task;
    _events.add(result.event);

    notifyListeners();
  }

  void restoreTask(String taskId, {String restoreReason = 'restore'}) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }
    final task = _tasks[index];
    if (task.status != TaskStatus.cancelled &&
        task.status != TaskStatus.deleted) {
      return;
    }

    final result = task.restore(
      eventId: _nextEventId(),
      restoredAt: DateTime.now(),
      restoreReason: restoreReason,
      restoredFromEventId: 'local_restore',
    );
    _tasks[index] = result.task;
    _events.add(result.event);

    notifyListeners();
  }

  void applyNoPressureCleanup() {
    final cleanupTargets = activeTasks.map((task) => task.id).toList();
    if (cleanupTargets.isEmpty) {
      return;
    }

    for (final taskId in cleanupTargets) {
      cancelTask(taskId, cancelReason: 'no_pressure_cleanup');
    }
    _lastBatchCleanupTaskIds = cleanupTargets;
    _events.add(
      BatchCleanupAppliedEvent(
        batchId: 'batch_${_nextBatchNumber++}',
        action: BatchCleanupAction.letGo,
        affectedTaskIds: cleanupTargets,
        appliedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void undoLastBatchCleanup() {
    for (final taskId in _lastBatchCleanupTaskIds) {
      restoreTask(taskId, restoreReason: 'undo_batch_cleanup');
    }
    _lastBatchCleanupTaskIds = const [];
  }

  void createLongTermTask(
    String title, {
    DateTime? dueDate,
    List<String>? childTaskTitles,
    LongTermBreakdownSource breakdownSource = LongTermBreakdownSource.manual,
  }) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return;
    }
    final normalizedChildTaskTitles = childTaskTitles
        ?.map((title) => title.trim())
        .toList(growable: false);
    if (normalizedChildTaskTitles != null &&
        normalizedChildTaskTitles.any((title) => title.isEmpty)) {
      return;
    }

    final inferredTaskCount = normalizedChildTaskTitles?.length ?? 3;
    if (inferredTaskCount < 2) {
      return;
    }
    final resolvedDueDate =
        dueDate ?? today.add(Duration(days: inferredTaskCount - 1));
    final resolvedTaskCount =
        _dateOnly(resolvedDueDate).difference(today).inDays + 1;
    if (resolvedTaskCount < 2 ||
        (normalizedChildTaskTitles != null &&
            normalizedChildTaskTitles.length != resolvedTaskCount)) {
      return;
    }

    final longTerm = LongTermTask.create(
      longTermTaskId: 'long_${_nextLongTermNumber++}',
      userId: userId,
      title: normalizedTitle,
      startDate: today,
      dueDate: resolvedDueDate,
    );
    _longTermTasks.add(longTerm);
    _events.add(longTerm.toCreatedEvent(eventId: _nextEventId()));

    final generatedTitles = switch (breakdownSource) {
      LongTermBreakdownSource.manual => normalizedChildTaskTitles,
      LongTermBreakdownSource.ai => normalizedChildTaskTitles,
    };
    for (final generated in longTerm.generateChildTaskDrafts(
      childTaskTitles: generatedTitles,
    )) {
      _tasks.add(
        TaskItem.create(
          id: generated.taskId,
          userId: userId,
          draft: generated.draft,
          today: today,
        ),
      );
      _events.add(generated.event);
    }

    notifyListeners();
  }

  void cancelLongTermTask(String longTermTaskId) {
    final index = _longTermTasks.indexWhere(
      (task) => task.longTermTaskId == longTermTaskId,
    );
    if (index == -1 ||
        _longTermTasks[index].status != LongTermTaskStatus.active) {
      return;
    }

    final result = _longTermTasks[index].cancel(
      eventId: _nextEventId(),
      cancelledAt: DateTime.now(),
      cancelReason: 'let_go',
    );
    _longTermTasks[index] = result.task;
    _events.add(result.event);

    final activeChildTaskIds = _tasks
        .where(
          (task) =>
              task.parentLongTermTaskId == longTermTaskId &&
              task.status == TaskStatus.active,
        )
        .map((task) => task.id)
        .toList();
    for (final taskId in activeChildTaskIds) {
      cancelTask(taskId, cancelReason: 'longterm_cancelled');
    }

    notifyListeners();
  }

  void _grantTaskCompletionXp(TaskCompletedEvent event) {
    final xpAmount = XpPolicy.taskCompletionXp(
      completionOrderOfDay: event.completionOrderOfDay,
      highPriority: event.priority == TaskPriority.high,
    );
    final nextTodayXp = _todayXp + xpAmount;
    final ledgerEntry = XpLedgerEntry(
      xpLedgerId: 'xp_${_nextXpLedgerNumber++}',
      userId: userId,
      sourceEventId: event.eventId,
      sourceType: XpSourceType.taskCompleted,
      amount: xpAmount,
      localDate: today,
      timezoneId: timezoneId,
      dailyCapApplied: true,
      dailyTotalAfterGrant: nextTodayXp,
      createdAt: event.completedAt,
    );
    _xpLedger.add(ledgerEntry);
    _todayXp = nextTodayXp;
    _rebuildMonsterFromXp();
  }

  void _revertXpForCompletion(String originalCompletedEventId) {
    final original = _xpLedger
        .where((entry) => entry.sourceEventId == originalCompletedEventId)
        .firstOrNull;
    if (original == null || original.amount <= 0) {
      return;
    }

    final nextTodayXp = (_todayXp - original.amount).clamp(0, 1 << 31).toInt();
    _xpLedger.add(
      XpLedgerEntry(
        xpLedgerId: 'xp_${_nextXpLedgerNumber++}',
        userId: userId,
        sourceEventId: _nextEventId(),
        sourceType: XpSourceType.xpReverted,
        originalXpLedgerId: original.xpLedgerId,
        amount: -original.amount,
        localDate: today,
        timezoneId: timezoneId,
        dailyCapApplied: true,
        dailyTotalAfterGrant: nextTodayXp,
        reason: 'undo_completion',
        createdAt: DateTime.now(),
      ),
    );
    _todayXp = nextTodayXp;
    _rebuildMonsterFromXp();
  }

  void _rebuildMonsterFromXp() {
    final totalXp = _xpLedger.fold<int>(0, (sum, entry) => sum + entry.amount);
    monster = MonsterSnapshot.initialEgg(
      monsterId: 'monster_local_egg',
      userId: userId,
    );
    if (totalXp > 0) {
      monster = monster.applyXp(
        XpGrant(sourceEventId: 'xp_rebuild', amount: totalXp),
      );
    }
  }

  void _refreshLongTermProgress(String? longTermTaskId) {
    if (longTermTaskId == null) {
      return;
    }
    final index = _longTermTasks.indexWhere(
      (task) => task.longTermTaskId == longTermTaskId,
    );
    if (index == -1) {
      return;
    }

    final completedChildIds = _tasks
        .where(
          (task) =>
              task.parentLongTermTaskId == longTermTaskId && task.isCompleted,
        )
        .map((task) => task.id)
        .toList();

    final result = _longTermTasks[index].recordChildCompletion(
      eventId: _nextEventId(),
      completedTaskCount: completedChildIds.length,
      changedAt: DateTime.now(),
      sourceCompletedTaskIds: completedChildIds,
    );
    _longTermTasks[index] = result.task;
    _events.add(result.progressEvent);
    if (result.achievementEvent != null) {
      _events.add(result.achievementEvent!);
    }
  }

  void _refreshMilestone() {
    _latestMilestone = DailyTaskMilestone.fromCompletedCount(
      completedEligibleTaskCount: completedRewardableCount,
      localDate: today,
      timezoneId: timezoneId,
    );
  }

  String _nextEventId() => 'evt_${_nextEventNumber++}';
}

String? _normalizeReminderTime(String? reminderTime) {
  final value = reminderTime?.trim();
  if (value == null || value.isEmpty) {
    return null;
  }

  final match = RegExp(r'^([01]?\d|2[0-3]):([0-5]\d)$').firstMatch(value);
  if (match == null) {
    return null;
  }

  final hour = int.parse(match.group(1)!);
  final minute = match.group(2)!;
  return '${hour.toString().padLeft(2, '0')}:$minute';
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}
