import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/companion_snapshot/android_widget_bridge.dart';
import 'package:list_monster_app/companion_snapshot/companion_snapshot_builder.dart';
import 'package:list_monster_app/companion_snapshot/companion_snapshot_refresh_service.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:local_store/local_store.dart';
import 'package:monster_domain/monster_domain.dart';

void main() {
  test(
    'refresh writes the generated companion snapshot to local_store',
    () async {
      final store = MemoryLocalStore();
      final service = CompanionSnapshotRefreshService(localStore: store);
      final controller = TaskSystemController(
        today: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 7, 10),
        userId: 'user-1',
        timezoneId: 'Asia/Shanghai',
      );
      addTearDown(controller.dispose);

      controller.createTask('water plants');

      final generatedAt = DateTime.utc(2026, 7, 7, 2);
      final snapshot = await service.refresh(
        controller,
        generatedAt: generatedAt,
      );
      final localSnapshot = await store.readCompanionSnapshot(now: generatedAt);
      final readResult = await service.read(
        now: generatedAt.add(const Duration(minutes: 1)),
      );

      expect(localSnapshot, isNotNull);
      expect(localSnapshot!.snapshotId, snapshot.snapshotId);
      expect(localSnapshot.generatedAt, generatedAt);
      expect(
        localSnapshot.expiresAt,
        generatedAt.add(const Duration(seconds: 300)),
      );
      expect(
        localSnapshot.payload['schemaVersion'],
        companionSnapshotSchemaVersion,
      );
      expect(localSnapshot.payload['snapshotId'], snapshot.snapshotId);
      expect(readResult.state, CompanionSnapshotReadState.fresh);
      expect(readResult.snapshot?.snapshotId, snapshot.snapshotId);
    },
  );

  test(
    'refresh mirrors the same persisted snapshot to the android widget bridge',
    () async {
      final store = MemoryLocalStore();
      final widgetBridge = _RecordingWidgetBridge();
      final service = CompanionSnapshotRefreshService(
        localStore: store,
        widgetBridge: widgetBridge,
      );
      final controller = TaskSystemController(
        today: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 7, 10),
      );
      addTearDown(controller.dispose);

      controller.createTask('sensitive-payroll-title');

      final generatedAt = DateTime.utc(2026, 7, 7, 2);
      final snapshot = await service.refresh(
        controller,
        generatedAt: generatedAt,
      );
      final localSnapshot = await store.readCompanionSnapshot(now: generatedAt);
      final widgetSnapshot = widgetBridge.persistedSnapshots.single;
      final widgetJson = encodeAndroidWidgetSnapshot(widgetSnapshot);
      final widgetRead = AndroidWidgetSnapshotReadResult.fromPersistedJson(
        widgetJson,
        now: generatedAt.add(const Duration(minutes: 1)),
      );

      expect(localSnapshot?.snapshotId, snapshot.snapshotId);
      expect(widgetSnapshot.snapshotId, localSnapshot?.snapshotId);
      expect(widgetSnapshot.expiresAt, localSnapshot?.expiresAt);
      expect(widgetRead.state, AndroidWidgetSnapshotState.fresh);
      expect(widgetRead.payload?['snapshotId'], snapshot.snapshotId);
      expect(widgetJson, isNot(contains('sensitive-payroll-title')));
    },
  );

  test('expired local snapshot read returns a refresh suggestion', () async {
    final store = MemoryLocalStore();
    final service = CompanionSnapshotRefreshService(localStore: store);
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 7),
      now: DateTime(2026, 7, 7, 10),
    );
    addTearDown(controller.dispose);

    final generatedAt = DateTime.utc(2026, 7, 7, 2);
    await service.refresh(
      controller,
      generatedAt: generatedAt,
      staleAfterSeconds: 1,
    );

    final freshResult = await service.read(
      now: generatedAt.add(const Duration(milliseconds: 999)),
    );
    final expiredResult = await service.read(
      now: generatedAt.add(const Duration(seconds: 1)),
    );

    expect(freshResult.state, CompanionSnapshotReadState.fresh);
    expect(expiredResult.state, CompanionSnapshotReadState.needsRefresh);
    expect(expiredResult.needsRefresh, isTrue);
  });

  test(
    'task lifecycle, app open, and growth changes can refresh persisted snapshots',
    () async {
      final store = MemoryLocalStore();
      final service = CompanionSnapshotRefreshService(localStore: store);
      final controller = TaskSystemController(
        today: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 7, 10),
        priorCompletedEligibleCounts: {DateTime(2026, 7, 6): 2},
        priorCreatedTaskCounts: {DateTime(2026, 7, 6): 3},
      );
      addTearDown(controller.dispose);

      controller.recordAppOpened(DateTime(2026, 7, 7, 10));
      final opened = await service.refreshForTrigger(
        controller,
        CompanionSnapshotRefreshTrigger.appOpened,
        generatedAt: DateTime.utc(2026, 7, 7, 2),
      );
      expect(opened.previousDaySummaryDate, DateTime(2026, 7, 6));

      controller.createTask('task-alpha');
      final created = await service.refreshForTrigger(
        controller,
        CompanionSnapshotRefreshTrigger.taskCreated,
        generatedAt: DateTime.utc(2026, 7, 7, 2, 1),
      );
      expect(created.todayTotalTasks, 1);
      expect(created.todayRemainingTasks, 1);

      final taskId = controller.tasks.single.id;
      controller.completeTask(taskId);
      final completed = await service.refreshForTrigger(
        controller,
        CompanionSnapshotRefreshTrigger.taskCompleted,
        generatedAt: DateTime.utc(2026, 7, 7, 2, 2),
      );
      expect(completed.todayCompletedTasks, 1);
      expect(completed.currentStreakDays, 2);
      expect(completed.xpProgressPercent, greaterThan(0));

      controller.undoCompletion(taskId);
      final undone = await service.refreshForTrigger(
        controller,
        CompanionSnapshotRefreshTrigger.taskCompletionUndone,
        generatedAt: DateTime.utc(2026, 7, 7, 2, 3),
      );
      expect(undone.todayCompletedTasks, 0);
      expect(undone.xpProgressPercent, lessThan(completed.xpProgressPercent));

      controller.cancelTask(taskId);
      controller.restoreTask(taskId);
      final restored = await service.refreshForTrigger(
        controller,
        CompanionSnapshotRefreshTrigger.taskRestored,
        generatedAt: DateTime.utc(2026, 7, 7, 2, 4),
      );
      expect(restored.todayTotalTasks, 1);
      expect(restored.todayRemainingTasks, 1);

      controller.grantXpForTesting(
        sourceEventId: 'growth-1',
        sourceType: XpSourceType.cumulativeActiveReward,
        rawAmount: 20,
        dailyCapApplied: false,
      );
      final growthChanged = await service.refreshForTrigger(
        controller,
        CompanionSnapshotRefreshTrigger.growthChanged,
        generatedAt: DateTime.utc(2026, 7, 7, 2, 5),
      );
      final localSnapshot = await store.readCompanionSnapshot(
        now: DateTime.utc(2026, 7, 7, 2, 5),
      );

      expect(
        growthChanged.xpProgressPercent,
        greaterThan(undone.xpProgressPercent),
      );
      expect(localSnapshot?.snapshotId, growthChanged.snapshotId);
    },
  );

  test('repeated refresh does not create XP or streak side effects', () async {
    final store = MemoryLocalStore();
    final service = CompanionSnapshotRefreshService(localStore: store);
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 7),
      now: DateTime(2026, 7, 7, 10),
    );
    addTearDown(controller.dispose);

    controller.createTask('finish report');
    controller.completeTask(controller.tasks.single.id);

    final xpLedgerLength = controller.xpLedger.length;
    final currentStreakDays = controller.streak.currentStreakDays;
    final bestStreakDays = controller.streak.bestStreakDays;

    await service.refresh(controller, generatedAt: DateTime.utc(2026, 7, 7, 2));
    await service.refresh(
      controller,
      generatedAt: DateTime.utc(2026, 7, 7, 2, 1),
    );

    expect(controller.xpLedger, hasLength(xpLedgerLength));
    expect(controller.streak.currentStreakDays, currentStreakDays);
    expect(controller.streak.bestStreakDays, bestStreakDays);
  });

  test(
    'sensitive task titles are not persisted into external snapshot copy',
    () async {
      final store = MemoryLocalStore();
      final service = CompanionSnapshotRefreshService(localStore: store);
      final controller = TaskSystemController(
        today: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 7, 10),
      );
      addTearDown(controller.dispose);

      controller.createTask('sensitive-payroll-title');

      final generatedAt = DateTime.utc(2026, 7, 7, 2);
      await service.refresh(controller, generatedAt: generatedAt);
      final localSnapshot = await store.readCompanionSnapshot(now: generatedAt);
      final persistedJson = jsonEncode(localSnapshot?.payload);

      expect(persistedJson, isNot(contains('sensitive-payroll-title')));
      expect(localSnapshot?.payload['hideTaskTitlesOutsideApp'], isTrue);
    },
  );
}

final class _RecordingWidgetBridge implements CompanionSnapshotWidgetBridge {
  final List<LocalCompanionSnapshot> persistedSnapshots = [];

  @override
  Future<AndroidWidgetLaunchIntent?> consumeInitialWidgetLaunchIntent() async {
    return null;
  }

  @override
  Future<void> persistSnapshot(LocalCompanionSnapshot snapshot) async {
    persistedSnapshots.add(snapshot);
  }

  @override
  void setWidgetLaunchIntentHandler(
    AndroidWidgetLaunchIntentHandler? handler,
  ) {}
}
