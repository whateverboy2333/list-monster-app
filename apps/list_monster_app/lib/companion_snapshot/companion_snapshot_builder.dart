import 'package:companion_contract/companion_contract.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:task_domain/task_domain.dart';

const companionSnapshotSchemaVersion = '0.1.3';
const defaultCompanionSnapshotStaleAfterSeconds = 300;

const _speciesKey = 'lister';
const _defaultStyleLine = CompanionStyleLine.soft;

CompanionSnapshot buildCompanionSnapshot(
  TaskSystemController controller, {
  DateTime? generatedAt,
  int staleAfterSeconds = defaultCompanionSnapshotStaleAfterSeconds,
  bool isStale = false,
  bool hideTaskTitlesOutsideApp = true,
  CompanionDesktopPetState desktopPetState = CompanionDesktopPetState.disabled,
  bool dndActive = false,
  CompanionStyleLine styleLine = _defaultStyleLine,
}) {
  return buildCompanionSnapshotFromInput(
    CompanionSnapshotInput.fromTaskSystemController(
      controller,
      styleLine: styleLine,
    ),
    generatedAt: generatedAt,
    staleAfterSeconds: staleAfterSeconds,
    isStale: isStale,
    hideTaskTitlesOutsideApp: hideTaskTitlesOutsideApp,
    desktopPetState: desktopPetState,
    dndActive: dndActive,
  );
}

CompanionSnapshot buildCompanionSnapshotFromInput(
  CompanionSnapshotInput input, {
  DateTime? generatedAt,
  int staleAfterSeconds = defaultCompanionSnapshotStaleAfterSeconds,
  bool isStale = false,
  bool hideTaskTitlesOutsideApp = true,
  CompanionDesktopPetState desktopPetState = CompanionDesktopPetState.disabled,
  bool dndActive = false,
}) {
  final generatedAtUtc = (generatedAt ?? DateTime.now()).toUtc();
  final remainingTasks = _remainingTasks(
    totalTasks: input.todayTotalTasks,
    completedTasks: input.todayCompletedTasks,
  );

  return CompanionSnapshot(
    schemaVersion: companionSnapshotSchemaVersion,
    snapshotId: _snapshotId(input.userId, generatedAtUtc),
    userId: input.userId,
    generatedAt: generatedAtUtc,
    isStale: isStale,
    staleAfterSeconds: staleAfterSeconds,
    timezoneId: input.timezoneId,
    monsterId: input.monsterId,
    monsterName: input.monsterName,
    styleLine: input.styleLine,
    stage: input.stage,
    level: input.level,
    xpProgressPercent: input.xpProgressPercent,
    moodState: input.moodState,
    actionKey: input.actionKey,
    spriteAssetId: _spriteAssetId(input),
    widgetFrameAssetId: _widgetFrameAssetId(input),
    lineText: _lineText(
      completedTasks: input.todayCompletedTasks,
      totalTasks: input.todayTotalTasks,
      remainingTasks: remainingTasks,
    ),
    todayCompletedTasks: input.todayCompletedTasks,
    todayTotalTasks: input.todayTotalTasks,
    todayRemainingTasks: remainingTasks,
    todayTaskMilestoneKey: input.todayTaskMilestoneKey,
    todayTaskMilestoneTitle: input.todayTaskMilestoneTitle,
    previousDaySummaryDate: input.previousDaySummaryDate,
    previousDayCompletedEligibleTasks: input.previousDayCompletedEligibleTasks,
    previousDayFeedbackTitle: input.previousDayFeedbackTitle,
    previousDayFeedbackText: input.previousDayFeedbackText,
    currentStreakDays: input.currentStreakDays,
    bestStreakDays: input.bestStreakDays,
    desktopPetState: desktopPetState,
    dndActive: dndActive,
    hideTaskTitlesOutsideApp: hideTaskTitlesOutsideApp,
  );
}

class CompanionSnapshotInput {
  const CompanionSnapshotInput({
    required this.userId,
    required this.timezoneId,
    required this.monsterId,
    required this.monsterName,
    required this.styleLine,
    required this.stage,
    required this.level,
    required this.xpProgressPercent,
    required this.moodState,
    required this.actionKey,
    required this.todayCompletedTasks,
    required this.todayTotalTasks,
    required this.currentStreakDays,
    required this.bestStreakDays,
    this.todayTaskMilestoneKey,
    this.todayTaskMilestoneTitle,
    this.previousDaySummaryDate,
    this.previousDayCompletedEligibleTasks,
    this.previousDayFeedbackTitle,
    this.previousDayFeedbackText,
  });

