import 'package:local_store/local_store.dart';
import 'package:sync_domain/sync_domain.dart';

class SyncReplayEvidence {
  const SyncReplayEvidence({
    required this.operationId,
    required this.eventId,
    required this.sourceEventId,
    required this.sequence,
    required this.operationType,
  });

  final String operationId;
  final String eventId;
  final String sourceEventId;
  final int sequence;
  final SyncOperationType operationType;
}

class SyncReplaySkip {
  const SyncReplaySkip({required this.evidence, required this.reason});

  final SyncReplayEvidence evidence;
  final String reason;
}

class SyncReplayFailure {
  const SyncReplayFailure({
    required this.evidence,
    required this.attempt,
    required this.maxAttempts,
    required this.errorCode,
  });

  final SyncReplayEvidence evidence;
  final int attempt;
  final int maxAttempts;
  final String errorCode;

  bool get retryable => attempt < maxAttempts;
}

class SyncReplayReport {
  const SyncReplayReport({
    required this.consumed,
    required this.skipped,
    required this.failures,
  });

  final List<SyncReplayEvidence> consumed;
  final List<SyncReplaySkip> skipped;
  final List<SyncReplayFailure> failures;

  int get consumedCount => consumed.length;

  int get skippedCount => skipped.length;

  int get failedCount => failures.length;

  bool get isBlocked => failures.any((failure) => !failure.retryable);

  bool get hasNoDuplicateConsumption {
    final operationIds = consumed.map((evidence) => evidence.operationId);
    return operationIds.length == operationIds.toSet().length;
  }

  bool get preservesOriginalEventIdentity {
    return consumed.every(
      (evidence) =>
          evidence.operationId.isNotEmpty &&
          evidence.eventId.isNotEmpty &&
          evidence.sourceEventId.isNotEmpty,
    );
  }

  List<String> get consumedOperationIds =>
      consumed.map((evidence) => evidence.operationId).toList(growable: false);

  List<String> get consumedSourceEventIds => consumed
      .map((evidence) => evidence.sourceEventId)
      .toList(growable: false);
}

class SyncReplay {
  SyncReplay({required this.localStore, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final LocalStorePort localStore;
  final DateTime Function() _now;

  Future<SyncReplayReport> replay({
    required SyncOperationConsumer consume,
    int? maxOperations,
  }) async {
    if (maxOperations != null && maxOperations <= 0) {
      return const SyncReplayReport(
        consumed: <SyncReplayEvidence>[],
        skipped: <SyncReplaySkip>[],
        failures: <SyncReplayFailure>[],
      );
    }

    final consumed = <SyncReplayEvidence>[];
    final skipped = <SyncReplaySkip>[];
    final failures = <SyncReplayFailure>[];
    final consumedOperationIds = <String>{};
    var attempted = 0;

    for (final item in await localStore.readSyncQueue()) {
      if (maxOperations != null && attempted >= maxOperations) {
        break;
      }

      final operationType = _operationTypeFor(item.operation);
      if (operationType == null) {
        final evidence = _evidenceFor(item, SyncOperationType.taskComplete);
        final attempt = item.attempt + 1;
        final errorCode = 'unknown_operation:${item.operation}';
        await localStore.updateSyncQueueItem(
          item.copyWith(
            status: LocalSyncQueueStatus.failed,
            attempt: attempt,
            lastErrorCode: errorCode,
          ),
        );
        failures.add(
          SyncReplayFailure(
            evidence: evidence,
            attempt: attempt,
            maxAttempts: item.maxAttempts,
            errorCode: errorCode,
          ),
        );
        break;
      }

      final evidence = _evidenceFor(item, operationType);
      if (item.status == LocalSyncQueueStatus.succeeded) {
        skipped.add(
          SyncReplaySkip(evidence: evidence, reason: 'already_succeeded'),
        );
        continue;
      }
      if (item.status == LocalSyncQueueStatus.conflicted) {
        skipped.add(SyncReplaySkip(evidence: evidence, reason: 'conflicted'));
        continue;
      }
      if (item.status == LocalSyncQueueStatus.failed && !item.canRetry) {
        failures.add(
          SyncReplayFailure(
            evidence: evidence,
            attempt: item.attempt,
            maxAttempts: item.maxAttempts,
            errorCode: item.lastErrorCode ?? 'retry_limit_reached',
          ),
        );
        break;
      }
      if (!consumedOperationIds.add(item.operationId)) {
        skipped.add(
          SyncReplaySkip(evidence: evidence, reason: 'duplicate_in_batch'),
        );
        continue;
      }

      attempted += 1;
      final operation = SyncQueueDraft(
        operationType: operationType,
        entityType: _stringPayload(item, 'entityType') ?? 'task',
        entityId: _stringPayload(item, 'entityId') ?? item.itemId,
        eventId: item.eventId,
        operationId: item.operationId,
        sourceEventId: item.sourceEventId,
        sequence: item.sequence,
        enqueuedAt: item.enqueuedAt,
        payload: item.payload,
        baseRevision: item.baseRevision,
        status: SyncQueueStatus.inFlight,
        retry: SyncQueueRetry(
          attempt: item.attempt,
          maxAttempts: item.maxAttempts,
          lastErrorCode: item.lastErrorCode,
        ),
      );

      await localStore.updateSyncQueueItem(
        item.copyWith(status: LocalSyncQueueStatus.inFlight),
      );

      try {
        await consume(operation);
      } on Object catch (error) {
        final attempt = item.attempt + 1;
        final errorCode = _errorCode(error);
        await localStore.updateSyncQueueItem(
          item.copyWith(
            status: LocalSyncQueueStatus.failed,
            attempt: attempt,
            lastErrorCode: errorCode,
          ),
        );
        failures.add(
          SyncReplayFailure(
            evidence: evidence,
            attempt: attempt,
            maxAttempts: item.maxAttempts,
            errorCode: errorCode,
          ),
        );
        break;
      }

      await localStore.updateSyncQueueItem(
        item.copyWith(
          status: LocalSyncQueueStatus.succeeded,
          completedAt: _now(),
          clearLastErrorCode: true,
        ),
      );
      consumed.add(evidence);
    }

    return SyncReplayReport(
      consumed: List.unmodifiable(consumed),
      skipped: List.unmodifiable(skipped),
      failures: List.unmodifiable(failures),
    );
  }
}

SyncReplayEvidence _evidenceFor(
  LocalSyncQueueItem item,
  SyncOperationType operationType,
) {
  return SyncReplayEvidence(
    operationId: item.operationId,
    eventId: item.eventId,
    sourceEventId: item.sourceEventId,
    sequence: item.sequence,
    operationType: operationType,
  );
}

SyncOperationType? _operationTypeFor(String operation) {
  final normalized = operation.replaceAll('.', '_');
  for (final type in SyncOperationType.values) {
    if (type.contractName == normalized) {
      return type;
    }
  }
  return null;
}

String? _stringPayload(LocalSyncQueueItem item, String key) {
  final value = item.payload[key];
  return value is String ? value : null;
}

String _errorCode(Object error) {
  if (error is StateError) {
    return error.message.toString();
  }
  return error.runtimeType.toString();
}
