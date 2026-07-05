enum TaskStatus { active, completed, cancelled, deleted }

enum TaskType { normal, longTermChild }

enum TaskPriority { high, medium, none }

enum TaskListType { inbox, custom }

enum TaskDateSource {
  defaultToday,
  userSelected,
  longtermGenerated,
  naturalLanguage,
}

enum CompletionSource { userAction, onboardingAuto, syncReplay }

enum BatchCleanupAction { letGo, moveToday, moveInbox }

enum LongTermTaskStatus { active, achieved, cancelled, deleted }

extension TaskStatusContractName on TaskStatus {
  String get contractName {
    return switch (this) {
      TaskStatus.active => 'active',
      TaskStatus.completed => 'completed',
      TaskStatus.cancelled => 'cancelled',
      TaskStatus.deleted => 'deleted',
    };
  }
}

extension TaskTypeContractName on TaskType {
  String get contractName {
    return switch (this) {
      TaskType.normal => 'normal',
      TaskType.longTermChild => 'long_term_child',
    };
  }
}

extension TaskPriorityContractName on TaskPriority {
  String get contractName {
    return switch (this) {
      TaskPriority.high => 'high',
      TaskPriority.medium => 'medium',
      TaskPriority.none => 'none',
    };
  }
}

extension TaskListTypeContractName on TaskListType {
  String get contractName {
    return switch (this) {
      TaskListType.inbox => 'inbox',
      TaskListType.custom => 'custom',
    };
  }
}

extension TaskDateSourceContractName on TaskDateSource {
  String get contractName {
    return switch (this) {
      TaskDateSource.defaultToday => 'default_today',
      TaskDateSource.userSelected => 'user_selected',
      TaskDateSource.longtermGenerated => 'longterm_generated',
      TaskDateSource.naturalLanguage => 'natural_language',
    };
  }
}

extension CompletionSourceContractName on CompletionSource {
  String get contractName {
    return switch (this) {
      CompletionSource.userAction => 'user_action',
      CompletionSource.onboardingAuto => 'onboarding_auto',
      CompletionSource.syncReplay => 'sync_replay',
    };
  }
}

extension BatchCleanupActionContractName on BatchCleanupAction {
  String get contractName {
    return switch (this) {
      BatchCleanupAction.letGo => 'let_go',
      BatchCleanupAction.moveToday => 'move_today',
      BatchCleanupAction.moveInbox => 'move_inbox',
    };
  }
}

extension LongTermTaskStatusContractName on LongTermTaskStatus {
  String get contractName {
    return switch (this) {
      LongTermTaskStatus.active => 'active',
      LongTermTaskStatus.achieved => 'achieved',
      LongTermTaskStatus.cancelled => 'cancelled',
      LongTermTaskStatus.deleted => 'deleted',
    };
  }
}

class TaskList {
  const TaskList({
    required this.listId,
    required this.userId,
    required this.listType,
    required this.name,
    required this.color,
    required this.icon,
    required this.sortOrder,
    required this.isSystem,
  });

  const TaskList.systemInbox({required String userId})
    : this(
        listId: 'inbox',
        userId: userId,
        listType: TaskListType.inbox,
        name: '收集箱',
        color: 'blue',
        icon: 'inbox',
        sortOrder: 0,
        isSystem: true,
      );

  final String listId;
  final String userId;
  final TaskListType listType;
  final String name;
  final String color;
  final String icon;
  final int sortOrder;
  final bool isSystem;
}

class TaskDraft {
  const TaskDraft({
    required this.title,
    this.listId = 'inbox',
    this.type = TaskType.normal,
    this.priority = TaskPriority.none,
    this.scheduledDate,
    this.dateSource,
    this.dueTime,
    this.reminderId,
    this.repeatRuleId,
    this.parentLongTermTaskId,
    this.rewardEligible = true,
  });

  final String title;
  final String listId;
  final TaskType type;
  final TaskPriority priority;
  final DateTime? scheduledDate;
  final TaskDateSource? dateSource;
  final String? dueTime;
  final String? reminderId;
  final String? repeatRuleId;
  final String? parentLongTermTaskId;
  final bool rewardEligible;

  bool get canCreate => title.trim().isNotEmpty;
}

