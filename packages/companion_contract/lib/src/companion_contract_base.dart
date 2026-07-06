class CompanionSnapshotDraft {
  const CompanionSnapshotDraft({
    required this.schemaVersion,
    required this.monsterName,
    required this.todayCompletedTasks,
    required this.todayTotalTasks,
    this.staleAfterSeconds = 300,
  });

  final String schemaVersion;
  final String monsterName;
  final int todayCompletedTasks;
  final int todayTotalTasks;
  final int staleAfterSeconds;

  int get todayRemainingTasks => todayTotalTasks - todayCompletedTasks;
}

enum CompanionStyleLine {
  cool('cool'),
  soft('soft'),
  neutral('neutral');

  const CompanionStyleLine(this.jsonValue);

  final String jsonValue;

  static CompanionStyleLine fromJson(String value) => _enumFromJson(
    value,
    CompanionStyleLine.values,
    (styleLine) => styleLine.jsonValue,
    'styleLine',
  );
}

enum CompanionStage {
  egg('egg'),
  child('child'),
  teen('teen'),
  adult('adult');

  const CompanionStage(this.jsonValue);

  final String jsonValue;

  static CompanionStage fromJson(String value) => _enumFromJson(
    value,
    CompanionStage.values,
    (stage) => stage.jsonValue,
    'stage',
  );
}

enum CompanionMoodState {
  idle('idle'),
  energetic('energetic'),
  expecting('expecting'),
  sleeping('sleeping'),
  missing('missing');

  const CompanionMoodState(this.jsonValue);

  final String jsonValue;

  static CompanionMoodState fromJson(String value) => _enumFromJson(
    value,
    CompanionMoodState.values,
    (moodState) => moodState.jsonValue,
    'moodState',
  );
}

enum CompanionDesktopPetState {
  enabled('on'),
  disabled('off');

  const CompanionDesktopPetState(this.jsonValue);

  final String jsonValue;

  static CompanionDesktopPetState fromJson(String value) => _enumFromJson(
    value,
    CompanionDesktopPetState.values,
    (desktopPetState) => desktopPetState.jsonValue,
    'desktopPetState',
  );
}

class CompanionSnapshot {
  const CompanionSnapshot({
    required this.schemaVersion,
    required this.snapshotId,
    required this.userId,
    required this.generatedAt,
    required this.isStale,
    required this.staleAfterSeconds,
    required this.timezoneId,
    required this.monsterId,
    required this.monsterName,
    required this.styleLine,
    required this.stage,
    required this.level,
    required this.xpProgressPercent,
    required this.moodState,
    required this.actionKey,
    required this.spriteAssetId,
    required this.widgetFrameAssetId,
    required this.lineText,
    required this.todayCompletedTasks,
    required this.todayTotalTasks,
    required this.todayRemainingTasks,
    required this.todayTaskMilestoneKey,
    required this.todayTaskMilestoneTitle,
    required this.previousDaySummaryDate,
    required this.previousDayCompletedEligibleTasks,
    required this.previousDayFeedbackTitle,
    required this.previousDayFeedbackText,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.desktopPetState,
    required this.dndActive,
    required this.hideTaskTitlesOutsideApp,
  });

  factory CompanionSnapshot.fromJson(Map<String, Object?> json) {
    return CompanionSnapshot(
      schemaVersion: _requiredString(json, 'schemaVersion'),
      snapshotId: _requiredString(json, 'snapshotId'),
      userId: _requiredString(json, 'userId'),
      generatedAt: _requiredDateTime(json, 'generatedAt'),
      isStale: _requiredBool(json, 'isStale'),
      staleAfterSeconds: _requiredInt(json, 'staleAfterSeconds'),
      timezoneId: _requiredString(json, 'timezoneId'),
      monsterId: _requiredString(json, 'monsterId'),
      monsterName: _requiredString(json, 'monsterName'),
      styleLine: CompanionStyleLine.fromJson(
        _requiredString(json, 'styleLine'),
      ),
      stage: CompanionStage.fromJson(_requiredString(json, 'stage')),
      level: _requiredInt(json, 'level'),
      xpProgressPercent: _requiredDouble(json, 'xpProgressPercent'),
      moodState: CompanionMoodState.fromJson(
        _requiredString(json, 'moodState'),
      ),
      actionKey: _requiredString(json, 'actionKey'),
      spriteAssetId: _requiredString(json, 'spriteAssetId'),
      widgetFrameAssetId: _requiredString(json, 'widgetFrameAssetId'),
      lineText: _requiredString(json, 'lineText'),
      todayCompletedTasks: _requiredInt(json, 'todayCompletedTasks'),
      todayTotalTasks: _requiredInt(json, 'todayTotalTasks'),
      todayRemainingTasks: _requiredInt(json, 'todayRemainingTasks'),
      todayTaskMilestoneKey: _optionalString(json, 'todayTaskMilestoneKey'),
      todayTaskMilestoneTitle: _optionalString(json, 'todayTaskMilestoneTitle'),
      previousDaySummaryDate: _optionalDate(json, 'previousDaySummaryDate'),
      previousDayCompletedEligibleTasks: _optionalInt(
        json,
        'previousDayCompletedEligibleTasks',
      ),
      previousDayFeedbackTitle: _optionalString(
        json,
        'previousDayFeedbackTitle',
      ),
      previousDayFeedbackText: _optionalString(json, 'previousDayFeedbackText'),
      currentStreakDays: _requiredInt(json, 'currentStreakDays'),
      bestStreakDays: _requiredInt(json, 'bestStreakDays'),
      desktopPetState: CompanionDesktopPetState.fromJson(
        _requiredString(json, 'desktopPetState'),
      ),
      dndActive: _requiredBool(json, 'dndActive'),
      hideTaskTitlesOutsideApp: _requiredBool(json, 'hideTaskTitlesOutsideApp'),
    );
  }

