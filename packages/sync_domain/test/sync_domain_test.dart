import 'package:sync_domain/sync_domain.dart';
import 'package:test/test.dart';

void main() {
  test('builds a deterministic dedupe key', () {
    const draft = SyncQueueDraft(
      operationType: SyncOperationType.taskComplete,
      entityType: 'task',
      entityId: 'task_1',
      eventId: 'evt_1',
    );

    expect(draft.dedupeKey, 'taskComplete:task:task_1:evt_1');
  });
}