class TaskItem {
  const TaskItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.listId,
    required this.type,
    required this.status,
    required this.priority,
    required this.scheduledDate,
    required this.dateSource,
    this.dueTime,
    this.reminderId,
    this.repeatRuleId,
    this.parentLongTermTaskId,
    required this.rewardEligible,
    this.completedAt,
    this.completionSource,
    this.completedEventId,
    this.cancelledAt,
    this.deletedAt,
    this.restoredAt,
  });

  factory TaskItem.create({
    required String id,
    required String userId,
    required TaskDraft draft,
    required DateTime today,
  }) {
    final scheduledDate = draft.scheduledDate ?? _dateOnly(today);

    return TaskItem(
      id: id,
      userId: userId,
      title: draft.title.trim(),
      listId: draft.listId,
      type: draft.type,
      status: TaskStatus.active,
      priority: draft.priority,
      scheduledDate: scheduledDate,
      dateSource:
          draft.dateSource ??
          (draft.scheduledDate == null
              ? TaskDateSource.defaultToday
              : TaskDateSource.userSelected),
      dueTime: draft.dueTime,
      reminderId: draft.reminderId,
      repeatRuleId: draft.repeatRuleId,
      parentLongTermTaskId: draft.parentLongTermTaskId,
      rewardEligible: draft.rewardEligible,
    );
  }

  final String id;
  final String userId;
  final String title;
  final String listId;
  final TaskType type;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime scheduledDate;
  final TaskDateSource dateSource;
  final String? dueTime;
  final String? reminderId;
  final String? repeatRuleId;
  final String? parentLongTermTaskId;
  final bool rewardEligible;
  final DateTime? completedAt;
  final CompletionSource? completionSource;
  final String? completedEventId;
  final DateTime? cancelledAt;
  final DateTime? deletedAt;
  final DateTime? restoredAt;

  bool get isCompleted => status == TaskStatus.completed;
  bool get isActive => status == TaskStatus.active;
  bool get isVisible => status != TaskStatus.deleted;

  TaskCreatedEvent toCreatedEvent({
    required String eventId,
    required DateTime createdAt,
  }) {
    return TaskCreatedEvent(
      eventId: eventId,
      taskId: id,
      title: title,
      taskType: type,
      listId: listId,
      scheduledDate: scheduledDate,
      dateSource: dateSource,
      priority: priority,
      rewardEligible: rewardEligible,
      createdAt: createdAt,
    );
  }

  TaskCompletionResult complete({
    required String eventId,
    required DateTime completedAt,
    required String timezoneId,
    required int completionOrderOfDay,
    required int dailyRewardableCountAfter,
    required int dailyTodayTaskCountAfter,
    CompletionSource completionSource = CompletionSource.userAction,
  }) {
    if (status != TaskStatus.active) {
      throw StateError('Only active tasks can be completed.');
    }

    final completedTask = copyWith(
      status: TaskStatus.completed,
      completedAt: completedAt,
      completionSource: completionSource,
      completedEventId: eventId,
    );

    return TaskCompletionResult(
      task: completedTask,
      event: TaskCompletedEvent(
        eventId: eventId,
        taskId: id,
        taskType: type,
        completedAt: completedAt,
        completedLocalDate: _dateOnly(completedAt),
        timezoneId: timezoneId,
        priority: priority,
        scheduledDate: scheduledDate,
        parentLongTermTaskId: parentLongTermTaskId,
        rewardEligible: rewardEligible,
        completionSource: completionSource,
        completionOrderOfDay: completionOrderOfDay,
        dailyRewardableCountAfter: dailyRewardableCountAfter,
        dailyTodayTaskCountAfter: dailyTodayTaskCountAfter,
        thresholdCrossed: _thresholdForCompletedCount(
          dailyRewardableCountAfter,
        ),
      ),
    );
  }

  TaskCompletionUndoneResult undoCompletion({
    required String eventId,
    required DateTime undoneAt,
    required String? thresholdReverted,
  }) {
    if (status != TaskStatus.completed || completedAt == null) {
      throw StateError('Only completed tasks can have completion undone.');
    }

    final originalEventId = completedEventId;
    if (originalEventId == null) {
      throw StateError('Completed task is missing original event id.');
    }

    final activeTask = copyWith(
      status: TaskStatus.active,
      clearCompletedAt: true,
      clearCompletionSource: true,
      clearCompletedEventId: true,
    );

    return TaskCompletionUndoneResult(
      task: activeTask,
      event: TaskCompletionUndoneEvent(
        eventId: eventId,
        taskId: id,
        undoneAt: undoneAt,
        previousCompletedAt: completedAt!,
        originalCompletedEventId: originalEventId,
        thresholdReverted: thresholdReverted,
      ),
    );
  }

  TaskCancelledResult cancel({
    required String eventId,
    required DateTime cancelledAt,
    required String cancelReason,
  }) {
    if (status == TaskStatus.completed) {
      throw StateError('Completed tasks must be undone before cancellation.');
    }
    if (status != TaskStatus.active) {
      throw StateError('Only active tasks can be cancelled.');
    }

    final cancelledTask = copyWith(
      status: TaskStatus.cancelled,
      cancelledAt: cancelledAt,
    );

    return TaskCancelledResult(
      task: cancelledTask,
      event: TaskCancelledEvent(
        eventId: eventId,
        taskId: id,
        cancelledAt: cancelledAt,
        cancelReason: cancelReason,
      ),
    );
  }

  TaskDeletedResult delete({
    required String eventId,
    required DateTime deletedAt,
    required String deleteReason,
  }) {
    if (status == TaskStatus.deleted) {
      throw StateError('Task is already deleted.');
    }

    final previousStatus = status;
    final deletedTask = copyWith(
      status: TaskStatus.deleted,
      deletedAt: deletedAt,
    );

    return TaskDeletedResult(
      task: deletedTask,
      event: TaskDeletedEvent(
        eventId: eventId,
        taskId: id,
        deletedAt: deletedAt,
        deleteReason: deleteReason,
        previousStatus: previousStatus,
      ),
    );
  }

  TaskRestoredResult restore({
    required String eventId,
    required DateTime restoredAt,
    required String restoreReason,
    required String restoredFromEventId,
  }) {
    if (status != TaskStatus.deleted && status != TaskStatus.cancelled) {
      throw StateError('Only deleted or cancelled tasks can be restored.');
    }

    final previousStatus = status;
    final previousDeletedAt = deletedAt;
    final previousCancelledAt = cancelledAt;
    final restoredTask = copyWith(
      status: TaskStatus.active,
      restoredAt: restoredAt,
      clearDeletedAt: true,
      clearCancelledAt: true,
    );

    return TaskRestoredResult(
      task: restoredTask,
      event: TaskRestoredEvent(
        eventId: eventId,
        taskId: id,
        restoredAt: restoredAt,
        restoreReason: restoreReason,
        restoredFromEventId: restoredFromEventId,
        previousStatus: previousStatus,
        restoredStatus: TaskStatus.active,
        previousDeletedAt: previousDeletedAt,
        previousCancelledAt: previousCancelledAt,
        scheduledDate: scheduledDate,
        dateSource: dateSource,
      ),
    );
  }

  TaskRescheduledResult reschedule({
    required String eventId,
    required DateTime toScheduledDate,
    required DateTime rescheduledAt,
    String? toDueTime,
  }) {
    final fromScheduledDate = scheduledDate;
    final fromDueTime = dueTime;
    final rescheduledTask = copyWith(
      scheduledDate: _dateOnly(toScheduledDate),
      dateSource: TaskDateSource.userSelected,
      dueTime: toDueTime,
      clearDueTime: toDueTime == null,
    );

    return TaskRescheduledResult(
      task: rescheduledTask,
      event: TaskRescheduledEvent(
        eventId: eventId,
        taskId: id,
        fromScheduledDate: fromScheduledDate,
        toScheduledDate: _dateOnly(toScheduledDate),
        fromDueTime: fromDueTime,
        toDueTime: toDueTime,
        rescheduledAt: rescheduledAt,
      ),
    );
  }

  TaskItem copyWith({
    TaskStatus? status,
    String? listId,
    TaskPriority? priority,
    DateTime? scheduledDate,
    TaskDateSource? dateSource,
    String? dueTime,
    String? reminderId,
    String? repeatRuleId,
    DateTime? completedAt,
    CompletionSource? completionSource,
    String? completedEventId,
    DateTime? cancelledAt,
    DateTime? deletedAt,
    DateTime? restoredAt,
    bool clearDueTime = false,
    bool clearReminderId = false,
    bool clearRepeatRuleId = false,
    bool clearCompletedAt = false,
    bool clearCompletionSource = false,
    bool clearCompletedEventId = false,
    bool clearCancelledAt = false,
    bool clearDeletedAt = false,
  }) {
    return TaskItem(
      id: id,
      userId: userId,
      title: title,
      listId: listId ?? this.listId,
      type: type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      dateSource: dateSource ?? this.dateSource,
      dueTime: clearDueTime ? null : dueTime ?? this.dueTime,
      reminderId: clearReminderId ? null : reminderId ?? this.reminderId,
      repeatRuleId: clearRepeatRuleId
          ? null
          : repeatRuleId ?? this.repeatRuleId,
      parentLongTermTaskId: parentLongTermTaskId,
      rewardEligible: rewardEligible,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
      completionSource: clearCompletionSource
          ? null
          : completionSource ?? this.completionSource,
      completedEventId: clearCompletedEventId
          ? null
          : completedEventId ?? this.completedEventId,
      cancelledAt: clearCancelledAt ? null : cancelledAt ?? this.cancelledAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
      restoredAt: restoredAt ?? this.restoredAt,
    );
  }
}

