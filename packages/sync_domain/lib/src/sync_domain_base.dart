enum SyncOperationType {
  taskComplete('task_complete'),
  taskCancel('task_cancel'),
  taskRestore('task_restore'),
  taskDelete('task_delete'),
  taskUndoCompletion('task_undo_completion'),
  longtermAchieve('longterm_achieve'),
  longtermCancel('longterm_cancel'),
  xpLedgerAppend('xp_ledger_append'),
  streakRecord('streak_record'),
  tombstoneCreate('tombstone_create'),
  tombstoneRestore('tombstone_restore'),
  guestMerge('guest_merge'),
  accountDeletionCoolingPeriodStart('account_deletion_cooling_period_start'),
  accountDeletionCoolingPeriodCancel('account_deletion_cooling_period_cancel');

  const SyncOperationType(this.contractName);

  final String contractName;
}

enum SyncQueueStatus { pending, inFlight, succeeded, failed, conflicted }

class SyncQueueRetry {
  const SyncQueueRetry({
    this.attempt = 0,
    this.maxAttempts = 5,
    this.lastErrorCode,
  });

  final int attempt;
  final int maxAttempts;
  final String? lastErrorCode;

  bool get canRetry => attempt < maxAttempts;

  SyncQueueRetry copyWith({
    int? attempt,
    int? maxAttempts,
    String? lastErrorCode,
    bool clearLastErrorCode = false,
  }) {
    return SyncQueueRetry(
      attempt: attempt ?? this.attempt,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      lastErrorCode: clearLastErrorCode
          ? null
          : lastErrorCode ?? this.lastErrorCode,
    );
  }
}

class SyncQueueDraft {
  const SyncQueueDraft({
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.eventId,
    String? operationId,
    String? sourceEventId,
    this.sequence = 0,
    this.enqueuedAt,
    this.payload = const <String, Object?>{},
    this.baseRevision,
    this.status = SyncQueueStatus.pending,
    this.retry = const SyncQueueRetry(),
  }) : operationId = operationId ?? eventId,
       sourceEventId = sourceEventId ?? eventId;

  factory SyncQueueDraft.taskComplete({
    required String taskId,
    required String eventId,
    String? operationId,
    String? sourceEventId,
    int sequence = 0,
    DateTime? enqueuedAt,
    Map<String, Object?> payload = const <String, Object?>{},
    int? baseRevision,
  }) {
    return SyncQueueDraft(
      operationType: SyncOperationType.taskComplete,
      entityType: 'task',
      entityId: taskId,
      eventId: eventId,
      operationId: operationId,
      sourceEventId: sourceEventId,
      sequence: sequence,
      enqueuedAt: enqueuedAt,
      payload: payload,
      baseRevision: baseRevision,
    );
  }

  factory SyncQueueDraft.taskUndoCompletion({
    required String taskId,
    required String eventId,
    String? operationId,
    String? sourceEventId,
    int sequence = 0,
    DateTime? enqueuedAt,
    Map<String, Object?> payload = const <String, Object?>{},
    int? baseRevision,
  }) {
    return SyncQueueDraft(
      operationType: SyncOperationType.taskUndoCompletion,
      entityType: 'task',
      entityId: taskId,
      eventId: eventId,
      operationId: operationId,
      sourceEventId: sourceEventId,
      sequence: sequence,
      enqueuedAt: enqueuedAt,
      payload: payload,
      baseRevision: baseRevision,
    );
  }

  factory SyncQueueDraft.taskRestore({
    required String taskId,
    required String eventId,
    String? operationId,
    String? sourceEventId,
    int sequence = 0,
    DateTime? enqueuedAt,
    Map<String, Object?> payload = const <String, Object?>{},
    int? baseRevision,
  }) {
    return SyncQueueDraft(
      operationType: SyncOperationType.taskRestore,
      entityType: 'task',
      entityId: taskId,
      eventId: eventId,
      operationId: operationId,
      sourceEventId: sourceEventId,
      sequence: sequence,
      enqueuedAt: enqueuedAt,
      payload: payload,
      baseRevision: baseRevision,
    );
  }

  final SyncOperationType operationType;
  final String entityType;
  final String entityId;
  final String eventId;
  final String operationId;
  final String sourceEventId;
  final int sequence;
  final DateTime? enqueuedAt;
  final Map<String, Object?> payload;
  final int? baseRevision;
  final SyncQueueStatus status;
  final SyncQueueRetry retry;

