enum SyncOperationType {
  taskComplete,
  taskCancel,
  taskRestore,
  taskDelete,
  taskUndoCompletion,
  longtermAchieve,
  longtermCancel,
}

class SyncQueueDraft {
  const SyncQueueDraft({
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.eventId,
  });

  final SyncOperationType operationType;
  final String entityType;
  final String entityId;
  final String eventId;

  String get dedupeKey => '${operationType.name}:$entityType:$entityId:$eventId';
}