class TaskCompletionResult {
  const TaskCompletionResult({required this.task, required this.event});

  final TaskItem task;
  final TaskCompletedEvent event;
}

class TaskCompletionUndoneResult {
  const TaskCompletionUndoneResult({required this.task, required this.event});

  final TaskItem task;
  final TaskCompletionUndoneEvent event;
}

class TaskCancelledResult {
  const TaskCancelledResult({required this.task, required this.event});

  final TaskItem task;
  final TaskCancelledEvent event;
}

class TaskDeletedResult {
  const TaskDeletedResult({required this.task, required this.event});

  final TaskItem task;
  final TaskDeletedEvent event;
}

class TaskRestoredResult {
  const TaskRestoredResult({required this.task, required this.event});

  final TaskItem task;
  final TaskRestoredEvent event;
}

class TaskRescheduledResult {
  const TaskRescheduledResult({required this.task, required this.event});

  final TaskItem task;
  final TaskRescheduledEvent event;
}

class TaskCompletedEvent {
  const TaskCompletedEvent({
    required this.eventId,
    required this.taskId,
    required this.taskType,
    required this.completedAt,
    required this.completedLocalDate,
    required this.timezoneId,
    required this.priority,
    required this.scheduledDate,
    required this.parentLongTermTaskId,
    required this.rewardEligible,
    required this.completionSource,
    required this.completionOrderOfDay,
    required this.dailyRewardableCountAfter,
    required this.dailyTodayTaskCountAfter,
    required this.thresholdCrossed,
  });

