import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:sync_domain/sync_domain.dart';
import 'package:task_domain/task_domain.dart';

enum LongTermBreakdownSource { manual, ai }

typedef TaskSyncHandoff = FutureOr<void> Function(SyncQueueDraft operation);

class TaskSystemController extends ChangeNotifier {
  TaskSystemController({
    DateTime? today,
    DateTime? now,
    DateTime? lastOpenedDate,
    Iterable<DateTime> priorActiveDates = const [],
    Map<DateTime, int> priorCompletedEligibleCounts = const <DateTime, int>{},
    Map<DateTime, int> priorCreatedTaskCounts = const <DateTime, int>{},
    this.userId = 'local_guest',
    this.timezoneId = 'Asia/Shanghai',
    this.syncHandoff,
  }) : today = _dateOnly(today ?? DateTime.now()),
       _fixedNow = now,
       _lastOpenedDate = lastOpenedDate == null
           ? null
           : _dateOnly(lastOpenedDate),
       monster = MonsterSnapshot.initialEgg(
         monsterId: 'monster_local_egg',
         userId: userId,
       ) {
    _streak = StreakSnapshot.empty(timezoneId: timezoneId);
    for (final date in priorActiveDates) {
      final key = _formatDateKey(_dateOnly(date));
      _seedCompletedEligibleCounts[key] =
          (_seedCompletedEligibleCounts[key] ?? 0) + 1;
    }
    for (final entry in priorCompletedEligibleCounts.entries) {
      final key = _formatDateKey(_dateOnly(entry.key));
      _seedCompletedEligibleCounts[key] =
          (_seedCompletedEligibleCounts[key] ?? 0) + entry.value;
    }
    for (final entry in priorCreatedTaskCounts.entries) {
      final key = _formatDateKey(_dateOnly(entry.key));
      _seedCreatedTaskCounts[key] =
          (_seedCreatedTaskCounts[key] ?? 0) + entry.value;
    }
    _rebuildStreakFromActivity();
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
    _syncMonsterMood(actionKey: monster.currentAction);
  }

  static const repeatPlaceholderRuleId = 'repeat_placeholder';

  final String userId;
  final String timezoneId;
  final TaskSyncHandoff? syncHandoff;
  final DateTime today;
  final DateTime? _fixedNow;
  MonsterSnapshot monster;

  final List<TaskItem> _tasks = [];
  final List<TaskList> _taskLists = [];
  final List<LongTermTask> _longTermTasks = [];
  final List<ReminderIntent> _reminderIntents = [];
  final List<XpLedgerEntry> _xpLedger = [];
  final List<SyncQueueDraft> _syncHandoffOperations = [];
  final List<Object> _events = [];
  final Map<String, int> _seedCompletedEligibleCounts = {};
  final Map<String, int> _seedCreatedTaskCounts = {};
  final Set<int> _grantedCumulativeRewardThresholds = {};
  final Set<String> _shownMilestoneKeys = {};
  final Set<String> _summaryGeneratedDateKeys = {};
  final Set<String> _longTermRewardedTaskIds = {};
  List<String> _lastBatchCleanupTaskIds = const [];

  int _nextTaskNumber = 1;
  int _nextEventNumber = 1;
  int _nextXpLedgerNumber = 1;
  int _nextReminderNumber = 1;
  int _nextLongTermNumber = 1;
  int _nextBatchNumber = 1;
  int _todayXp = 0;
  DailyTaskMilestone? _latestMilestone;
  DailyTaskSummary? _latestDailySummary;
  CumulativeActiveRewardEvent? _latestCumulativeReward;
  MonsterPetReactionEvent? _latestPetReaction;
  late StreakSnapshot _streak;
  DateTime? _lastOpenedDate;
  DateTime? _wakeOverrideUntil;
  bool _missingActive = false;
  int _sleepPetCount = 0;

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
  List<SyncQueueDraft> get syncHandoffOperations =>
      List.unmodifiable(_syncHandoffOperations);
  List<Object> get events => List.unmodifiable(_events);

  int get completedRewardableCount {
    return _tasks.where(_isFormalCompletedTask).length;
  }

