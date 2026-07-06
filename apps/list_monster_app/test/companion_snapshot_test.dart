import 'package:companion_contract/companion_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/companion_snapshot/companion_snapshot_builder.dart';
import 'package:list_monster_app/task_system_controller.dart';

void main() {
  test('builds a normal companion snapshot from controller state', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 7),
      now: DateTime(2026, 7, 7, 10),
      priorCompletedEligibleCounts: {DateTime(2026, 7, 6): 2},
      priorCreatedTaskCounts: {DateTime(2026, 7, 6): 3},
      userId: 'user-1',
      timezoneId: 'Asia/Shanghai',
    );
    addTearDown(controller.dispose);

    controller.recordAppOpened(DateTime(2026, 7, 7, 10));
    controller.createTask('private-title-alpha');
    controller.createTask('private-title-beta');
    controller.createTask('private-title-gamma');
    for (final task in controller.tasks.toList(growable: false)) {
      controller.completeTask(task.id);
    }

    final snapshot = buildCompanionSnapshot(
      controller,
      generatedAt: DateTime.utc(2026, 7, 7, 2),
      desktopPetState: CompanionDesktopPetState.enabled,
      dndActive: true,
    );

    expect(snapshot, isA<CompanionSnapshot>());
    expect(snapshot.schemaVersion, companionSnapshotSchemaVersion);
    expect(snapshot.snapshotId, 'companion-user-1-1783389600000000');
    expect(snapshot.userId, 'user-1');
    expect(snapshot.generatedAt, DateTime.utc(2026, 7, 7, 2));
    expect(snapshot.isStale, isFalse);
    expect(snapshot.staleAfterSeconds, 300);
    expect(snapshot.timezoneId, 'Asia/Shanghai');

    expect(snapshot.todayCompletedTasks, 3);
    expect(snapshot.todayTotalTasks, 3);
    expect(snapshot.todayRemainingTasks, 0);
    expect(snapshot.todayTaskMilestoneKey, 'small_start');
    expect(snapshot.todayTaskMilestoneTitle, isNotNull);

    expect(snapshot.level, controller.monster.level);
    expect(
      snapshot.xpProgressPercent,
      closeTo(
        controller.monster.currentLevelXp / controller.monster.xpToNextLevel,
        0.0001,
      ),
    );
    expect(snapshot.currentStreakDays, controller.streak.currentStreakDays);
    expect(snapshot.bestStreakDays, controller.streak.bestStreakDays);

    expect(snapshot.monsterId, controller.monster.monsterId);
    expect(snapshot.monsterName, controller.monster.name);
    expect(snapshot.stage, CompanionStage.egg);
    expect(snapshot.moodState, CompanionMoodState.energetic);
    expect(snapshot.actionKey, controller.monster.currentAction);
    expect(
      snapshot.spriteAssetId,
      'assets/sprites/monsters/lister/soft/egg/eat.png',
    );
    expect(
      snapshot.widgetFrameAssetId,
      'assets/sprites/monsters/lister/soft/egg/eat_widget.png',
    );

    expect(snapshot.previousDaySummaryDate, DateTime(2026, 7, 6));
    expect(snapshot.previousDayCompletedEligibleTasks, 2);
    expect(snapshot.previousDayFeedbackTitle, 'Previous day recap');
    expect(snapshot.previousDayFeedbackText, isNotNull);
    expect(snapshot.desktopPetState, CompanionDesktopPetState.enabled);
    expect(snapshot.dndActive, isTrue);
  });

  test('hides task titles outside the app by default', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 7),
      now: DateTime(2026, 7, 7, 10),
    );
    addTearDown(controller.dispose);

    controller.createTask('sensitive-payroll-title');

    final snapshot = buildCompanionSnapshot(
      controller,
      generatedAt: DateTime.utc(2026, 7, 7, 2),
    );

    expect(snapshot.hideTaskTitlesOutsideApp, isTrue);
    expect(
      snapshot.taskTitleForExternalSurface('sensitive-payroll-title'),
      isNull,
    );
    expect(snapshot.lineText, isNot(contains('sensitive-payroll-title')));
  });

  test('exposes the stale window through the contract expiration check', () {
    final snapshot = buildCompanionSnapshotFromInput(
      _input(),
      generatedAt: DateTime.utc(2026, 7, 7, 2),
      staleAfterSeconds: 120,
    );

    expect(snapshot.generatedAt, DateTime.utc(2026, 7, 7, 2));
    expect(snapshot.staleAfterSeconds, 120);
    expect(snapshot.isExpiredAt(DateTime.utc(2026, 7, 7, 2, 1, 59)), isFalse);
    expect(snapshot.isExpiredAt(DateTime.utc(2026, 7, 7, 2, 2)), isTrue);

    final staleSnapshot = buildCompanionSnapshotFromInput(
      _input(),
      generatedAt: DateTime.utc(2026, 7, 7, 2),
      isStale: true,
    );
    expect(staleSnapshot.isExpiredAt(DateTime.utc(2026, 7, 7, 2)), isTrue);
  });

  test(
    'uses supplied XP and streak summaries without deriving them from tasks',
    () {
      final snapshot = buildCompanionSnapshotFromInput(
        _input(
          todayCompletedTasks: 4,
          todayTotalTasks: 4,
          xpProgressPercent: 0.42,
          currentStreakDays: 9,
          bestStreakDays: 21,
        ),
        generatedAt: DateTime.utc(2026, 7, 7, 2),
      );

      expect(snapshot.todayRemainingTasks, 0);
      expect(snapshot.xpProgressPercent, 0.42);
      expect(snapshot.currentStreakDays, 9);
      expect(snapshot.bestStreakDays, 21);
    },
  );
}

CompanionSnapshotInput _input({
  int todayCompletedTasks = 1,
  int todayTotalTasks = 3,
  double xpProgressPercent = 0.2,
  int currentStreakDays = 2,
  int bestStreakDays = 5,
}) {
  return CompanionSnapshotInput(
    userId: 'user-1',
    timezoneId: 'Asia/Shanghai',
    monsterId: 'monster-1',
    monsterName: 'Todo',
    styleLine: CompanionStyleLine.soft,
    stage: CompanionStage.egg,
    level: 1,
    xpProgressPercent: xpProgressPercent,
    moodState: CompanionMoodState.expecting,
    actionKey: 'idle_02',
    todayCompletedTasks: todayCompletedTasks,
    todayTotalTasks: todayTotalTasks,
    currentStreakDays: currentStreakDays,
    bestStreakDays: bestStreakDays,
  );
}