  String get eventName => 'task_completed';

  Map<String, Object?> get payload {
    return {
      'taskId': taskId,
      'taskType': taskType.contractName,
      'completedAt': completedAt.toIso8601String(),
      'completedLocalDate': _formatDate(completedLocalDate),
      'timezoneId': timezoneId,
      'priority': priority.contractName,
      'scheduledDate': _formatDate(scheduledDate),
      'parentLongTermTaskId': parentLongTermTaskId,
      'rewardEligible': rewardEligible,
      'completionSource': completionSource.contractName,
      'completionOrderOfDay': completionOrderOfDay,
      'dailyRewardableCountAfter': dailyRewardableCountAfter,
      'dailyTodayTaskCountAfter': dailyTodayTaskCountAfter,
      'thresholdCrossed': thresholdCrossed,
    };
  }

  final String eventId;
  final String taskId;
  final TaskType taskType;
  final DateTime completedAt;
  final DateTime completedLocalDate;
  final String timezoneId;
  final TaskPriority priority;
  final DateTime scheduledDate;
  final String? parentLongTermTaskId;
  final bool rewardEligible;
  final CompletionSource completionSource;
  final int completionOrderOfDay;
  final int dailyRewardableCountAfter;
  final int dailyTodayTaskCountAfter;
  final String? thresholdCrossed;
}

class TaskCreatedEvent {
  const TaskCreatedEvent({
    required this.eventId,
    required this.taskId,
    required this.title,
    required this.taskType,
    required this.listId,
    required this.scheduledDate,
    required this.dateSource,
    required this.priority,
    required this.rewardEligible,
    required this.createdAt,
  });

  String get eventName => 'task_created';

  Map<String, Object?> get payload {
    return {
      'taskId': taskId,
      'title': title,
      'taskType': taskType.contractName,
      'listId': listId,
      'scheduledDate': _formatDate(scheduledDate),
      'dateSource': dateSource.contractName,
      'priority': priority.contractName,
      'rewardEligible': rewardEligible,
    };
  }

