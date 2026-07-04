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

  MonsterSnapshot applyXp(XpGrant grant) {
    final nextLifetimeXp = lifetimeXp + grant.amount;
    final nextCurrentLevelXp = currentLevelXp + grant.amount;
    final shouldLevelUp = nextCurrentLevelXp >= xpToNextLevel;

    return MonsterSnapshot(
      monsterId: monsterId,
      userId: userId,
      name: name,
      stage: stage,
      level: shouldLevelUp ? level + 1 : level,
      lifetimeXp: nextLifetimeXp,
      currentLevelXp: shouldLevelUp
          ? nextCurrentLevelXp - xpToNextLevel
          : nextCurrentLevelXp,
      xpToNextLevel: xpToNextLevel,
      moodState: grant.isPositive ? MonsterMood.energetic : moodState,
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
      actionKey: 'daily_task_milestone_small_start',
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
      actionKey: 'daily_task_milestone_fruitful_day',
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

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
