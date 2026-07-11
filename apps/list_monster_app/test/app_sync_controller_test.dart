import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/sync/app_sync_controller.dart';
import 'package:local_store/local_store.dart';
import 'package:sync_domain/sync_domain.dart';

void main() {
  final firstAt = DateTime.utc(2026, 7, 7, 8);

  test('enqueues task completion, undo, and restore in stable order', () async {
    final store = MemoryLocalStore();
    final controller = AppSyncController(localStore: store);

    await controller.enqueueTaskComplete(
      taskId: 'task-1',
      operationId: 'op-complete',
      eventId: 'event-complete',
      sourceEventId: 'source-complete',
      enqueuedAt: firstAt,
    );
    await controller.enqueueTaskComplete(
      taskId: 'task-1',
      operationId: 'op-complete',
      eventId: 'event-complete',
      sourceEventId: 'source-complete',
      enqueuedAt: firstAt.add(const Duration(seconds: 1)),
    );
    await controller.enqueueTaskUndoCompletion(
      taskId: 'task-1',
      operationId: 'op-undo',
      eventId: 'event-undo',
      sourceEventId: 'source-undo',
      enqueuedAt: firstAt.add(const Duration(seconds: 2)),
    );
    await controller.enqueueTaskRestore(
      taskId: 'task-1',
      operationId: 'op-restore',
      eventId: 'event-restore',
      sourceEventId: 'source-restore',
      enqueuedAt: firstAt.add(const Duration(seconds: 3)),
    );

    final queue = await store.readSyncQueue();
    expect(queue, hasLength(3));
    expect(queue.map((item) => item.operationId), [
      'op-complete',
      'op-undo',
      'op-restore',
    ]);
    expect(queue.map((item) => item.sequence), [1, 2, 3]);
    expect(queue.first.sourceEventId, 'source-complete');
  });

  test(
    'replays in order, preserves event identity, and skips successes',
    () async {
      final store = MemoryLocalStore();
      final controller = AppSyncController(localStore: store);
      await controller.enqueueTaskComplete(
        taskId: 'task-1',
        operationId: 'op-1',
        eventId: 'event-1',
        sourceEventId: 'source-1',
        enqueuedAt: firstAt,
      );
      await controller.enqueueTaskUndoCompletion(
        taskId: 'task-1',
        operationId: 'op-2',
        eventId: 'event-2',
        sourceEventId: 'source-2',
        enqueuedAt: firstAt.add(const Duration(seconds: 1)),
      );

      final firstConsumed = <String>[];
      final firstReport = await controller.replayPendingOperations(
        now: () => firstAt.add(const Duration(minutes: 1)),
        consume: (operation) async {
          firstConsumed.add(
            '${operation.operationId}:${operation.eventId}:${operation.sourceEventId}',
          );
        },
      );

      expect(firstConsumed, ['op-1:event-1:source-1', 'op-2:event-2:source-2']);
      expect(firstReport.hasNoDuplicateConsumption, isTrue);
      expect(firstReport.preservesOriginalEventIdentity, isTrue);
      expect(firstReport.consumedSourceEventIds, ['source-1', 'source-2']);

      final secondConsumed = <String>[];
      final secondReport = await controller.replayPendingOperations(
        consume: (operation) async => secondConsumed.add(operation.operationId),
      );

      expect(secondConsumed, isEmpty);
      expect(secondReport.consumed, isEmpty);
      expect(secondReport.skipped.map((skip) => skip.reason), [
        'already_succeeded',
        'already_succeeded',
      ]);
    },
  );

  test(
    'retains failed operation for retry without replaying success',
    () async {
      final store = MemoryLocalStore();
      final controller = AppSyncController(localStore: store);
      for (final entry in [
        ('op-1', 'event-1', SyncOperationType.taskComplete),
        ('op-2', 'event-2', SyncOperationType.taskUndoCompletion),
        ('op-3', 'event-3', SyncOperationType.taskRestore),
      ]) {
        await controller.enqueueTaskOperation(
          operationType: entry.$3,
          taskId: 'task-1',
          operationId: entry.$1,
          eventId: entry.$2,
          sourceEventId: 'source-${entry.$1}',
          enqueuedAt: firstAt.add(
            Duration(
              seconds: entry.$1 == 'op-1'
                  ? 0
                  : int.parse(entry.$1.substring(3)),
            ),
          ),
          maxAttempts: 2,
        );
      }

      var shouldFail = true;
      final firstConsumed = <String>[];
      final firstReport = await controller.replayPendingOperations(
        consume: (operation) async {
          if (operation.operationId == 'op-2' && shouldFail) {
            shouldFail = false;
            throw StateError('offline');
          }
          firstConsumed.add(operation.operationId);
        },
      );

      expect(firstConsumed, ['op-1']);
      expect(firstReport.failures.single.evidence.operationId, 'op-2');
      expect(firstReport.failures.single.retryable, isTrue);

      final secondConsumed = <String>[];
      final secondReport = await controller.replayPendingOperations(
        consume: (operation) async => secondConsumed.add(operation.operationId),
      );

      expect(secondConsumed, ['op-2', 'op-3']);
      expect(secondReport.consumedOperationIds, ['op-2', 'op-3']);
      expect(
        (await store.readSyncQueue()).every(
          (item) => item.status == LocalSyncQueueStatus.succeeded,
        ),
        isTrue,
      );
    },
  );

  test(
    'blocks later operations after a failure reaches the retry limit',
    () async {
      final store = MemoryLocalStore();
      final controller = AppSyncController(localStore: store);
      await controller.enqueueTaskComplete(
        taskId: 'task-1',
        operationId: 'op-blocked',
        eventId: 'event-blocked',
        sourceEventId: 'source-blocked',
        enqueuedAt: firstAt,
        maxAttempts: 2,
      );
      await controller.enqueueTaskRestore(
        taskId: 'task-1',
        operationId: 'op-after-blocked',
        eventId: 'event-after-blocked',
        sourceEventId: 'source-after-blocked',
        enqueuedAt: firstAt.add(const Duration(seconds: 1)),
      );

      final consumed = <String>[];
      Future<void> alwaysFail(SyncQueueDraft operation) async {
        if (operation.operationId == 'op-after-blocked') {
          consumed.add(operation.operationId);
        }
        throw StateError('offline');
      }

      final firstReport = await controller.replayPendingOperations(
        consume: alwaysFail,
      );
      final secondReport = await controller.replayPendingOperations(
        consume: alwaysFail,
      );
      final thirdReport = await controller.replayPendingOperations(
        consume: alwaysFail,
      );

      expect(consumed, isEmpty);
      expect(firstReport.failures.single.evidence.operationId, 'op-blocked');
      expect(firstReport.failures.single.retryable, isTrue);
      expect(secondReport.failures.single.evidence.operationId, 'op-blocked');
      expect(secondReport.failures.single.retryable, isFalse);
      expect(secondReport.isBlocked, isTrue);
      expect(thirdReport.failures.single.evidence.operationId, 'op-blocked');
      expect(thirdReport.isBlocked, isTrue);
      expect((await store.readSyncQueue()).map((item) => item.status), [
        LocalSyncQueueStatus.failed,
        LocalSyncQueueStatus.pending,
      ]);
    },
  );
}