  final String eventId;
  final String taskId;
  final String title;
  final TaskType taskType;
  final String listId;
  final DateTime scheduledDate;
  final TaskDateSource dateSource;
  final TaskPriority priority;
  final bool rewardEligible;
  final DateTime createdAt;
}

class TaskCompletionUndoneEvent {
  const TaskCompletionUndoneEvent({
    required this.eventId,
    required this.taskId,
    required this.undoneAt,
    required this.previousCompletedAt,
    required this.originalCompletedEventId,
    required this.thresholdReverted,
  });

  String get eventName => 'task_completion_undone';

  Map<String, Object?> get payload {
    return {
      'taskId': taskId,
      'undoneAt': undoneAt.toIso8601String(),
      'previousCompletedAt': previousCompletedAt.toIso8601String(),
      'originalCompletedEventId': originalCompletedEventId,
      'thresholdReverted': thresholdReverted,
    };
  }

  final String eventId;
  final String taskId;
  final DateTime undoneAt;
  final DateTime previousCompletedAt;
  final String originalCompletedEventId;
  final String? thresholdReverted;
}

class TaskCancelledEvent {
  const TaskCancelledEvent({
    required this.eventId,
    required this.taskId,
    required this.cancelledAt,
    required this.cancelReason,
  });

  String get eventName => 'task_cancelled';

  Map<String, Object?> get payload {
    return {
      'taskId': taskId,
      'cancelledAt': cancelledAt.toIso8601String(),
      'cancelReason': cancelReason,
    };
  }

  final String eventId;
  final String taskId;
  final DateTime cancelledAt;
  final String cancelReason;
}

class TaskDeletedEvent {
  const TaskDeletedEvent({
    required this.eventId,
    required this.taskId,
    required this.deletedAt,
    required this.deleteReason,
    required this.previousStatus,
  });

  String get eventName => 'task_deleted';

  Map<String, Object?> get payload {
    return {
      'taskId': taskId,
      'deletedAt': deletedAt.toIso8601String(),
      'deleteReason': deleteReason,
      'previousStatus': previousStatus.contractName,
    };
  }

  final String eventId;
  final String taskId;
  final DateTime deletedAt;
  final String deleteReason;
  final TaskStatus previousStatus;
}

class TaskRestoredEvent {
  const TaskRestoredEvent({
    required this.eventId,
    required this.taskId,
    required this.restoredAt,
    required this.restoreReason,
    required this.restoredFromEventId,
    required this.previousStatus,
    required this.restoredStatus,
    required this.previousDeletedAt,
    required this.previousCancelledAt,
    required this.scheduledDate,
    required this.dateSource,
  });

  String get eventName => 'task_restored';

  Map<String, Object?> get payload {
    return {
      'taskId': taskId,
      'restoredAt': restoredAt.toIso8601String(),
      'restoreReason': restoreReason,
      'restoredFromEventId': restoredFromEventId,
      'previousStatus': previousStatus.contractName,
      'restoredStatus': restoredStatus.contractName,
      'previousDeletedAt': previousDeletedAt?.toIso8601String(),
      'previousCancelledAt': previousCancelledAt?.toIso8601String(),
      'scheduledDate': _formatDate(scheduledDate),
      'dateSource': dateSource.contractName,
    };
  }

  final String eventId;
  final String taskId;
  final DateTime restoredAt;
  final String restoreReason;
  final String restoredFromEventId;
  final TaskStatus previousStatus;
  final TaskStatus restoredStatus;
  final DateTime? previousDeletedAt;
  final DateTime? previousCancelledAt;
  final DateTime scheduledDate;
  final TaskDateSource dateSource;
}

class TaskRescheduledEvent {
  const TaskRescheduledEvent({
    required this.eventId,
    required this.taskId,
    required this.fromScheduledDate,
    required this.toScheduledDate,
    required this.fromDueTime,
    required this.toDueTime,
    required this.rescheduledAt,
  });

  String get eventName => 'task_rescheduled';

  Map<String, Object?> get payload {
    return {
      'taskId': taskId,
      'fromScheduledDate': _formatDate(fromScheduledDate),
      'toScheduledDate': _formatDate(toScheduledDate),
      'fromDueTime': fromDueTime,
      'toDueTime': toDueTime,
      'rescheduledAt': rescheduledAt.toIso8601String(),
    };
  }

  final String eventId;
  final String taskId;
  final DateTime fromScheduledDate;
  final DateTime toScheduledDate;
  final String? fromDueTime;
  final String? toDueTime;
  final DateTime rescheduledAt;
}