  String get dedupeKey =>
      '${operationType.contractName}:$entityType:$entityId:$eventId';

  String get identityKey => operationId;

  SyncQueueDraft copyWith({
    SyncOperationType? operationType,
    String? entityType,
    String? entityId,
    String? eventId,
    String? operationId,
    String? sourceEventId,
    int? sequence,
    DateTime? enqueuedAt,
    Map<String, Object?>? payload,
    int? baseRevision,
    SyncQueueStatus? status,
    SyncQueueRetry? retry,
  }) {
    return SyncQueueDraft(
      operationType: operationType ?? this.operationType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      eventId: eventId ?? this.eventId,
      operationId: operationId ?? this.operationId,
      sourceEventId: sourceEventId ?? this.sourceEventId,
      sequence: sequence ?? this.sequence,
      enqueuedAt: enqueuedAt ?? this.enqueuedAt,
      payload: payload ?? this.payload,
      baseRevision: baseRevision ?? this.baseRevision,
      status: status ?? this.status,
      retry: retry ?? this.retry,
    );
  }
}

typedef SyncOperationConsumer = Future<void> Function(SyncQueueDraft operation);

enum ProtectedSyncFact {
  xpLedger,
  streak,
  tombstone,
  restore,
  guestMerge,
  accountDeletionCoolingPeriod,
}

enum SyncMergeStrategy {
  lastWriteWins,
  manualConflict,
  appendOnlyLedger,
  orderedLedger,
  tombstoneRestoreConflict,
  guestIdentityMerge,
  preserveDeletionCoolingPeriod,
}

class SyncProtectedFactPolicy {
  const SyncProtectedFactPolicy({
    required this.fact,
    required this.strategy,
    required this.allowsLastWriteWins,
    required this.raisesConflict,
    required this.reasonCode,
  });

  final ProtectedSyncFact fact;
  final SyncMergeStrategy strategy;
  final bool allowsLastWriteWins;
  final bool raisesConflict;
  final String reasonCode;
}

class SyncConflictDecision {
  const SyncConflictDecision({
    required this.hasConflict,
    required this.strategy,
    required this.reasonCode,
    this.protectedFact,
  });

  static const none = SyncConflictDecision(
    hasConflict: false,
    strategy: SyncMergeStrategy.lastWriteWins,
    reasonCode: 'none',
  );

  final bool hasConflict;
  final SyncMergeStrategy strategy;
  final String reasonCode;
  final ProtectedSyncFact? protectedFact;
}

const _protectedFactPolicies = <ProtectedSyncFact, SyncProtectedFactPolicy>{
  ProtectedSyncFact.xpLedger: SyncProtectedFactPolicy(
    fact: ProtectedSyncFact.xpLedger,
    strategy: SyncMergeStrategy.appendOnlyLedger,
    allowsLastWriteWins: false,
    raisesConflict: false,
    reasonCode: 'xp_ledger_append_only',
  ),
  ProtectedSyncFact.streak: SyncProtectedFactPolicy(
    fact: ProtectedSyncFact.streak,
    strategy: SyncMergeStrategy.orderedLedger,
    allowsLastWriteWins: false,
    raisesConflict: false,
    reasonCode: 'streak_ordered_ledger',
  ),
  ProtectedSyncFact.tombstone: SyncProtectedFactPolicy(
    fact: ProtectedSyncFact.tombstone,
    strategy: SyncMergeStrategy.tombstoneRestoreConflict,
    allowsLastWriteWins: false,
    raisesConflict: true,
    reasonCode: 'tombstone_restore_conflict',
  ),
  ProtectedSyncFact.restore: SyncProtectedFactPolicy(
    fact: ProtectedSyncFact.restore,
    strategy: SyncMergeStrategy.tombstoneRestoreConflict,
    allowsLastWriteWins: false,
    raisesConflict: true,
    reasonCode: 'tombstone_restore_conflict',
  ),
  ProtectedSyncFact.guestMerge: SyncProtectedFactPolicy(
    fact: ProtectedSyncFact.guestMerge,
    strategy: SyncMergeStrategy.guestIdentityMerge,
    allowsLastWriteWins: false,
    raisesConflict: true,
    reasonCode: 'guest_merge_requires_identity_map',
  ),
  ProtectedSyncFact.accountDeletionCoolingPeriod: SyncProtectedFactPolicy(
    fact: ProtectedSyncFact.accountDeletionCoolingPeriod,
    strategy: SyncMergeStrategy.preserveDeletionCoolingPeriod,
    allowsLastWriteWins: false,
    raisesConflict: true,
    reasonCode: 'account_deletion_cooling_period_conflict',
  ),
};

