import 'package:local_store/local_store.dart';
import 'package:test/test.dart';

void main() {
  group('MemoryLocalStore', () {
    test('writes and reads local records', () async {
      final store = MemoryLocalStore();
      final updatedAt = DateTime.utc(2026, 7, 7, 8);
      final generatedAt = DateTime.utc(2026, 7, 7, 8, 1);

      await store.saveAccountState(
        LocalAccountState(
          accountId: 'guest-1',
          isGuest: true,
          updatedAt: updatedAt,
          payload: {'mergeReady': false},
        ),
      );
      await store.saveTaskSnapshot(
        LocalTaskSnapshot(
          taskId: 'task-1',
          updatedAt: updatedAt,
          revision: 1,
          payload: {'title': 'water plants', 'completed': false},
        ),
      );
      await store.appendEvent(
        LocalEventRecord(
          eventId: 'event-1',
          eventType: 'task.created',
          occurredAt: updatedAt,
          payload: {'taskId': 'task-1'},
        ),
      );
      await store.saveNotificationSettings(
        LocalNotificationSettings(
          updatedAt: updatedAt,
          enabled: true,
          privacyMode: 'visible',
          doNotDisturbStartMinute: 1320,
          doNotDisturbEndMinute: 420,
        ),
      );
      await store.saveCompanionSnapshot(
        LocalCompanionSnapshot(
          snapshotId: 'snapshot-1',
          generatedAt: generatedAt,
          expiresAt: generatedAt.add(const Duration(minutes: 5)),
          payload: {'monsterMood': 'idle'},
        ),
      );

      final account = await store.readAccountState();
      final task = await store.readTaskSnapshot('task-1');
      final events = await store.readEvents();
      final notificationSettings = await store.readNotificationSettings();
      final companionSnapshot = await store.readCompanionSnapshot(
        now: generatedAt.add(const Duration(minutes: 1)),
      );

      expect(account?.accountId, 'guest-1');
      expect(account?.payload['mergeReady'], isFalse);
      expect(task?.revision, 1);
      expect(task?.payload['title'], 'water plants');
      expect(events.single.eventType, 'task.created');
      expect(notificationSettings?.privacyMode, 'visible');
      expect(notificationSettings?.doNotDisturbStartMinute, 1320);
      expect(companionSnapshot?.payload['monsterMood'], 'idle');
    });

    test(
      'overwrites account, task, notification, and snapshot records',
      () async {
        final store = MemoryLocalStore();
        final first = DateTime.utc(2026, 7, 7, 9);
        final second = DateTime.utc(2026, 7, 7, 10);

        await store.saveAccountState(
          LocalAccountState(
            accountId: 'guest-1',
            isGuest: true,
            updatedAt: first,
          ),
        );
        await store.saveAccountState(
          LocalAccountState(
            accountId: 'user-1',
            isGuest: false,
            updatedAt: second,
          ),
        );
        await store.saveTaskSnapshot(
          LocalTaskSnapshot(
            taskId: 'task-1',
            updatedAt: first,
            revision: 1,
            payload: {'title': 'old'},
          ),
        );
        await store.saveTaskSnapshot(
          LocalTaskSnapshot(
            taskId: 'task-1',
            updatedAt: second,
            revision: 2,
            payload: {'title': 'new'},
          ),
        );
        await store.saveNotificationSettings(
          LocalNotificationSettings(updatedAt: first, enabled: true),
        );
        await store.saveNotificationSettings(
          LocalNotificationSettings(updatedAt: second, enabled: false),
        );
        await store.saveCompanionSnapshot(
          LocalCompanionSnapshot(
            snapshotId: 'snapshot-old',
            generatedAt: first,
            expiresAt: second,
          ),
        );
        await store.saveCompanionSnapshot(
          LocalCompanionSnapshot(
            snapshotId: 'snapshot-new',
            generatedAt: second,
            expiresAt: second.add(const Duration(minutes: 5)),
          ),
        );

        final account = await store.readAccountState();
        final task = await store.readTaskSnapshot('task-1');
        final tasks = await store.readTaskSnapshots();
        final notificationSettings = await store.readNotificationSettings();
        final companionSnapshot = await store.readCompanionSnapshot(
          now: second,
        );

        expect(account?.accountId, 'user-1');
        expect(account?.isGuest, isFalse);
        expect(task?.revision, 2);
        expect(task?.payload['title'], 'new');
        expect(tasks, hasLength(1));
        expect(notificationSettings?.enabled, isFalse);
        expect(companionSnapshot?.snapshotId, 'snapshot-new');
      },
    );

    test(
      'appends sync queue items in order and can replace the queue',
      () async {
        final store = MemoryLocalStore();
        final now = DateTime.utc(2026, 7, 7, 11);

        await store.appendSyncQueueItem(
          LocalSyncQueueItem(
            itemId: 'queue-1',
            operation: 'task.complete',
            enqueuedAt: now,
            payload: {'taskId': 'task-1'},
          ),
        );
        await store.appendSyncQueueItem(
          LocalSyncQueueItem(
            itemId: 'queue-2',
            operation: 'task.rename',
            enqueuedAt: now.add(const Duration(seconds: 1)),
            payload: {'taskId': 'task-1'},
          ),
        );

        final appended = await store.readSyncQueue();
        expect(appended.map((item) => item.itemId), ['queue-1', 'queue-2']);

        await store.replaceSyncQueue([
          LocalSyncQueueItem(
            itemId: 'queue-3',
            operation: 'task.sync',
            enqueuedAt: now.add(const Duration(seconds: 2)),
          ),
        ]);

        final replaced = await store.readSyncQueue();
        expect(replaced.map((item) => item.itemId), ['queue-3']);
      },
    );

    test('deduplicates stable operations and updates replay status', () async {
      final store = MemoryLocalStore();
      final now = DateTime.utc(2026, 7, 7, 11);

      await store.appendSyncQueueItem(
        LocalSyncQueueItem(
          itemId: 'queue-original',
          operation: 'task_complete',
          operationId: 'op-1',
          eventId: 'event-1',
          sourceEventId: 'source-1',
          sequence: 1,
          enqueuedAt: now,
        ),
      );
      await store.appendSyncQueueItem(
        LocalSyncQueueItem(
          itemId: 'queue-duplicate',
          operation: 'task_complete',
          operationId: 'op-1',
          eventId: 'event-1',
          sourceEventId: 'source-1',
          sequence: 2,
          enqueuedAt: now.add(const Duration(seconds: 1)),
          dedupeKey: 'different-helper-key',
        ),
      );

      final original = await store.readSyncQueueItem('op-1');
      expect(original?.itemId, 'queue-original');
      expect(await store.readSyncQueue(), hasLength(1));

      await store.updateSyncQueueItem(
        original!.copyWith(
          status: LocalSyncQueueStatus.failed,
          attempt: 1,
          lastErrorCode: 'offline',
        ),
      );

      final updated = await store.readSyncQueueItem('op-1');
      expect(updated?.status, LocalSyncQueueStatus.failed);
      expect(updated?.attempt, 1);
      expect(updated?.lastErrorCode, 'offline');
    });

    test('does not return expired companion snapshots', () async {
      final store = MemoryLocalStore();
      final generatedAt = DateTime.utc(2026, 7, 7, 12);
      final expiresAt = generatedAt.add(const Duration(minutes: 5));

      await store.saveCompanionSnapshot(
        LocalCompanionSnapshot(
          snapshotId: 'snapshot-1',
          generatedAt: generatedAt,
          expiresAt: expiresAt,
          payload: {'streak': 3},
        ),
      );

      expect(
        await store.readCompanionSnapshot(
          now: expiresAt.subtract(const Duration(milliseconds: 1)),
        ),
        isNotNull,
      );
      expect(await store.readCompanionSnapshot(now: expiresAt), isNull);
    });

    test('clears all in-memory state', () async {
      final store = MemoryLocalStore();
      final now = DateTime.utc(2026, 7, 7, 13);

      await store.saveAccountState(
        LocalAccountState(accountId: 'user-1', isGuest: false, updatedAt: now),
      );
      await store.saveTaskSnapshot(
        LocalTaskSnapshot(taskId: 'task-1', updatedAt: now),
      );
      await store.appendEvent(
        LocalEventRecord(
          eventId: 'event-1',
          eventType: 'task.created',
          occurredAt: now,
        ),
      );
      await store.appendSyncQueueItem(
        LocalSyncQueueItem(
          itemId: 'queue-1',
          operation: 'task.created',
          enqueuedAt: now,
        ),
      );
      await store.saveNotificationSettings(
        LocalNotificationSettings(updatedAt: now),
      );
      await store.saveCompanionSnapshot(
        LocalCompanionSnapshot(
          snapshotId: 'snapshot-1',
          generatedAt: now,
          expiresAt: now.add(const Duration(minutes: 5)),
        ),
      );

      await store.clear();

      expect(await store.readAccountState(), isNull);
      expect(await store.readTaskSnapshots(), isEmpty);
      expect(await store.readEvents(), isEmpty);
      expect(await store.readSyncQueue(), isEmpty);
      expect(await store.readNotificationSettings(), isNull);
      expect(await store.readCompanionSnapshot(now: now), isNull);
    });
  });
}