class BatchCleanupAppliedEvent {
  const BatchCleanupAppliedEvent({
    required this.batchId,
    required this.action,
    required this.affectedTaskIds,
    required this.appliedAt,
  });

  String get eventName => 'batch_cleanup_applied';

  Map<String, Object?> get payload {
    return {
      'batchId': batchId,
      'action': action.contractName,
      'affectedTaskIds': affectedTaskIds,
      'affectedCount': affectedTaskIds.length,
      'appliedAt': appliedAt.toIso8601String(),
    };
  }

  final String batchId;
  final BatchCleanupAction action;
  final List<String> affectedTaskIds;
  final DateTime appliedAt;
}

class ReminderIntent {
  const ReminderIntent({
    required this.reminderId,
    required this.taskId,
    required this.plannedAt,
    required this.deliverAt,
    this.offsetMinutes = 0,
    this.respectDnd = true,
  });

  factory ReminderIntent.tonight({
    required String reminderId,
    required String taskId,
    required DateTime localNow,
  }) {
    final tonight = DateTime(localNow.year, localNow.month, localNow.day, 20);
    final plannedAt = localNow.isAfter(tonight)
        ? localNow.add(const Duration(hours: 1))
        : tonight;

    return ReminderIntent(
      reminderId: reminderId,
      taskId: taskId,
      plannedAt: plannedAt,
      deliverAt: plannedAt,
    );
  }

  factory ReminderIntent.localTime({
    required String reminderId,
    required String taskId,
    required DateTime localDate,
    required String timeOfDay,
  }) {
    final minutes = _parseTimeOfDay(timeOfDay);
    final plannedAt = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
      minutes ~/ 60,
      minutes % 60,
    );

    return ReminderIntent(
      reminderId: reminderId,
      taskId: taskId,
      plannedAt: plannedAt,
      deliverAt: plannedAt,
    );
  }

  String get eventName => 'notification_scheduled';

  Map<String, Object?> get payload {
    return {
      'notificationId': 'local_$reminderId',
      'reminderId': reminderId,
      'taskId': taskId,
      'plannedAt': plannedAt.toIso8601String(),
      'deliverAt': deliverAt.toIso8601String(),
      'respectDnd': respectDnd,
    };
  }

  final String reminderId;
  final String taskId;
  final DateTime plannedAt;
  final DateTime deliverAt;
  final int offsetMinutes;
  final bool respectDnd;
}

int _parseTimeOfDay(String timeOfDay) {
  final match = RegExp(
    r'^([01]?\d|2[0-3]):([0-5]\d)$',
  ).firstMatch(timeOfDay.trim());
  if (match == null) {
    throw ArgumentError.value(
      timeOfDay,
      'timeOfDay',
      'Expected a local time in HH:mm format.',
    );
  }

  final hour = int.parse(match.group(1)!);
  final minute = int.parse(match.group(2)!);
  return hour * 60 + minute;
}

class LongTermTask {
  const LongTermTask({
    required this.longTermTaskId,
    required this.userId,
    required this.title,
    required this.startDate,
    required this.dueDate,
    required this.status,
    required this.totalTaskCount,
    required this.completedTaskCount,
    required this.progress,
    this.achievedAt,
    this.cancelledAt,
  });

  factory LongTermTask.create({
    required String longTermTaskId,
    required String userId,
    required String title,
    required DateTime startDate,
    required DateTime dueDate,
  }) {
    final start = _dateOnly(startDate);
    final due = _dateOnly(dueDate);
    if (!due.isAfter(start)) {
      throw ArgumentError.value(
        dueDate,
        'dueDate',
        'Long-term tasks must span more than one day.',
      );
    }

    final totalTaskCount = due.difference(start).inDays + 1;
    return LongTermTask(
      longTermTaskId: longTermTaskId,
      userId: userId,
      title: title.trim(),
      startDate: start,
      dueDate: due,
      status: LongTermTaskStatus.active,
      totalTaskCount: totalTaskCount,
      completedTaskCount: 0,
      progress: 0,
    );
  }

  final String longTermTaskId;
  final String userId;
  final String title;
  final DateTime startDate;
  final DateTime dueDate;
  final LongTermTaskStatus status;
  final int totalTaskCount;
  final int completedTaskCount;
  final double progress;
  final DateTime? achievedAt;
  final DateTime? cancelledAt;

