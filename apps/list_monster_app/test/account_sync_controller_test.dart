import 'package:account_domain/account_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/account/account_session_controller.dart';
import 'package:list_monster_app/sync/app_sync_controller.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:local_store/local_store.dart';

void main() {
  test('starts as a persisted guest account', () async {
    final store = MemoryLocalStore();
    final controller = AccountSessionController(
      localStore: store,
      now: () => DateTime.utc(2026, 7, 7, 8),
    );

    await controller.restore();

    final state = await store.readAccountState();
    expect(controller.status, AccountStatus.guest);
    expect(state?.accountId, 'local_guest');
    expect(state?.isGuest, isTrue);
  });

  test('supports local simulated login without real auth', () async {
    final store = MemoryLocalStore();
    final controller = AccountSessionController(
      localStore: store,
      now: () => DateTime.utc(2026, 7, 7, 8),
    );
    await controller.restore();

    final outcome = await controller.simulateLogin(
      guestTaskCount: 0,
      cloudTaskCount: 2,
    );

    final state = await store.readAccountState();
    expect(outcome, SimulatedLoginOutcome.signedIn);
    expect(controller.status, AccountStatus.registered);
    expect(
      controller.account.providerLinks.single.provider,
      AuthProvider.phone,
    );
    expect(state?.isGuest, isFalse);
  });

  test(
    'cancels guest merge confirmation without changing either side',
    () async {
      final store = MemoryLocalStore();
      final controller = AccountSessionController(
        localStore: store,
        now: () => DateTime.utc(2026, 7, 7, 8),
      );
      await controller.restore();

      final outcome = await controller.simulateLogin(
        guestTaskCount: 1,
        cloudTaskCount: 2,
      );
      expect(outcome, SimulatedLoginOutcome.mergeConfirmationRequired);
      expect(controller.hasPendingMerge, isTrue);
      expect(controller.status, AccountStatus.guest);

      await controller.cancelPendingMerge();

      final state = await store.readAccountState();
      final queue = await store.readSyncQueue();
      expect(controller.hasPendingMerge, isFalse);
      expect(controller.status, AccountStatus.guest);
      expect(state?.accountId, 'local_guest');
      expect(queue, isEmpty);
    },
  );

  test('confirms guest merge and enqueues a guest merge sync item', () async {
    final store = MemoryLocalStore();
    final controller = AccountSessionController(
      localStore: store,
      now: () => DateTime.utc(2026, 7, 7, 8),
    );
    await controller.restore();
    await controller.simulateLogin(guestTaskCount: 1, cloudTaskCount: 2);

    await controller.confirmPendingMerge();

    final queue = await store.readSyncQueue();
    expect(controller.status, AccountStatus.registered);
    expect(controller.account.accountId, 'mock_user_1');
    expect(controller.hasPendingMerge, isFalse);
    expect(queue.single.operation, 'guest_merge');
    expect(queue.single.payload['guestTaskCount'], 1);
  });

  test('deletion pending is read-only and can be cancelled', () async {
    final store = MemoryLocalStore();
    var now = DateTime.utc(2026, 7, 7, 8);
    final controller = AccountSessionController(
      localStore: store,
      now: () => now,
    );
    await controller.restore();
    await controller.simulateLogin(guestTaskCount: 0, cloudTaskCount: 0);

    await controller.requestDeletion();

    expect(controller.status, AccountStatus.deletionPending);
    expect(controller.isReadOnly, isTrue);
    expect(
      await controller.simulateLogin(guestTaskCount: 0, cloudTaskCount: 0),
      SimulatedLoginOutcome.readOnlyBlocked,
    );

    now = DateTime.utc(2026, 7, 7, 9);
    await controller.cancelDeletion();

    expect(controller.status, AccountStatus.registered);
    expect(controller.isReadOnly, isFalse);
  });

  test('generates and stores a local companion snapshot', () async {
    final store = MemoryLocalStore();
    final taskSystem = TaskSystemController(
      today: DateTime(2026, 7, 7),
      now: DateTime(2026, 7, 7, 8),
    );
    final syncController = AppSyncController(localStore: store);

    final snapshot = await syncController.generateCompanionSnapshot(
      taskSystem,
      generatedAt: DateTime.utc(2026, 7, 7, 8),
    );

    final stored = await store.readCompanionSnapshot(
      now: DateTime.utc(2026, 7, 7, 8, 1),
    );
    expect(stored?.snapshotId, snapshot.snapshotId);
    expect(stored?.payload['schemaVersion'], snapshot.schemaVersion);
  });
}
