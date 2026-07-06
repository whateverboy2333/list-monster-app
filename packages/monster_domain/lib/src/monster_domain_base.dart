enum MonsterMood {
  idle('空闲'),
  energetic('元气'),
  expecting('期待'),
  sleeping('睡觉'),
  missing('想念');

  const MonsterMood(this.label);

  final String label;
}

extension MonsterMoodContractName on MonsterMood {
  String get contractName {
    return switch (this) {
      MonsterMood.idle => 'idle',
      MonsterMood.energetic => 'energetic',
      MonsterMood.expecting => 'expecting',
      MonsterMood.sleeping => 'sleeping',
      MonsterMood.missing => 'missing',
    };
  }
}

enum MonsterStage {
  egg('怪兽蛋'),
  child('幼年'),
  teen('少年'),
  adult('成年');

  const MonsterStage(this.label);

  final String label;
}

extension MonsterStageContractName on MonsterStage {
  String get contractName {
    return switch (this) {
      MonsterStage.egg => 'egg',
      MonsterStage.child => 'child',
      MonsterStage.teen => 'teen',
      MonsterStage.adult => 'adult',
    };
  }
}

enum XpSourceType {
  taskCompleted,
  longtermAchieved,
  cumulativeActiveReward,
  xpReverted,
}

extension XpSourceTypeContractName on XpSourceType {
  String get contractName {
    return switch (this) {
      XpSourceType.taskCompleted => 'task_completed',
      XpSourceType.longtermAchieved => 'longterm_achieved',
      XpSourceType.cumulativeActiveReward => 'cumulative_active_reward',
      XpSourceType.xpReverted => 'xp_reverted',
    };
  }
}

class XpGrant {
  const XpGrant({required this.sourceEventId, required this.amount});

  factory XpGrant.fromLedger(XpLedgerEntry ledgerEntry) {
    return XpGrant(
      sourceEventId: ledgerEntry.sourceEventId,
      amount: ledgerEntry.amount,
    );
  }

  final String sourceEventId;
  final int amount;

  bool get isPositive => amount > 0;
}

class XpLedgerEntry {
  const XpLedgerEntry({
    required this.xpLedgerId,
    required this.userId,
    required this.sourceEventId,
    required this.sourceType,
    this.originalXpLedgerId,
    required this.amount,
    required this.localDate,
    required this.timezoneId,
    required this.dailyCapApplied,
    required this.dailyTotalAfterGrant,
    this.reason,
    required this.createdAt,
  });

  String get eventName {
    return sourceType == XpSourceType.xpReverted ? 'xp_reverted' : 'xp_granted';
  }

  Map<String, Object?> get payload {
    if (sourceType == XpSourceType.xpReverted) {
      return {
        'xpLedgerId': xpLedgerId,
        'originalXpLedgerId': originalXpLedgerId,
        'sourceEventId': sourceEventId,
        'amount': amount,
        'revertedAt': createdAt.toIso8601String(),
        'reason': reason,
      };
    }
    return {
      'xpLedgerId': xpLedgerId,
      'sourceEventId': sourceEventId,
      'sourceType': sourceType.contractName,
      'amount': amount,
      'dailyTotalAfterGrant': dailyTotalAfterGrant,
      'dailyCapApplied': dailyCapApplied,
    };
  }

  final String xpLedgerId;
  final String userId;
  final String sourceEventId;
  final XpSourceType sourceType;
  final String? originalXpLedgerId;
  final int amount;
  final DateTime localDate;
  final String timezoneId;
  final bool dailyCapApplied;
  final int dailyTotalAfterGrant;
  final String? reason;
  final DateTime createdAt;
}

class XpPolicy {
  const XpPolicy._();

  static const int dailyFormalXpCap = 125;
  static const int cumulativeActiveRewardThreshold = 4;
  static const int cumulativeActiveRewardXp = 20;
  static const int longTermAchievedXp = 50;
  static const int sleepWakeUpThreshold = 3;