  int get todayXp => _todayXp;
  DailyTaskMilestone? get latestMilestone => _latestMilestone;
  DailyTaskSummary? get latestDailySummary => _latestDailySummary;
  CumulativeActiveRewardEvent? get latestCumulativeReward =>
      _latestCumulativeReward;
  MonsterPetReactionEvent? get latestPetReaction => _latestPetReaction;
  StreakSnapshot get streak => _streak;
  int get sleepPetCount => _sleepPetCount;
  int get activeDayCount => _activeDateKeys().length;
  bool get hasTasks => _tasks.isNotEmpty;

  String get monsterActionLabel {
    if (monster.currentAction == 'wake_up') {
      return '慢慢醒来';
    }
    if (monster.moodState == MonsterMood.sleeping) {
      return '睡觉中';
    }
    if (monster.moodState == MonsterMood.missing) {
      return '想念你';
    }
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

  int completedRewardableCountForDate(DateTime localDate) {
    final key = _formatDateKey(_dateOnly(localDate));
    final seedCount = _seedCompletedEligibleCounts[key] ?? 0;
    final taskCount = _tasks.where((task) {
      if (!_isFormalCompletedTask(task) || task.completedAt == null) {
        return false;
      }
      return _isSameDate(task.completedAt!, localDate);
    }).length;
    return seedCount + taskCount;
  }

  DailyTaskSummary? recordAppOpened(DateTime openedAt) {
    final openedLocalDate = _dateOnly(openedAt);
    final previousDate = openedLocalDate.subtract(const Duration(days: 1));
    if (_lastOpenedDate != null &&
        openedLocalDate.difference(_lastOpenedDate!).inDays > 3) {
      _missingActive = true;
    }
    _lastOpenedDate = openedLocalDate;

    final summaryKey = _formatDateKey(previousDate);
    DailyTaskSummary? summary;
    if (_summaryGeneratedDateKeys.add(summaryKey)) {
      final completedCount = completedRewardableCountForDate(previousDate);
      if (completedCount > 0) {
        summary = DailyTaskSummary(
          summaryForDate: previousDate,
          timezoneId: timezoneId,
          completedEligibleTaskCount: completedCount,
          createdTaskCount: _createdTaskCountForDate(previousDate),
          feedbackText: '昨天你完成了 $completedCount 件小事，小单都记得。',
        );
        _latestDailySummary = summary;
        _events.add(summary);
      }
    }

    _syncMonsterMood(actionKey: _missingActive ? 'missing' : null);
    notifyListeners();
    return summary;
  }

  MonsterPetReactionEvent petMonster({DateTime? interactedAt}) {
    final now = interactedAt ?? _now();
    final sleeping =
        monster.moodState == MonsterMood.sleeping ||
        (_isSleepingAt(now) && !_isWakeOverrideActive(now));
    if (!sleeping) {
      final reaction = MonsterPetReactionEvent(
        monsterId: monster.monsterId,
        reactionKey: 'pet_01',
        touchCountInSleep: 0,
        interactedAt: now,
      );
      _latestPetReaction = reaction;
      _events.add(reaction);
      _syncMonsterMood(actionKey: 'pet_01');
      notifyListeners();
      return reaction;
    }

    _sleepPetCount += 1;
    final shouldWake = _sleepPetCount >= monster.wakeUpThreshold;
    final sleepReactionKey = _sleepPetCount == 1 ? 'pet_01' : 'pet_02';
    final reaction = MonsterPetReactionEvent(
      monsterId: monster.monsterId,
      reactionKey: shouldWake ? 'wake_up' : sleepReactionKey,
      touchCountInSleep: _sleepPetCount,
      interactedAt: now,
    );
    _latestPetReaction = reaction;
    _events.add(reaction);

    if (shouldWake) {
      _wakeOverrideUntil = now.add(const Duration(minutes: 10));
      _sleepPetCount = 0;
      _syncMonsterMood(actionKey: 'wake_up');
    } else {
      _syncMonsterMood(actionKey: 'sleep');
    }
    notifyListeners();
    return reaction;
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
      task.toCreatedEvent(eventId: _nextEventId(), createdAt: _now()),
    );
    _incrementCreatedTaskCount(today);

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

  void completeTask(
    String taskId, {
    CompletionSource completionSource = CompletionSource.userAction,
  }) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1 || _tasks[index].isCompleted) {
      return;
    }

