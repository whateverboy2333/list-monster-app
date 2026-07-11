import 'package:companion_contract/companion_contract.dart';
import 'package:list_monster_app/companion_snapshot/companion_snapshot_builder.dart';
import 'package:list_monster_app/sync/sync_replay.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:local_store/local_store.dart';
import 'package:sync_domain/sync_domain.dart';

class AppSyncController {
  const AppSyncController({required this.localStore});

  final LocalStorePort localStore;

  Future<SyncQueueDraft> enqueueTaskOperation({
    required SyncOperationType operationType,
    required String taskId,
    required String eventId,
    String? operationId,
    String? sourceEventId,
    DateTime? enqueuedAt,
    Map<String, Object?> payload = const <String, Object?>{},
    int? baseRevision,
    int maxAttempts = 5,
  }) async {
    if (!_isReplayableTaskOperation(operationType)) {
      throw ArgumentError.value(
        operationType,
        'operationType',
        'Only task completion, undo, and restore operations can be queued.',
      );
    }

    final operation = SyncQueueDraft(
      operationType: operationType,
      entityType: 'task',
      entityId: taskId,
      eventId: eventId,
      operationId: operationId,
      sourceEventId: sourceEventId,
      sequence: _nextSequence(await localStore.readSyncQueue()),
      enqueuedAt: enqueuedAt ?? DateTime.now(),
      payload: payload,
      baseRevision: baseRevision,
      retry: SyncQueueRetry(maxAttempts: maxAttempts),
    );

    await localStore.appendSyncQueueItem(
      LocalSyncQueueItem(
        itemId: operation.operationId,
        operation: operation.operationType.contractName,
        enqueuedAt: operation.enqueuedAt!,
        operationId: operation.operationId,
        eventId: operation.eventId,
        sourceEventId: operation.sourceEventId,
        sequence: operation.sequence,
        baseRevision: operation.baseRevision,
        maxAttempts: maxAttempts,
        payload: {
          ...operation.payload,
          'entityType': operation.entityType,
          'entityId': operation.entityId,
          'operationId': operation.operationId,
          'eventId': operation.eventId,
          'sourceEventId': operation.sourceEventId,
        },
      ),
    );
    return operation;
  }

  Future<SyncQueueDraft> enqueueTaskComplete({
    required String taskId,
    required String eventId,
    String? operationId,
    String? sourceEventId,
    DateTime? enqueuedAt,
    Map<String, Object?> payload = const <String, Object?>{},
    int? baseRevision,
    int maxAttempts = 5,
  }) {
    return enqueueTaskOperation(
      operationType: SyncOperationType.taskComplete,
      taskId: taskId,
      eventId: eventId,
      operationId: operationId,
      sourceEventId: sourceEventId,
      enqueuedAt: enqueuedAt,
      payload: payload,
      baseRevision: baseRevision,
      maxAttempts: maxAttempts,
    );
  }

  Future<SyncQueueDraft> enqueueTaskUndoCompletion({
    required String taskId,
    required String eventId,
    String? operationId,
    String? sourceEventId,
    DateTime? enqueuedAt,
    Map<String, Object?> payload = const <String, Object?>{},
    int? baseRevision,
    int maxAttempts = 5,
  }) {
    return enqueueTaskOperation(
      operationType: SyncOperationType.taskUndoCompletion,
      taskId: taskId,
      eventId: eventId,
      operationId: operationId,
      sourceEventId: sourceEventId,
      enqueuedAt: enqueuedAt,
      payload: payload,
      baseRevision: baseRevision,
      maxAttempts: maxAttempts,
    );
  }

  Future<SyncQueueDraft> enqueueTaskRestore({
    required String taskId,
    required String eventId,
    String? operationId,
    String? sourceEventId,
    DateTime? enqueuedAt,
    Map<String, Object?> payload = const <String, Object?>{},
    int? baseRevision,
    int maxAttempts = 5,
  }) {
    return enqueueTaskOperation(
      operationType: SyncOperationType.taskRestore,
      taskId: taskId,
      eventId: eventId,
      operationId: operationId,
      sourceEventId: sourceEventId,
      enqueuedAt: enqueuedAt,
      payload: payload,
      baseRevision: baseRevision,
      maxAttempts: maxAttempts,
    );
  }

  Future<SyncReplayReport> replayPendingOperations({
    required SyncOperationConsumer consume,
    int? maxOperations,
    DateTime Function()? now,
  }) {
    return SyncReplay(
      localStore: localStore,
      now: now,
    ).replay(consume: consume, maxOperations: maxOperations);
  }

  Future<CompanionSnapshot> generateCompanionSnapshot(
    TaskSystemController controller, {
    DateTime? generatedAt,
  }) async {
    final snapshot = buildCompanionSnapshot(
      controller,
      generatedAt: generatedAt,
    );
    await localStore.saveCompanionSnapshot(
      LocalCompanionSnapshot(
        snapshotId: snapshot.snapshotId,
        generatedAt: snapshot.generatedAt,
        expiresAt: snapshot.generatedAt.add(
          Duration(seconds: snapshot.staleAfterSeconds),
        ),
        payload: snapshot.toJson(),
      ),
    );
    return snapshot;
  }
}

bool _isReplayableTaskOperation(SyncOperationType operationType) {
  return operationType == SyncOperationType.taskComplete ||
      operationType == SyncOperationType.taskUndoCompletion ||
      operationType == SyncOperationType.taskRestore;
}

int _nextSequence(List<LocalSyncQueueItem> items) {
  var largest = 0;
  for (final item in items) {
    if (item.sequence > largest) {
      largest = item.sequence;
    }
  }
  return largest + 1;
}
