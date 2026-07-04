import 'package:sync_domain/sync_domain.dart';

void main() {
  const draft = SyncQueueDraft(
    operationType: SyncOperationType.taskComplete,
    entityType: 'task',
    entityId: 'task_1',
    eventId: 'evt_1',
  );

  print(draft.dedupeKey);
}