    final task = _tasks[index];
    final completedAt = _now();
    final completedLocalDate = _dateOnly(completedAt);
    final isFormalCompletion =
        task.rewardEligible &&
        completionSource != CompletionSource.onboardingAuto;
    final nextRewardableCount =
        completedRewardableCountForDate(completedLocalDate) +
        (isFormalCompletion ? 1 : 0);
    final nextTodayCompletedCount =
        _tasks
            .where(
              (item) =>
                  item.isCompleted &&
                  item.completedAt != null &&
                  _isSameDate(item.completedAt!, completedLocalDate),
            )
            .length +
        1;

    final result = task.complete(
      eventId: _nextEventId(),
      completedAt: completedAt,
      timezoneId: timezoneId,
      completionOrderOfDay: nextRewardableCount,
      dailyRewardableCountAfter: nextRewardableCount,
      dailyTodayTaskCountAfter: nextTodayCompletedCount,
      completionSource: completionSource,
    );

    _tasks[index] = result.task;
    _events.add(result.event);
    _handoffTaskEvent(
      operationType: SyncOperationType.taskComplete,
      taskId: result.event.taskId,
      eventId: result.event.eventId,
      occurredAt: result.event.completedAt,
      eventName: result.event.eventName,
      payload: result.event.payload,
    );