  static int taskCompletionXp({
    required int completionOrderOfDay,
    required bool highPriority,
  }) {
    if (completionOrderOfDay <= 0) {
      throw ArgumentError.value(
        completionOrderOfDay,
        'completionOrderOfDay',
        'Completion order must be positive.',
      );
    }

    if (completionOrderOfDay <= 5) {
      return highPriority ? 15 : 10;
    }

    if (completionOrderOfDay <= 10) {
      return 5;
    }

    return 1;
  }

  static int capFormalXp({
    required int currentDailyXp,
    required int rawAmount,
  }) {
    if (rawAmount <= 0) {
      return rawAmount;
    }
    final remaining = dailyFormalXpCap - currentDailyXp;
    if (remaining <= 0) {
      return 0;
    }
    return rawAmount <= remaining ? rawAmount : remaining;
  }
}

class MonsterSnapshot {
  const MonsterSnapshot({
    required this.monsterId,
    required this.userId,
    required this.name,
    required this.stage,
    required this.level,
    required this.lifetimeXp,
    required this.currentLevelXp,
    required this.xpToNextLevel,
    required this.moodState,
    this.currentAction = 'idle_01',
    this.sleepPetCount = 0,
    this.wakeUpThreshold = XpPolicy.sleepWakeUpThreshold,
  });

  factory MonsterSnapshot.initialEgg({
    required String monsterId,
    required String userId,
  }) {
    return MonsterSnapshot(
      monsterId: monsterId,
      userId: userId,
      name: '小单',
      stage: MonsterStage.egg,
      level: 1,
      lifetimeXp: 0,
      currentLevelXp: 0,
      xpToNextLevel: 50,
      moodState: MonsterMood.expecting,
      currentAction: 'hatch',
    );
  }

  final String monsterId;
  final String userId;
  final String name;
  final MonsterStage stage;
  final int level;
  final int lifetimeXp;
  final int currentLevelXp;
  final int xpToNextLevel;
  final MonsterMood moodState;
  final String currentAction;
  final int sleepPetCount;
  final int wakeUpThreshold;

  MonsterSnapshot applyXp(XpGrant grant) {
    final nextLifetimeXp = (lifetimeXp + grant.amount)
        .clamp(0, 1 << 31)
        .toInt();
    var nextLevel = level;
    var nextCurrentLevelXp = currentLevelXp + grant.amount;
    while (nextCurrentLevelXp >= xpToNextLevel) {
      nextLevel += 1;
      nextCurrentLevelXp -= xpToNextLevel;
    }
    while (nextCurrentLevelXp < 0 && nextLevel > 1) {
      nextLevel -= 1;
      nextCurrentLevelXp += xpToNextLevel;
    }
    if (nextCurrentLevelXp < 0) {
      nextCurrentLevelXp = 0;
    }

    return MonsterSnapshot(
      monsterId: monsterId,
      userId: userId,
      name: name,
      stage: stage,
      level: nextLevel,
      lifetimeXp: nextLifetimeXp,
      currentLevelXp: nextCurrentLevelXp,
      xpToNextLevel: xpToNextLevel,
      moodState: grant.isPositive ? MonsterMood.energetic : moodState,
      currentAction: grant.isPositive ? 'eat' : currentAction,
      sleepPetCount: sleepPetCount,
      wakeUpThreshold: wakeUpThreshold,
    );
  }

  MonsterSnapshot copyWith({
    MonsterStage? stage,
    int? level,
    int? lifetimeXp,
    int? currentLevelXp,
    int? xpToNextLevel,
    MonsterMood? moodState,
    String? currentAction,
    int? sleepPetCount,
    int? wakeUpThreshold,
  }) {
    return MonsterSnapshot(
      monsterId: monsterId,
      userId: userId,
      name: name,
      stage: stage ?? this.stage,
      level: level ?? this.level,
      lifetimeXp: lifetimeXp ?? this.lifetimeXp,
      currentLevelXp: currentLevelXp ?? this.currentLevelXp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      moodState: moodState ?? this.moodState,
      currentAction: currentAction ?? this.currentAction,
      sleepPetCount: sleepPetCount ?? this.sleepPetCount,
      wakeUpThreshold: wakeUpThreshold ?? this.wakeUpThreshold,
    );
  }
}