  final String schemaVersion;
  final String snapshotId;
  final String userId;
  final DateTime generatedAt;
  final bool isStale;
  final int staleAfterSeconds;
  final String timezoneId;
  final String monsterId;
  final String monsterName;
  final CompanionStyleLine styleLine;
  final CompanionStage stage;
  final int level;
  final double xpProgressPercent;
  final CompanionMoodState moodState;
  final String actionKey;
  final String spriteAssetId;
  final String widgetFrameAssetId;
  final String lineText;
  final int todayCompletedTasks;
  final int todayTotalTasks;
  final int todayRemainingTasks;
  final String? todayTaskMilestoneKey;
  final String? todayTaskMilestoneTitle;
  final DateTime? previousDaySummaryDate;
  final int? previousDayCompletedEligibleTasks;
  final String? previousDayFeedbackTitle;
  final String? previousDayFeedbackText;
  final int currentStreakDays;
  final int bestStreakDays;
  final CompanionDesktopPetState desktopPetState;
  final bool dndActive;
  final bool hideTaskTitlesOutsideApp;

  bool get isExpired => isExpiredAt(DateTime.now().toUtc());

  bool isExpiredAt(DateTime now) {
    if (isStale) {
      return true;
    }

    final staleAt = generatedAt.toUtc().add(
      Duration(seconds: staleAfterSeconds),
    );
    return !now.toUtc().isBefore(staleAt);
  }

  String? taskTitleForExternalSurface(String? taskTitle) {
    if (hideTaskTitlesOutsideApp) {
      return null;
    }

    return taskTitle;
  }

  Map<String, Object?> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'snapshotId': snapshotId,
      'userId': userId,
      'generatedAt': generatedAt.toUtc().toIso8601String(),
      'isStale': isStale,
      'staleAfterSeconds': staleAfterSeconds,
      'timezoneId': timezoneId,
      'monsterId': monsterId,
      'monsterName': monsterName,
      'styleLine': styleLine.jsonValue,
      'stage': stage.jsonValue,
      'level': level,
      'xpProgressPercent': xpProgressPercent,
      'moodState': moodState.jsonValue,
      'actionKey': actionKey,
      'spriteAssetId': spriteAssetId,
      'widgetFrameAssetId': widgetFrameAssetId,
      'lineText': lineText,
      'todayCompletedTasks': todayCompletedTasks,
      'todayTotalTasks': todayTotalTasks,
      'todayRemainingTasks': todayRemainingTasks,
      'todayTaskMilestoneKey': todayTaskMilestoneKey,
      'todayTaskMilestoneTitle': todayTaskMilestoneTitle,
      'previousDaySummaryDate': _formatDate(previousDaySummaryDate),
      'previousDayCompletedEligibleTasks': previousDayCompletedEligibleTasks,
      'previousDayFeedbackTitle': previousDayFeedbackTitle,
      'previousDayFeedbackText': previousDayFeedbackText,
      'currentStreakDays': currentStreakDays,
      'bestStreakDays': bestStreakDays,
      'desktopPetState': desktopPetState.jsonValue,
      'dndActive': dndActive,
      'hideTaskTitlesOutsideApp': hideTaskTitlesOutsideApp,
    };
  }
}

T _enumFromJson<T extends Enum>(
  String value,
  Iterable<T> values,
  String Function(T value) jsonValue,
  String fieldName,
) {
  for (final enumValue in values) {
    if (jsonValue(enumValue) == value) {
      return enumValue;
    }
  }

  throw FormatException('Invalid $fieldName value: $value');
}

String _requiredString(Map<String, Object?> json, String fieldName) {
  final value = json[fieldName];
  if (value is String) {
    return value;
  }

  throw FormatException('Expected string field: $fieldName');
}

String? _optionalString(Map<String, Object?> json, String fieldName) {
  final value = json[fieldName];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return value;
  }

  throw FormatException('Expected nullable string field: $fieldName');
}

bool _requiredBool(Map<String, Object?> json, String fieldName) {
  final value = json[fieldName];
  if (value is bool) {
    return value;
  }

  throw FormatException('Expected bool field: $fieldName');
}

int _requiredInt(Map<String, Object?> json, String fieldName) {
  final value = json[fieldName];
  if (value is int) {
    return value;
  }
  if (value is num && value % 1 == 0) {
    return value.toInt();
  }

  throw FormatException('Expected int field: $fieldName');
}

int? _optionalInt(Map<String, Object?> json, String fieldName) {
  final value = json[fieldName];
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num && value % 1 == 0) {
    return value.toInt();
  }

  throw FormatException('Expected nullable int field: $fieldName');
}

double _requiredDouble(Map<String, Object?> json, String fieldName) {
  final value = json[fieldName];
  if (value is num) {
    return value.toDouble();
  }

  throw FormatException('Expected number field: $fieldName');
}

DateTime _requiredDateTime(Map<String, Object?> json, String fieldName) {
  final value = json[fieldName];
  if (value is String) {
    return DateTime.parse(value);
  }
  if (value is DateTime) {
    return value;
  }

  throw FormatException('Expected datetime field: $fieldName');
}

DateTime? _optionalDate(Map<String, Object?> json, String fieldName) {
  final value = json[fieldName];
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return DateTime.utc(value.year, value.month, value.day);
  }
  if (value is String) {
    final segments = value.split('-');
    if (segments.length == 3) {
      return DateTime.utc(
        int.parse(segments[0]),
        int.parse(segments[1]),
        int.parse(segments[2]),
      );
    }
  }

  throw FormatException('Expected date field: $fieldName');
}

String? _formatDate(DateTime? value) {
  if (value == null) {
    return null;
  }

  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