  bool get canCompleteDirectly => false;

  LongTermCreatedEvent toCreatedEvent({required String eventId}) {
    return LongTermCreatedEvent(
      eventId: eventId,
      longTermTaskId: longTermTaskId,
      title: title,
      startDate: startDate,
      dueDate: dueDate,
    );
  }

  List<LongTermChildTaskDraft> generateChildTaskDrafts({
    String listId = 'inbox',
    List<String>? childTaskTitles,
  }) {
    if (childTaskTitles != null && childTaskTitles.length != totalTaskCount) {
      throw ArgumentError.value(
        childTaskTitles,
        'childTaskTitles',
        'Child task titles must match the long-term task duration.',
      );
    }

    return List.generate(totalTaskCount, (index) {
      final scheduledDate = startDate.add(Duration(days: index));
      final taskId = '${longTermTaskId}_day_${index + 1}';
      final childTitle = childTaskTitles?[index].trim();
      if (childTaskTitles != null &&
          (childTitle == null || childTitle.isEmpty)) {
        throw ArgumentError.value(
          childTaskTitles,
          'childTaskTitles',
          'Child task titles cannot be blank.',
        );
      }

      return LongTermChildTaskDraft(
        taskId: taskId,
        draft: TaskDraft(
          title: childTitle ?? '$title 第 ${index + 1} 天',
          listId: listId,
          type: TaskType.longTermChild,
          scheduledDate: scheduledDate,
          dateSource: TaskDateSource.longtermGenerated,
          parentLongTermTaskId: longTermTaskId,
          rewardEligible: true,
        ),
        event: LongTermChildTaskGeneratedEvent(
          eventId: 'evt_${taskId}_generated',
          longTermTaskId: longTermTaskId,
          taskId: taskId,
          scheduledDate: scheduledDate,
          rewardEligible: true,
        ),
      );
    });
  }

  LongTermProgressResult recordChildCompletion({
    required String eventId,
    required int completedTaskCount,
    required DateTime changedAt,
    List<String> sourceCompletedTaskIds = const [],
  }) {
    if (completedTaskCount < 0 || completedTaskCount > totalTaskCount) {
      throw ArgumentError.value(
        completedTaskCount,
        'completedTaskCount',
        'Completed count must be within total task count.',
      );
    }

    final nextProgress = completedTaskCount / totalTaskCount;
    final achieved = completedTaskCount == totalTaskCount;
    final nextTask = copyWith(
      status: achieved
          ? LongTermTaskStatus.achieved
          : LongTermTaskStatus.active,
      completedTaskCount: completedTaskCount,
      progress: nextProgress,
      achievedAt: achieved ? changedAt : null,
    );

    return LongTermProgressResult(
      task: nextTask,
      progressEvent: LongTermProgressChangedEvent(
        eventId: eventId,
        longTermTaskId: longTermTaskId,
        completedTaskCount: completedTaskCount,
        totalTaskCount: totalTaskCount,
        progress: nextProgress,
      ),
      achievementEvent: achieved
          ? LongTermAchievedEvent(
              eventId: '${eventId}_achieved',
              longTermTaskId: longTermTaskId,
              achievedAt: changedAt,
              completedTaskCount: completedTaskCount,
              totalTaskCount: totalTaskCount,
              sourceCompletedTaskIds: sourceCompletedTaskIds,
            )
          : null,
    );
  }

  LongTermCancelledResult cancel({
    required String eventId,
    required DateTime cancelledAt,
    required String cancelReason,
  }) {
    if (status != LongTermTaskStatus.active) {
      throw StateError('Only active long-term tasks can be cancelled.');
    }

    return LongTermCancelledResult(
      task: copyWith(
        status: LongTermTaskStatus.cancelled,
        cancelledAt: cancelledAt,
      ),
      event: LongTermCancelledEvent(
        eventId: eventId,
        longTermTaskId: longTermTaskId,
        cancelledAt: cancelledAt,
        cancelReason: cancelReason,
      ),
    );
  }

  LongTermTask copyWith({
    LongTermTaskStatus? status,
    int? completedTaskCount,
    double? progress,
    DateTime? achievedAt,
    DateTime? cancelledAt,
  }) {
    return LongTermTask(
      longTermTaskId: longTermTaskId,
      userId: userId,
      title: title,
      startDate: startDate,
      dueDate: dueDate,
      status: status ?? this.status,
      totalTaskCount: totalTaskCount,
      completedTaskCount: completedTaskCount ?? this.completedTaskCount,
      progress: progress ?? this.progress,
      achievedAt: achievedAt ?? this.achievedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }
}

class LongTermChildTaskDraft {
  const LongTermChildTaskDraft({
    required this.taskId,
    required this.draft,
    required this.event,
  });