class DailyTaskMilestone {
  const DailyTaskMilestone({
    required this.localDate,
    required this.timezoneId,
    required this.completedEligibleTaskCount,
    required this.milestoneKey,
    required this.title,
    required this.actionKey,
  });

  factory DailyTaskMilestone.smallStart({
    required DateTime localDate,
    required String timezoneId,
  }) {
    return DailyTaskMilestone(
      localDate: _dateOnly(localDate),
      timezoneId: timezoneId,
      completedEligibleTaskCount: 3,
      milestoneKey: 'small_start',
      title: '小试身手',
      actionKey: 'task_milestone',
    );
  }

  factory DailyTaskMilestone.fruitfulDay({
    required DateTime localDate,
    required String timezoneId,
  }) {
    return DailyTaskMilestone(
      localDate: _dateOnly(localDate),
      timezoneId: timezoneId,
      completedEligibleTaskCount: 6,
      milestoneKey: 'fruitful_day',
      title: '收获满满',
      actionKey: 'task_milestone',
    );
  }

  static DailyTaskMilestone? fromCompletedCount({
    required int completedEligibleTaskCount,
    required DateTime localDate,
    required String timezoneId,
  }) {
    return switch (completedEligibleTaskCount) {
      3 => DailyTaskMilestone.smallStart(
        localDate: localDate,
        timezoneId: timezoneId,
      ),
      6 => DailyTaskMilestone.fruitfulDay(
        localDate: localDate,
        timezoneId: timezoneId,
      ),
      _ => null,
    };
  }

  String get eventName => 'daily_task_milestone';

  Map<String, Object?> get payload {
    return {
      'localDate': _formatDate(localDate),
      'timezoneId': timezoneId,
      'completedEligibleTaskCount': completedEligibleTaskCount,
      'milestoneKey': milestoneKey,
      'title': title,
      'actionKey': actionKey,
    };
  }

  final DateTime localDate;
  final String timezoneId;
  final int completedEligibleTaskCount;
  final String milestoneKey;
  final String title;
  final String actionKey;
}

class DailyTaskSummary {
  const DailyTaskSummary({
    required this.summaryForDate,
    required this.timezoneId,
    required this.completedEligibleTaskCount,
    required this.createdTaskCount,
    required this.feedbackText,
  });

  String get eventName => 'daily_task_summary';

  Map<String, Object?> get payload {
    return {
      'summaryForDate': _formatDate(summaryForDate),
      'timezoneId': timezoneId,
      'completedEligibleTaskCount': completedEligibleTaskCount,
      'createdTaskCount': createdTaskCount,
      'feedbackText': feedbackText,
    };
  }

  final DateTime summaryForDate;
  final String timezoneId;
  final int completedEligibleTaskCount;
  final int createdTaskCount;
  final String feedbackText;
}

class CumulativeActiveRewardEvent {
  const CumulativeActiveRewardEvent({
    required this.eventId,
    required this.activeDayCount,
    required this.rewardThreshold,
    required this.xpAmount,
    required this.rewardReason,
  });

  String get eventName => 'cumulative_active_reward';

  Map<String, Object?> get payload {
    return {
      'activeDayCount': activeDayCount,
      'rewardThreshold': rewardThreshold,
      'xpAmount': xpAmount,
      'rewardReason': rewardReason,
    };
  }

  final String eventId;
  final int activeDayCount;
  final int rewardThreshold;
  final int xpAmount;
  final String rewardReason;
}

class LevelUpEvent {
  const LevelUpEvent({
    required this.monsterId,
    required this.fromLevel,
    required this.toLevel,
    required this.occurredAt,
  });

  String get eventName => 'level_up';

  Map<String, Object?> get payload {
    return {
      'monsterId': monsterId,
      'fromLevel': fromLevel,
      'toLevel': toLevel,
      'occurredAt': occurredAt.toIso8601String(),
    };
  }

  final String monsterId;
  final int fromLevel;
  final int toLevel;
  final DateTime occurredAt;
}

class StreakSnapshot {
  const StreakSnapshot({
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.lastActiveDate,
    required this.timezoneId,
  });

  factory StreakSnapshot.empty({required String timezoneId}) {
    return StreakSnapshot(
      currentStreakDays: 0,
      bestStreakDays: 0,
      lastActiveDate: null,
      timezoneId: timezoneId,
    );
  }