SyncProtectedFactPolicy syncPolicyForProtectedFact(ProtectedSyncFact fact) =>
    _protectedFactPolicies[fact]!;

ProtectedSyncFact? protectedFactForOperation(SyncOperationType operationType) {
  switch (operationType) {
    case SyncOperationType.xpLedgerAppend:
      return ProtectedSyncFact.xpLedger;
    case SyncOperationType.streakRecord:
      return ProtectedSyncFact.streak;
    case SyncOperationType.taskDelete:
    case SyncOperationType.tombstoneCreate:
      return ProtectedSyncFact.tombstone;
    case SyncOperationType.taskRestore:
    case SyncOperationType.tombstoneRestore:
      return ProtectedSyncFact.restore;
    case SyncOperationType.guestMerge:
      return ProtectedSyncFact.guestMerge;
    case SyncOperationType.accountDeletionCoolingPeriodStart:
    case SyncOperationType.accountDeletionCoolingPeriodCancel:
      return ProtectedSyncFact.accountDeletionCoolingPeriod;
    case SyncOperationType.taskComplete:
    case SyncOperationType.taskCancel:
    case SyncOperationType.taskUndoCompletion:
    case SyncOperationType.longtermAchieve:
    case SyncOperationType.longtermCancel:
      return null;
  }
}

bool areConcurrentCompletionAndCancel(
  SyncQueueDraft left,
  SyncQueueDraft right,
) => detectSyncConflict(left, right).reasonCode == 'task_complete_cancel';

SyncConflictDecision detectSyncConflict(
  SyncQueueDraft left,
  SyncQueueDraft right,
) {
  if (!_sameEntity(left, right) || !_sameConflictWindow(left, right)) {
    return SyncConflictDecision.none;
  }

  if (_isTaskCompleteCancelPair(left.operationType, right.operationType)) {
    return const SyncConflictDecision(
      hasConflict: true,
      strategy: SyncMergeStrategy.manualConflict,
      reasonCode: 'task_complete_cancel',
    );
  }

  final leftFact = protectedFactForOperation(left.operationType);
  final rightFact = protectedFactForOperation(right.operationType);
  final protectedFact = _conflictingProtectedFact(leftFact, rightFact);
  if (protectedFact == null) {
    return SyncConflictDecision.none;
  }

  final policy = syncPolicyForProtectedFact(protectedFact);
  if (!policy.raisesConflict) {
    return SyncConflictDecision.none;
  }

  return SyncConflictDecision(
    hasConflict: true,
    strategy: policy.strategy,
    reasonCode: policy.reasonCode,
    protectedFact: policy.fact,
  );
}

bool _sameEntity(SyncQueueDraft left, SyncQueueDraft right) =>
    left.entityType == right.entityType && left.entityId == right.entityId;

bool _sameConflictWindow(SyncQueueDraft left, SyncQueueDraft right) {
  final leftRevision = left.baseRevision;
  final rightRevision = right.baseRevision;
  if (leftRevision == null || rightRevision == null) {
    return true;
  }

  return leftRevision == rightRevision;
}

bool _isTaskCompleteCancelPair(
  SyncOperationType left,
  SyncOperationType right,
) =>
    (_isTaskCompletion(left) && _isTaskCancellation(right)) ||
    (_isTaskCompletion(right) && _isTaskCancellation(left));

bool _isTaskCompletion(SyncOperationType operationType) =>
    operationType == SyncOperationType.taskComplete;

bool _isTaskCancellation(SyncOperationType operationType) =>
    operationType == SyncOperationType.taskCancel ||
    operationType == SyncOperationType.taskUndoCompletion;

ProtectedSyncFact? _conflictingProtectedFact(
  ProtectedSyncFact? left,
  ProtectedSyncFact? right,
) {
  if (left == null) {
    return right;
  }
  if (right == null || left == right) {
    return left;
  }

  final facts = {left, right};
  if (facts.contains(ProtectedSyncFact.tombstone) &&
      facts.contains(ProtectedSyncFact.restore)) {
    return ProtectedSyncFact.tombstone;
  }

  return null;
}