  final String taskId;
  final TaskDraft draft;
  final LongTermChildTaskGeneratedEvent event;
}

class LongTermProgressResult {
  const LongTermProgressResult({
    required this.task,
    required this.progressEvent,
    required this.achievementEvent,
  });

  final LongTermTask task;
  final LongTermProgressChangedEvent progressEvent;
  final LongTermAchievedEvent? achievementEvent;
}

class LongTermCancelledResult {
  const LongTermCancelledResult({required this.task, required this.event});

  final LongTermTask task;
  final LongTermCancelledEvent event;
}

class LongTermCreatedEvent {
  const LongTermCreatedEvent({
    required this.eventId,
    required this.longTermTaskId,
    required this.title,
    required this.startDate,
    required this.dueDate,
  });

  String get eventName => 'longterm_created';

  Map<String, Object?> get payload {
    return {
      'longTermTaskId': longTermTaskId,
      'title': title,
      'startDate': _formatDate(startDate),
      'dueDate': _formatDate(dueDate),
    };
  }

  final String eventId;
  final String longTermTaskId;
  final String title;
  final DateTime startDate;
  final DateTime dueDate;
}

class LongTermChildTaskGeneratedEvent {
  const LongTermChildTaskGeneratedEvent({
    required this.eventId,
    required this.longTermTaskId,
    required this.taskId,
    required this.scheduledDate,
    required this.rewardEligible,
  });

  String get eventName => 'longterm_child_task_generated';

  Map<String, Object?> get payload {
    return {
      'longTermTaskId': longTermTaskId,
      'taskId': taskId,
      'scheduledDate': _formatDate(scheduledDate),
      'rewardEligible': rewardEligible,
    };
  }

  final String eventId;
  final String longTermTaskId;
  final String taskId;
  final DateTime scheduledDate;
  final bool rewardEligible;
}

class LongTermProgressChangedEvent {
  const LongTermProgressChangedEvent({
    required this.eventId,
    required this.longTermTaskId,
    required this.completedTaskCount,
    required this.totalTaskCount,
    required this.progress,
  });

  String get eventName => 'longterm_progress_changed';

  Map<String, Object?> get payload {
    return {
      'longTermTaskId': longTermTaskId,
      'completedTaskCount': completedTaskCount,
      'totalTaskCount': totalTaskCount,
      'progress': progress,
    };
  }

  final String eventId;
  final String longTermTaskId;
  final int completedTaskCount;
  final int totalTaskCount;
  final double progress;
}

class LongTermAchievedEvent {
  const LongTermAchievedEvent({
    required this.eventId,
    required this.longTermTaskId,
    required this.achievedAt,
    required this.completedTaskCount,
    required this.totalTaskCount,
    required this.sourceCompletedTaskIds,
  });

  String get eventName => 'longterm_achieved';

  Map<String, Object?> get payload {
    return {
      'longTermTaskId': longTermTaskId,
      'achievedAt': achievedAt.toIso8601String(),
      'completedTaskCount': completedTaskCount,
      'totalTaskCount': totalTaskCount,
      'sourceCompletedTaskIds': sourceCompletedTaskIds,
    };
  }

  final String eventId;
  final String longTermTaskId;
  final DateTime achievedAt;
  final int completedTaskCount;
  final int totalTaskCount;
  final List<String> sourceCompletedTaskIds;
}

class LongTermCancelledEvent {
  const LongTermCancelledEvent({
    required this.eventId,
    required this.longTermTaskId,
    required this.cancelledAt,
    required this.cancelReason,
  });

  String get eventName => 'longterm_cancelled';

  Map<String, Object?> get payload {
    return {
      'longTermTaskId': longTermTaskId,
      'cancelledAt': cancelledAt.toIso8601String(),
      'cancelReason': cancelReason,
    };
  }

  final String eventId;
  final String longTermTaskId;
  final DateTime cancelledAt;
  final String cancelReason;
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String? _thresholdForCompletedCount(int count) {
  return switch (count) {
    3 => 'small_start',
    6 => 'fruitful_day',
    _ => null,
  };
}
