enum TaskStatus { active, completed, cancelled, deleted }

enum TaskType { normal, longTermChild }

enum TaskPriority { high, medium, none }

enum TaskDateSource {
  defaultToday,
  userSelected,
  longtermGenerated,
  naturalLanguage,
}

enum CompletionSource { userAction, onboardingAuto, syncReplay }

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

class TaskDraft {
  const TaskDraft({
    required this.title,
    this.type = TaskType.normal,
    this.priority = TaskPriority.none,
    this.scheduledDate,
    this.dateSource,
    this.parentLongTermTaskId,
    this.rewardEligible = true,
  });

  final String title;
  final TaskType type;
  final TaskPriority priority;
  final DateTime? scheduledDate;
  final TaskDateSource? dateSource;
  final String? parentLongTermTaskId;
  final bool rewardEligible;

  bool get canCreate => title.trim().isNotEmpty;
}

class TaskItem {
  const TaskItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.status,
    required this.priority,
    required this.scheduledDate,
    required this.dateSource,
    this.parentLongTermTaskId,
    required this.rewardEligible,
    this.completedAt,
    this.completionSource,
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
      type: draft.type,
      status: TaskStatus.active,
      priority: draft.priority,
      scheduledDate: scheduledDate,
      dateSource:
          draft.dateSource ??
          (draft.scheduledDate == null
              ? TaskDateSource.defaultToday
              : TaskDateSource.userSelected),
      parentLongTermTaskId: draft.parentLongTermTaskId,
      rewardEligible: draft.rewardEligible,
    );
  }

  final String id;
  final String userId;
  final String title;
  final TaskType type;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime scheduledDate;
  final TaskDateSource dateSource;
  final String? parentLongTermTaskId;
  final bool rewardEligible;
  final DateTime? completedAt;
  final CompletionSource? completionSource;

  bool get isCompleted => status == TaskStatus.completed;

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

  TaskItem copyWith({
    TaskStatus? status,
    DateTime? completedAt,
    CompletionSource? completionSource,
  }) {
    return TaskItem(
      id: id,
      userId: userId,
      title: title,
      type: type,
      status: status ?? this.status,
      priority: priority,
      scheduledDate: scheduledDate,
      dateSource: dateSource,
      parentLongTermTaskId: parentLongTermTaskId,
      rewardEligible: rewardEligible,
      completedAt: completedAt ?? this.completedAt,
      completionSource: completionSource ?? this.completionSource,
    );
  }
}

class TaskCompletionResult {
  const TaskCompletionResult({required this.task, required this.event});

  final TaskItem task;
  final TaskCompletedEvent event;
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
