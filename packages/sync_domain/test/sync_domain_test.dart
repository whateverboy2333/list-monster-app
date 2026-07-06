import 'package:sync_domain/sync_domain.dart';
import 'package:test/test.dart';

void main() {
  test('builds a deterministic dedupe key with snake_case operation', () {
    const draft = SyncQueueDraft(
      operationType: SyncOperationType.taskComplete,
      entityType: 'task',
      entityId: 'task_1',
      eventId: 'evt_1',
    );

    expect(draft.operationType.contractName, 'task_complete');
    expect(draft.dedupeKey, 'task_complete:task:task_1:evt_1');
  });

  test(
    'queue draft carries payload, base revision, status, and retry state',
    () {
      const draft = SyncQueueDraft(
        operationType: SyncOperationType.taskComplete,
        entityType: 'task',
        entityId: 'task_1',
        eventId: 'evt_1',
        payload: <String, Object?>{'completed': true},
        baseRevision: 7,
        status: SyncQueueStatus.failed,
        retry: SyncQueueRetry(
          attempt: 2,
          maxAttempts: 4,
          lastErrorCode: 'timeout',
        ),
      );

      expect(draft.payload, containsPair('completed', true));
      expect(draft.baseRevision, 7);
      expect(draft.status, SyncQueueStatus.failed);
      expect(draft.retry.attempt, 2);
      expect(draft.retry.maxAttempts, 4);
      expect(draft.retry.lastErrorCode, 'timeout');
    },
  );

  test('detects concurrent task completion and cancellation conflict', () {
    const complete = SyncQueueDraft(
      operationType: SyncOperationType.taskComplete,
      entityType: 'task',
      entityId: 'task_1',
      eventId: 'evt_complete',
      baseRevision: 3,
    );
    const cancel = SyncQueueDraft(
      operationType: SyncOperationType.taskCancel,
      entityType: 'task',
      entityId: 'task_1',
      eventId: 'evt_cancel',
      baseRevision: 3,
    );

    final decision = detectSyncConflict(complete, cancel);

    expect(areConcurrentCompletionAndCancel(complete, cancel), isTrue);
    expect(decision.hasConflict, isTrue);
    expect(decision.strategy, SyncMergeStrategy.manualConflict);
    expect(decision.reasonCode, 'task_complete_cancel');
  });

  test('XP ledger is append-only and not last-write-wins', () {
    final policy = syncPolicyForProtectedFact(ProtectedSyncFact.xpLedger);

    expect(policy.allowsLastWriteWins, isFalse);
    expect(policy.raisesConflict, isFalse);
    expect(policy.strategy, SyncMergeStrategy.appendOnlyLedger);
    expect(
      protectedFactForOperation(SyncOperationType.xpLedgerAppend),
      ProtectedSyncFact.xpLedger,
    );
  });

  test('protected facts declare non-LWW merge strategies', () {
    for (final fact in ProtectedSyncFact.values) {
      final policy = syncPolicyForProtectedFact(fact);

      expect(policy.allowsLastWriteWins, isFalse, reason: fact.name);
    }
  });

  test('detects account deletion cooling period conflict', () {
    const startCoolingPeriod = SyncQueueDraft(
      operationType: SyncOperationType.accountDeletionCoolingPeriodStart,
      entityType: 'account',
      entityId: 'account_1',
      eventId: 'evt_start',
      baseRevision: 12,
    );
    const cancelCoolingPeriod = SyncQueueDraft(
      operationType: SyncOperationType.accountDeletionCoolingPeriodCancel,
      entityType: 'account',
      entityId: 'account_1',
      eventId: 'evt_cancel',
      baseRevision: 12,
    );

    final decision = detectSyncConflict(
      startCoolingPeriod,
      cancelCoolingPeriod,
    );

    expect(decision.hasConflict, isTrue);
    expect(decision.strategy, SyncMergeStrategy.preserveDeletionCoolingPeriod);
    expect(
      decision.protectedFact,
      ProtectedSyncFact.accountDeletionCoolingPeriod,
    );
    expect(decision.reasonCode, 'account_deletion_cooling_period_conflict');
  });
}