    if (isFormalCompletion) {
      _grantTaskCompletionXp(result.event);
      _recordActiveDay(result.event.completedLocalDate);
      _maybeGrantCumulativeActiveReward(result.event.completedLocalDate);
    }
    _refreshLongTermProgress(result.task.parentLongTermTaskId);
    _refreshMilestone();
    _missingActive = false;
    _syncMonsterMood(
      actionKey: isFormalCompletion
          ? (monster.currentAction == 'level_up' ? 'level_up' : 'eat')
          : null,
    );

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
      undoneAt: _now(),
      thresholdReverted: thresholdReverted,
    );

    _tasks[index] = result.task;
    _events.add(result.event);
    _handoffTaskEvent(
      operationType: SyncOperationType.taskUndoCompletion,
      taskId: result.event.taskId,
      eventId: result.event.eventId,
      occurredAt: result.event.undoneAt,
      eventName: result.event.eventName,
      payload: result.event.payload,
    );
    _revertXpForCompletion(
      result.event.originalCompletedEventId,
      revertEventId: result.event.eventId,
      revertedAt: result.event.undoneAt,
    );
    _rebuildStreakFromActivity();
    _refreshLongTermProgress(result.task.parentLongTermTaskId);
    _refreshMilestone();
    _syncMonsterMood();

    notifyListeners();
  }

  void cancelTask(String taskId, {String cancelReason = 'let_go'}) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1 || _tasks[index].status != TaskStatus.active) {
      return;
    }

    final result = _tasks[index].cancel(
      eventId: _nextEventId(),
      cancelledAt: _now(),
      cancelReason: cancelReason,
    );
    _tasks[index] = result.task;
    _events.add(result.event);
    _syncMonsterMood();

    notifyListeners();
  }

  void deleteTask(String taskId, {String deleteReason = 'user_delete'}) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1 || _tasks[index].status == TaskStatus.deleted) {
      return;
    }

    final result = _tasks[index].delete(
      eventId: _nextEventId(),
      deletedAt: _now(),
      deleteReason: deleteReason,
    );
    _tasks[index] = result.task;
    _events.add(result.event);
    _syncMonsterMood();

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
      restoredAt: _now(),
      restoreReason: restoreReason,
      restoredFromEventId: 'local_restore',
    );
    _tasks[index] = result.task;
    _events.add(result.event);
    _handoffTaskEvent(
      operationType: SyncOperationType.taskRestore,
      taskId: result.event.taskId,
      eventId: result.event.eventId,
      occurredAt: result.event.restoredAt,
      eventName: result.event.eventName,
      payload: result.event.payload,
    );
    _syncMonsterMood();

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
        appliedAt: _now(),
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
    DateTime? startDate,
    DateTime? dueDate,
    List<String>? childTaskTitles,
    LongTermBreakdownSource breakdownSource = LongTermBreakdownSource.manual,
  }) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return;
    }
    if (breakdownSource == LongTermBreakdownSource.ai) {
      return;
    }
    final normalizedChildTaskTitles = childTaskTitles
        ?.map((title) => title.trim())
        .toList(growable: false);
    if (normalizedChildTaskTitles == null ||
        normalizedChildTaskTitles.length < 2 ||
        normalizedChildTaskTitles.any((title) => title.isEmpty)) {
      return;
    }

    final resolvedStartDate = _dateOnly(startDate ?? today);
    final resolvedDueDate =
        dueDate ??
        resolvedStartDate.add(
          Duration(days: normalizedChildTaskTitles.length - 1),
        );
    final resolvedTaskCount =
        _dateOnly(resolvedDueDate).difference(resolvedStartDate).inDays + 1;
    if (resolvedTaskCount < 2 ||
        normalizedChildTaskTitles.length != resolvedTaskCount) {
      return;
    }

    final longTerm = LongTermTask.create(
      longTermTaskId: 'long_${_nextLongTermNumber++}',
      userId: userId,
      title: normalizedTitle,
      startDate: resolvedStartDate,
      dueDate: resolvedDueDate,
    );
    _longTermTasks.add(longTerm);
    _events.add(longTerm.toCreatedEvent(eventId: _nextEventId()));

    for (final generated in longTerm.generateChildTaskDrafts(
      childTaskTitles: normalizedChildTaskTitles,
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

  bool updateLongTermTaskPlan(
    String longTermTaskId, {
    required String title,
    required DateTime startDate,
    required DateTime dueDate,
    required List<String> childTaskTitles,
  }) {
    final longTermIndex = _longTermTasks.indexWhere(
      (task) => task.longTermTaskId == longTermTaskId,
    );
    if (longTermIndex == -1 ||
        _longTermTasks[longTermIndex].status != LongTermTaskStatus.active) {
      return false;
    }

    final normalizedTitle = title.trim();
    final normalizedChildTaskTitles = childTaskTitles
        .map((title) => title.trim())
        .toList(growable: false);
    if (normalizedTitle.isEmpty ||
        normalizedChildTaskTitles.length < 2 ||
        normalizedChildTaskTitles.any((title) => title.isEmpty)) {
      return false;
    }

    final resolvedStartDate = _dateOnly(startDate);
    final resolvedDueDate = _dateOnly(dueDate);
    final resolvedTaskCount =
        resolvedDueDate.difference(resolvedStartDate).inDays + 1;
    if (resolvedTaskCount < 2 ||
        normalizedChildTaskTitles.length != resolvedTaskCount) {
      return false;
    }

    final newDates = List<DateTime>.generate(
      resolvedTaskCount,
      (index) => resolvedStartDate.add(Duration(days: index)),
      growable: false,
    );
    final childIndexes = <int>[
      for (var index = 0; index < _tasks.length; index++)
        if (_tasks[index].parentLongTermTaskId == longTermTaskId) index,
    ];
    final completedOutsideRange = childIndexes.any(
      (index) =>
          _tasks[index].isCompleted &&
          !newDates.any(
            (date) => _isSameDate(date, _tasks[index].scheduledDate),
          ),
    );
    if (completedOutsideRange) {
      return false;
    }

    for (final index in childIndexes) {
      final task = _tasks[index];
      final stillInRange = newDates.any(
        (date) => _isSameDate(date, task.scheduledDate),
      );
      if (!stillInRange && task.status == TaskStatus.active) {
        final result = task.cancel(
          eventId: _nextEventId(),
          cancelledAt: _now(),
          cancelReason: 'longterm_date_changed',
        );
        _tasks[index] = result.task;
        _events.add(result.event);
      }
    }

    for (var index = 0; index < newDates.length; index++) {
      final scheduledDate = newDates[index];
      final taskTitle = normalizedChildTaskTitles[index];
      final existingIndex = _tasks.indexWhere(
        (task) =>
            task.parentLongTermTaskId == longTermTaskId &&
            task.status != TaskStatus.cancelled &&
            task.status != TaskStatus.deleted &&
            _isSameDate(task.scheduledDate, scheduledDate),
      );
      if (existingIndex == -1) {
        final taskId = _uniqueLongTermChildTaskId(
          longTermTaskId,
          scheduledDate,
        );
        final draft = TaskDraft(
          title: taskTitle,
          listId: 'inbox',
          type: TaskType.longTermChild,
          scheduledDate: scheduledDate,
          dateSource: TaskDateSource.longtermGenerated,
          parentLongTermTaskId: longTermTaskId,
          rewardEligible: true,
        );
        _tasks.add(
          TaskItem.create(
            id: taskId,
            userId: userId,
            draft: draft,
            today: today,
          ),
        );
        _events.add(
          LongTermChildTaskGeneratedEvent(
            eventId: _nextEventId(),
            longTermTaskId: longTermTaskId,
            taskId: taskId,
            scheduledDate: scheduledDate,
            rewardEligible: true,
          ),
        );
      } else {
        _tasks[existingIndex] = _tasks[existingIndex].copyWith(
          title: taskTitle,
          scheduledDate: scheduledDate,
          dateSource: TaskDateSource.longtermGenerated,
        );
      }
    }

    _longTermTasks[longTermIndex] = _longTermTasks[longTermIndex].copyWith(
      title: normalizedTitle,
      startDate: resolvedStartDate,
      dueDate: resolvedDueDate,
      completedTaskCount: 0,
      progress: 0,
      status: LongTermTaskStatus.active,
    );
    _refreshLongTermProgress(longTermTaskId);

    notifyListeners();
    return true;
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
      cancelledAt: _now(),
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

  String _uniqueLongTermChildTaskId(
    String longTermTaskId,
    DateTime scheduledDate,
  ) {
    final baseTaskId =
        '${longTermTaskId}_day_${_formatDateForId(scheduledDate)}';
    if (!_tasks.any((task) => task.id == baseTaskId)) {
      return baseTaskId;
    }
    return '${baseTaskId}_${_nextTaskNumber++}';
  }

  void _grantTaskCompletionXp(TaskCompletedEvent event) {
    if (event.completionSource == CompletionSource.onboardingAuto) {
      return;
    }
    final xpAmount = XpPolicy.taskCompletionXp(
      completionOrderOfDay: event.completionOrderOfDay,
      highPriority: event.priority == TaskPriority.high,
    );
    _grantXp(
      sourceEventId: event.eventId,
      sourceType: XpSourceType.taskCompleted,
      rawAmount: xpAmount,
      localDate: event.completedLocalDate,
      dailyCapApplied: true,
      createdAt: event.completedAt,
    );
  }

  void _revertXpForCompletion(
    String originalCompletedEventId, {
    required String revertEventId,
    required DateTime revertedAt,
  }) {
    final original = _xpLedger
        .where((entry) => entry.sourceEventId == originalCompletedEventId)
        .firstOrNull;
    if (original == null || original.amount <= 0) {
      return;
    }
    final alreadyReverted = _xpLedger.any(
      (entry) =>
          entry.sourceType == XpSourceType.xpReverted &&
          entry.originalXpLedgerId == original.xpLedgerId,
    );
    if (alreadyReverted) {
      return;
    }

    final nextTodayXp = (_todayXp - original.amount).clamp(0, 1 << 31).toInt();
    _xpLedger.add(
      XpLedgerEntry(
        xpLedgerId: 'xp_${_nextXpLedgerNumber++}',
        userId: userId,
        sourceEventId: revertEventId,
        sourceType: XpSourceType.xpReverted,
        originalXpLedgerId: original.xpLedgerId,
        amount: -original.amount,
        localDate: original.localDate,
        timezoneId: timezoneId,
        dailyCapApplied: true,
        dailyTotalAfterGrant: nextTodayXp,
        reason: 'undo_completion',
        createdAt: revertedAt,
      ),
    );
    _todayXp = nextTodayXp;
    _rebuildMonsterFromXp();
  }

  XpLedgerEntry? _grantXp({
    required String sourceEventId,
    required XpSourceType sourceType,
    required int rawAmount,
    required DateTime localDate,
    required bool dailyCapApplied,
    required DateTime createdAt,
    String? reason,
  }) {
    final alreadyGranted = _xpLedger.any(
      (entry) =>
          entry.sourceType != XpSourceType.xpReverted &&
          entry.sourceEventId == sourceEventId,
    );
    if (alreadyGranted) {
      return null;
    }

    final amount = dailyCapApplied
        ? XpPolicy.capFormalXp(currentDailyXp: _todayXp, rawAmount: rawAmount)
        : rawAmount;
    final nextTodayXp = dailyCapApplied ? _todayXp + amount : _todayXp;
    final ledgerEntry = XpLedgerEntry(
      xpLedgerId: 'xp_${_nextXpLedgerNumber++}',
      userId: userId,
      sourceEventId: sourceEventId,
      sourceType: sourceType,
      amount: amount,
      localDate: _dateOnly(localDate),
      timezoneId: timezoneId,
      dailyCapApplied: dailyCapApplied,
      dailyTotalAfterGrant: nextTodayXp,
      reason: reason,
      createdAt: createdAt,
    );
    _xpLedger.add(ledgerEntry);
    _todayXp = nextTodayXp;
    final beforeLevel = monster.level;
    _rebuildMonsterFromXp(actionKey: _xpActionKey(sourceType, amount));
    if (amount > 0 && monster.level > beforeLevel) {
      _events.add(
        LevelUpEvent(
          monsterId: monster.monsterId,
          fromLevel: beforeLevel,
          toLevel: monster.level,
          occurredAt: createdAt,
        ),
      );
      monster = monster.copyWith(currentAction: 'level_up');
    }
    return ledgerEntry;
  }

  @visibleForTesting
  XpLedgerEntry? grantXpForTesting({
    required String sourceEventId,
    required XpSourceType sourceType,
    required int rawAmount,
    DateTime? localDate,
    bool dailyCapApplied = true,
  }) {
    return _grantXp(
      sourceEventId: sourceEventId,
      sourceType: sourceType,
      rawAmount: rawAmount,
      localDate: localDate ?? today,
      dailyCapApplied: dailyCapApplied,
      createdAt: _now(),
    );
  }

  void _rebuildMonsterFromXp({String? actionKey}) {
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
    _syncMonsterMood(actionKey: actionKey ?? monster.currentAction);
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
    final formalCompletedChildIds = _tasks
        .where(
          (task) =>
              task.parentLongTermTaskId == longTermTaskId &&
              _isFormalCompletedTask(task),
        )
        .map((task) => task.id)
        .toList();

    final result = _longTermTasks[index].recordChildCompletion(
      eventId: _nextEventId(),
      completedTaskCount: completedChildIds.length,
      changedAt: _now(),
      sourceCompletedTaskIds: completedChildIds,
    );
    _longTermTasks[index] = result.task;
    _events.add(result.progressEvent);
    if (result.achievementEvent != null) {
      _events.add(result.achievementEvent!);
      if (formalCompletedChildIds.length ==
              result.achievementEvent!.totalTaskCount &&
          _longTermRewardedTaskIds.add(longTermTaskId)) {
        _grantXp(
          sourceEventId: result.achievementEvent!.eventId,
          sourceType: XpSourceType.longtermAchieved,
          rawAmount: XpPolicy.longTermAchievedXp,
          localDate: today,
          dailyCapApplied: false,
          createdAt: result.achievementEvent!.achievedAt,
        );
      }
    }
  }

  void _refreshMilestone() {
    final milestone = DailyTaskMilestone.fromCompletedCount(
      completedEligibleTaskCount: completedRewardableCountForDate(today),
      localDate: today,
      timezoneId: timezoneId,
    );
    if (milestone == null) {
      _latestMilestone = null;
      return;
    }
    final milestoneKey =
        '${_formatDateKey(milestone.localDate)}:${milestone.milestoneKey}';
    if (_shownMilestoneKeys.add(milestoneKey)) {
      _events.add(milestone);
      _latestMilestone = milestone;
    } else {
      _latestMilestone = milestone;
    }
  }

  void _recordActiveDay(DateTime localDate) {
    final result = _streak.recordActiveDay(localDate);
    _streak = result.streak;
    if (result.breakEvent != null) {
      _events.add(result.breakEvent!);
    }
    if (result.updatedEvent != null) {
      _events.add(result.updatedEvent!);
    }
  }

  void _rebuildStreakFromActivity() {
    var rebuilt = StreakSnapshot.empty(timezoneId: timezoneId);
    final dates = _activeDateKeys().map(_parseDateKey).toList()..sort();
    for (final date in dates) {
      rebuilt = rebuilt.recordActiveDay(date).streak;
    }
    _streak = rebuilt;
  }

  void _maybeGrantCumulativeActiveReward(DateTime localDate) {
    final activeDays = activeDayCount;
    if (activeDays < XpPolicy.cumulativeActiveRewardThreshold ||
        !_grantedCumulativeRewardThresholds.add(
          XpPolicy.cumulativeActiveRewardThreshold,
        )) {
      return;
    }

    final rewardEvent = CumulativeActiveRewardEvent(
      eventId: _nextEventId(),
      activeDayCount: activeDays,
      rewardThreshold: XpPolicy.cumulativeActiveRewardThreshold,
      xpAmount: XpPolicy.cumulativeActiveRewardXp,
      rewardReason: 'fourth_active_day',
    );
    _latestCumulativeReward = rewardEvent;
    _events.add(rewardEvent);
    _grantXp(
      sourceEventId: rewardEvent.eventId,
      sourceType: XpSourceType.cumulativeActiveReward,
      rawAmount: rewardEvent.xpAmount,
      localDate: localDate,
      dailyCapApplied: true,
      createdAt: _now(),
      reason: rewardEvent.rewardReason,
    );
  }

  void _incrementCreatedTaskCount(DateTime localDate) {
    final key = _formatDateKey(_dateOnly(localDate));
    _seedCreatedTaskCounts[key] = (_seedCreatedTaskCounts[key] ?? 0) + 1;
  }

  int _createdTaskCountForDate(DateTime localDate) {
    return _seedCreatedTaskCounts[_formatDateKey(_dateOnly(localDate))] ?? 0;
  }

  Set<String> _activeDateKeys() {
    final keys = <String>{};
    for (final entry in _seedCompletedEligibleCounts.entries) {
      if (entry.value > 0) {
        keys.add(entry.key);
      }
    }
    for (final task in _tasks) {
      if (_isFormalCompletedTask(task) && task.completedAt != null) {
        keys.add(_formatDateKey(_dateOnly(task.completedAt!)));
      }
    }
    return keys;
  }

  bool _isFormalCompletedTask(TaskItem task) {
    return task.isCompleted &&
        task.rewardEligible &&
        task.completionSource != CompletionSource.onboardingAuto;
  }

  void _syncMonsterMood({String? actionKey}) {
    final now = _now();
    final mood = _resolveMonsterMood(now);
    monster = monster.copyWith(
      moodState: mood,
      currentAction: actionKey ?? _defaultActionKey(mood),
      sleepPetCount: _sleepPetCount,
    );
  }

  void _handoffTaskEvent({
    required SyncOperationType operationType,
    required String taskId,
    required String eventId,
    required DateTime occurredAt,
    required String eventName,
    required Map<String, Object?> payload,
  }) {
    final operation = SyncQueueDraft(
      operationType: operationType,
      entityType: 'task',
      entityId: taskId,
      eventId: eventId,
      operationId: eventId,
      sourceEventId: eventId,
      enqueuedAt: occurredAt,
      payload: <String, Object?>{'eventName': eventName, ...payload},
    );
    _syncHandoffOperations.add(operation);

    final handoff = syncHandoff;
    if (handoff == null) {
      return;
    }

    unawaited(
      Future<void>.microtask(
        () => handoff(operation),
      ).catchError((Object _) {}),
    );
  }

  MonsterMood _resolveMonsterMood(DateTime now) {
    if (_missingActive) {
      return MonsterMood.missing;
    }
    if (_isSleepingAt(now) && !_isWakeOverrideActive(now)) {
      return MonsterMood.sleeping;
    }
    if (activeTasks.isNotEmpty) {
      return MonsterMood.expecting;
    }
    if (completedRewardableCountForDate(today) > 0) {
      return MonsterMood.energetic;
    }
    return MonsterMood.idle;
  }

  String _defaultActionKey(MonsterMood mood) {
    return switch (mood) {
      MonsterMood.idle => 'idle_01',
      MonsterMood.energetic => 'happy_01',
      MonsterMood.expecting => 'idle_02',
      MonsterMood.sleeping => 'sleep',
      MonsterMood.missing => 'missing',
    };
  }

  String? _xpActionKey(XpSourceType sourceType, int amount) {
    if (amount <= 0) {
      return null;
    }
    return switch (sourceType) {
      XpSourceType.taskCompleted => 'eat',
      XpSourceType.longtermAchieved => 'happy_01',
      XpSourceType.cumulativeActiveReward => 'task_milestone',
      XpSourceType.xpReverted => null,
    };
  }

  bool _isSleepingAt(DateTime value) => value.hour >= 23 || value.hour < 7;

  bool _isWakeOverrideActive(DateTime value) {
    final wakeOverrideUntil = _wakeOverrideUntil;
    return wakeOverrideUntil != null && value.isBefore(wakeOverrideUntil);
  }

  DateTime _now() => _fixedNow ?? DateTime.now();

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

String _formatDateForId(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}$month$day';
}

String _formatDateKey(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

DateTime _parseDateKey(String value) {
  final parts = value.split('-');
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}