  StreakUpdateResult recordActiveDay(DateTime localDate) {
    final activeDate = _dateOnly(localDate);
    final previousDate = lastActiveDate == null
        ? null
        : _dateOnly(lastActiveDate!);
    if (previousDate != null && _isSameDate(previousDate, activeDate)) {
      return StreakUpdateResult(
        streak: this,
        updatedEvent: null,
        breakEvent: null,
      );
    }
    if (previousDate != null && activeDate.isBefore(previousDate)) {
      return StreakUpdateResult(
        streak: this,
        updatedEvent: null,
        breakEvent: null,
      );
    }

    final isConsecutive =
        previousDate != null && activeDate.difference(previousDate).inDays == 1;
    final nextCurrent = previousDate == null || !isConsecutive
        ? 1
        : currentStreakDays + 1;
    final nextBest = nextCurrent > bestStreakDays
        ? nextCurrent
        : bestStreakDays;
    final next = StreakSnapshot(
      currentStreakDays: nextCurrent,
      bestStreakDays: nextBest,
      lastActiveDate: activeDate,
      timezoneId: timezoneId,
    );

    final breakEvent =
        previousDate != null && activeDate.difference(previousDate).inDays > 1
        ? StreakBreakEvent(
            missedLocalDate: previousDate.add(const Duration(days: 1)),
            previousStreakDays: currentStreakDays,
            bestStreakDays: bestStreakDays,
            timezoneId: timezoneId,
            reason: 'no_rewardable_task_completed',
          )
        : null;

    return StreakUpdateResult(
      streak: next,
      updatedEvent: StreakUpdatedEvent(
        localDate: activeDate,
        currentStreakDays: next.currentStreakDays,
        bestStreakDays: next.bestStreakDays,
        timezoneId: timezoneId,
      ),
      breakEvent: breakEvent,
    );
  }

  final int currentStreakDays;
  final int bestStreakDays;
  final DateTime? lastActiveDate;
  final String timezoneId;
}

class StreakUpdateResult {
  const StreakUpdateResult({
    required this.streak,
    required this.updatedEvent,
    required this.breakEvent,
  });

  final StreakSnapshot streak;
  final StreakUpdatedEvent? updatedEvent;
  final StreakBreakEvent? breakEvent;
}

class StreakUpdatedEvent {
  const StreakUpdatedEvent({
    required this.localDate,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.timezoneId,
  });

  String get eventName => 'streak_updated';

  Map<String, Object?> get payload {
    return {
      'localDate': _formatDate(localDate),
      'currentStreakDays': currentStreakDays,
      'bestStreakDays': bestStreakDays,
      'timezoneId': timezoneId,
    };
  }

  final DateTime localDate;
  final int currentStreakDays;
  final int bestStreakDays;
  final String timezoneId;
}

class StreakBreakEvent {
  const StreakBreakEvent({
    required this.missedLocalDate,
    required this.previousStreakDays,
    required this.bestStreakDays,
    required this.timezoneId,
    required this.reason,
  });

  String get eventName => 'streak_break';

  Map<String, Object?> get payload {
    return {
      'missedLocalDate': _formatDate(missedLocalDate),
      'previousStreakDays': previousStreakDays,
      'bestStreakDays': bestStreakDays,
      'timezoneId': timezoneId,
      'reason': reason,
    };
  }

  final DateTime missedLocalDate;
  final int previousStreakDays;
  final int bestStreakDays;
  final String timezoneId;
  final String reason;
}

class MonsterPetReactionEvent {
  const MonsterPetReactionEvent({
    required this.monsterId,
    required this.reactionKey,
    required this.touchCountInSleep,
    required this.interactedAt,
  });

  String get eventName => 'monster_pet_reacted';

  Map<String, Object?> get payload {
    return {
      'monsterId': monsterId,
      'reactionKey': reactionKey,
      'touchCountInSleep': touchCountInSleep,
      'interactedAt': interactedAt.toIso8601String(),
    };
  }

  final String monsterId;
  final String reactionKey;
  final int touchCountInSleep;
  final DateTime interactedAt;
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