  factory CompanionSnapshotInput.fromTaskSystemController(
    TaskSystemController controller, {
    CompanionStyleLine styleLine = _defaultStyleLine,
  }) {
    final todayTasks = controller.todayTasks;
    final completedTodayTasks = todayTasks
        .where((task) => task.status == TaskStatus.completed)
        .length;
    final milestone = controller.latestMilestone;
    final dailySummary = controller.latestDailySummary;
    final monster = controller.monster;
    final streak = controller.streak;

    return CompanionSnapshotInput(
      userId: controller.userId,
      timezoneId: controller.timezoneId,
      monsterId: monster.monsterId,
      monsterName: monster.name,
      styleLine: styleLine,
      stage: _stageFromMonster(monster.stage),
      level: monster.level,
      xpProgressPercent: _xpProgressPercent(monster),
      moodState: _moodFromMonster(monster.moodState),
      actionKey: monster.currentAction,
      todayCompletedTasks: completedTodayTasks,
      todayTotalTasks: todayTasks.length,
      todayTaskMilestoneKey: milestone?.milestoneKey,
      todayTaskMilestoneTitle: milestone?.title,
      previousDaySummaryDate: dailySummary?.summaryForDate,
      previousDayCompletedEligibleTasks:
          dailySummary?.completedEligibleTaskCount,
      previousDayFeedbackTitle: dailySummary == null
          ? null
          : 'Previous day recap',
      previousDayFeedbackText: dailySummary?.feedbackText,
      currentStreakDays: streak.currentStreakDays,
      bestStreakDays: streak.bestStreakDays,
    );
  }

  final String userId;
  final String timezoneId;
  final String monsterId;
  final String monsterName;
  final CompanionStyleLine styleLine;
  final CompanionStage stage;
  final int level;
  final double xpProgressPercent;
  final CompanionMoodState moodState;
  final String actionKey;
  final int todayCompletedTasks;
  final int todayTotalTasks;
  final String? todayTaskMilestoneKey;
  final String? todayTaskMilestoneTitle;
  final DateTime? previousDaySummaryDate;
  final int? previousDayCompletedEligibleTasks;
  final String? previousDayFeedbackTitle;
  final String? previousDayFeedbackText;
  final int currentStreakDays;
  final int bestStreakDays;
}

CompanionStage _stageFromMonster(MonsterStage stage) {
  return switch (stage) {
    MonsterStage.egg => CompanionStage.egg,
    MonsterStage.child => CompanionStage.child,
    MonsterStage.teen => CompanionStage.teen,
    MonsterStage.adult => CompanionStage.adult,
  };
}

CompanionMoodState _moodFromMonster(MonsterMood moodState) {
  return switch (moodState) {
    MonsterMood.idle => CompanionMoodState.idle,
    MonsterMood.energetic => CompanionMoodState.energetic,
    MonsterMood.expecting => CompanionMoodState.expecting,
    MonsterMood.sleeping => CompanionMoodState.sleeping,
    MonsterMood.missing => CompanionMoodState.missing,
  };
}

double _xpProgressPercent(MonsterSnapshot monster) {
  if (monster.xpToNextLevel <= 0) {
    return 0;
  }

  final progress = monster.currentLevelXp / monster.xpToNextLevel;
  return progress.clamp(0, 1).toDouble();
}

int _remainingTasks({required int totalTasks, required int completedTasks}) {
  final remaining = totalTasks - completedTasks;
  return remaining < 0 ? 0 : remaining;
}

String _lineText({
  required int completedTasks,
  required int totalTasks,
  required int remainingTasks,
}) {
  if (totalTasks == 0) {
    return 'No tasks are planned for today.';
  }
  if (remainingTasks == 0) {
    return 'All tasks are clear for today.';
  }
  if (completedTasks == 0) {
    return '$remainingTasks tasks are waiting today.';
  }
  return '$completedTasks done, $remainingTasks left today.';
}

String _snapshotId(String userId, DateTime generatedAtUtc) {
  return 'companion-$userId-${generatedAtUtc.microsecondsSinceEpoch}';
}

String _spriteAssetId(CompanionSnapshotInput input) {
  return 'assets/sprites/monsters/$_speciesKey/'
      '${input.styleLine.jsonValue}/${input.stage.jsonValue}/'
      '${input.actionKey}.png';
}

String _widgetFrameAssetId(CompanionSnapshotInput input) {
  return 'assets/sprites/monsters/$_speciesKey/'
      '${input.styleLine.jsonValue}/${input.stage.jsonValue}/'
      '${input.actionKey}_widget.png';
}
