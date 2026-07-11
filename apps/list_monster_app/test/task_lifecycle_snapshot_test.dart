import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:companion_contract/companion_contract.dart';
import 'package:list_monster_app/account/account_session_controller.dart';
import 'package:list_monster_app/companion_snapshot/android_widget_bridge.dart';
import 'package:list_monster_app/desktop_pet/desktop_pet.dart';
import 'package:list_monster_app/main.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:local_store/local_store.dart';
import 'package:sync_domain/sync_domain.dart';

void main() {
  testWidgets('App lifecycle refreshes the persisted snapshot and sync queue', (
    tester,
  ) async {
    final store = MemoryLocalStore();
    final bridge = _RecordingWidgetBridge();
    final desktopPet = _RecordingDesktopPetWindowPort();
    final account = AccountSessionController(
      localStore: store,
      now: () => DateTime(2026, 7, 7, 9),
    );
    final taskSystem = TaskSystemController(
      today: DateTime(2026, 7, 7),
      now: DateTime(2026, 7, 7, 9),
    );
    addTearDown(account.dispose);
    addTearDown(taskSystem.dispose);

    await tester.pumpWidget(
      ListMonsterApp(
        accountSessionController: account,
        taskSystemController: taskSystem,
        androidWidgetBridge: bridge,
        desktopPetWindowPort: desktopPet,
        openedAt: DateTime(2026, 7, 7, 9),
      ),
    );
    await _flush(tester);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('desktop-pet-open-button')));
    await tester.pumpAndSettle();
    expect(desktopPet.openedSnapshots, hasLength(1));
    await tester.tap(find.byIcon(Icons.today_outlined));
    await tester.pumpAndSettle();

    taskSystem.createTask('daily task');
    await _flush(tester);
    expect(await _readSnapshot(store), isNotNull);
    expect((await _readSnapshot(store))!.payload['todayTotalTasks'], 1);
    expect((await _readSnapshot(store))!.payload['todayRemainingTasks'], 1);

    final taskId = taskSystem.tasks.single.id;
    taskSystem.completeTask(taskId);
    await _flush(tester);
    final completedSnapshot = await _readSnapshot(store);
    expect(completedSnapshot?.payload['todayCompletedTasks'], 1);
    expect(completedSnapshot?.payload['todayRemainingTasks'], 0);
    expect(completedSnapshot?.payload['currentStreakDays'], 1);
    expect(taskSystem.todayXp, 10);
    expect(taskSystem.streak.currentStreakDays, 1);

    taskSystem.undoCompletion(taskId);
    await _flush(tester);
    final undoneSnapshot = await _readSnapshot(store);
    expect(undoneSnapshot?.payload['todayCompletedTasks'], 0);
    expect(undoneSnapshot?.payload['todayRemainingTasks'], 1);
    expect(undoneSnapshot?.payload['currentStreakDays'], 0);
    expect(taskSystem.todayXp, 0);
    expect(taskSystem.streak.currentStreakDays, 0);

    taskSystem.cancelTask(taskId);
    taskSystem.restoreTask(taskId);
    await _flush(tester);
    final restoredSnapshot = await _readSnapshot(store);
    expect(restoredSnapshot?.payload['todayTotalTasks'], 1);
    expect(restoredSnapshot?.payload['todayRemainingTasks'], 1);
    expect(taskSystem.todayXp, 0);
    expect(taskSystem.streak.currentStreakDays, 0);

    final queue = await store.readSyncQueue();
    expect(queue, hasLength(3));
    expect(queue.map((item) => item.operation), [
      SyncOperationType.taskComplete.contractName,
      SyncOperationType.taskUndoCompletion.contractName,
      SyncOperationType.taskRestore.contractName,
    ]);
    expect(queue.map((item) => item.operationId), [
      queue[0].eventId,
      queue[1].eventId,
      queue[2].eventId,
    ]);
    expect(queue.map((item) => item.sourceEventId), [
      queue[0].eventId,
      queue[1].eventId,
      queue[2].eventId,
    ]);
    expect(
      bridge.persistedSnapshots.last.snapshotId,
      restoredSnapshot?.snapshotId,
    );
    expect(desktopPet.openedSnapshots, hasLength(6));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets(
    'bridge, storage, and queue failures do not block local task feedback',
    (tester) async {
      final store = _FailingStore();
      final account = AccountSessionController(localStore: store);
      final taskSystem = TaskSystemController(
        today: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 7, 9),
      );
      addTearDown(account.dispose);
      addTearDown(taskSystem.dispose);

      await tester.pumpWidget(
        ListMonsterApp(
          accountSessionController: account,
          taskSystemController: taskSystem,
          androidWidgetBridge: _ThrowingWidgetBridge(),
          openedAt: DateTime(2026, 7, 7, 9),
        ),
      );
      await _flush(tester);

      taskSystem.createTask('offline task');
      final taskId = taskSystem.tasks.single.id;
      taskSystem.completeTask(taskId);
      taskSystem.completeTask(taskId);
      await _flush(tester);

      expect(taskSystem.tasks.single.isCompleted, isTrue);
      expect(taskSystem.todayXp, 10);
      expect(taskSystem.streak.currentStreakDays, 1);
      expect(taskSystem.xpLedger, hasLength(1));
      expect(await store.readSyncQueue(), isEmpty);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );
}

Future<void> _flush(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

Future<LocalCompanionSnapshot?> _readSnapshot(MemoryLocalStore store) {
  return store.readCompanionSnapshot();
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

final class _ThrowingWidgetBridge implements CompanionSnapshotWidgetBridge {
  @override
  Future<AndroidWidgetLaunchIntent?> consumeInitialWidgetLaunchIntent() async {
    return null;
  }

  @override
  Future<void> persistSnapshot(LocalCompanionSnapshot snapshot) async {
    throw StateError('widget unavailable');
  }

  @override
  void setWidgetLaunchIntentHandler(
    AndroidWidgetLaunchIntentHandler? handler,
  ) {}
}

final class _RecordingDesktopPetWindowPort implements DesktopPetWindowPort {
  final List<CompanionSnapshot> openedSnapshots = [];

  @override
  Future<void> open(CompanionSnapshot snapshot) async {
    openedSnapshots.add(snapshot);
  }

  @override
  Future<void> close() async {}
}

final class _FailingStore extends MemoryLocalStore {
  @override
  Future<void> appendSyncQueueItem(LocalSyncQueueItem item) async {
    throw StateError('sync storage unavailable');
  }

  @override
  Future<void> saveCompanionSnapshot(LocalCompanionSnapshot snapshot) async {
    throw StateError('snapshot storage unavailable');
  }
}
