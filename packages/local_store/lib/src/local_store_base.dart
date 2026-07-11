class LocalStoreModule {
  const LocalStoreModule(this.name);

  final String name;
}

abstract interface class LocalStorePort {
  Future<void> saveAccountState(LocalAccountState state);

  Future<LocalAccountState?> readAccountState();

  Future<void> saveTaskSnapshot(LocalTaskSnapshot snapshot);

  Future<LocalTaskSnapshot?> readTaskSnapshot(String taskId);

  Future<List<LocalTaskSnapshot>> readTaskSnapshots();

  Future<void> appendEvent(LocalEventRecord event);

  Future<List<LocalEventRecord>> readEvents();

  Future<void> appendSyncQueueItem(LocalSyncQueueItem item);

  Future<List<LocalSyncQueueItem>> readSyncQueue();

  Future<LocalSyncQueueItem?> readSyncQueueItem(String operationId);

  Future<void> updateSyncQueueItem(LocalSyncQueueItem item);

  Future<void> replaceSyncQueue(List<LocalSyncQueueItem> items);

  Future<void> saveNotificationSettings(LocalNotificationSettings settings);

  Future<LocalNotificationSettings?> readNotificationSettings();

  Future<void> saveCompanionSnapshot(LocalCompanionSnapshot snapshot);

  Future<LocalCompanionSnapshot?> readCompanionSnapshot({DateTime? now});

  Future<void> clear();
}

class LocalAccountState {
  LocalAccountState({
    required this.accountId,
    required this.isGuest,
    required this.updatedAt,
    Map<String, Object?> payload = const {},
  }) : payload = _copyJsonMap(payload);

  final String accountId;
  final bool isGuest;
  final DateTime updatedAt;
  final Map<String, Object?> payload;
}

class LocalTaskSnapshot {
  LocalTaskSnapshot({
    required this.taskId,
    required this.updatedAt,
    this.revision = 0,
    Map<String, Object?> payload = const {},
  }) : payload = _copyJsonMap(payload);

  final String taskId;
  final DateTime updatedAt;
  final int revision;
  final Map<String, Object?> payload;
}

class LocalEventRecord {
  LocalEventRecord({
    required this.eventId,
    required this.eventType,
    required this.occurredAt,
    Map<String, Object?> payload = const {},
  }) : payload = _copyJsonMap(payload);

  final String eventId;
  final String eventType;
  final DateTime occurredAt;
  final Map<String, Object?> payload;
}

enum LocalSyncQueueStatus { pending, inFlight, succeeded, failed, conflicted }

class LocalSyncQueueItem {
  LocalSyncQueueItem({
    required this.itemId,
    required this.operation,
    required this.enqueuedAt,
    String? operationId,
    String? eventId,
    String? sourceEventId,
    int? sequence,
    this.baseRevision,
    this.status = LocalSyncQueueStatus.pending,
    this.attempt = 0,
    this.maxAttempts = 5,
    this.lastErrorCode,
    this.completedAt,
    String? dedupeKey,
    Map<String, Object?> payload = const {},
  }) : operationId =
           operationId ?? _payloadString(payload, 'operationId') ?? itemId,
       eventId = eventId ?? _payloadString(payload, 'eventId') ?? itemId,
       sourceEventId =
           sourceEventId ??
           _payloadString(payload, 'sourceEventId') ??
           eventId ??
           _payloadString(payload, 'eventId') ??
           itemId,
       sequence = sequence ?? _payloadInt(payload, 'sequence') ?? 0,
       dedupeKey = dedupeKey ?? _payloadString(payload, 'dedupeKey'),
       payload = _copyJsonMap(payload);

  final String itemId;
  final String operation;
  final DateTime enqueuedAt;
  final String operationId;
  final String eventId;
  final String sourceEventId;
  final int sequence;
  final int? baseRevision;
  final LocalSyncQueueStatus status;
  final int attempt;
  final int maxAttempts;
  final String? lastErrorCode;
  final DateTime? completedAt;
  final String? dedupeKey;
  final Map<String, Object?> payload;

  String get identityKey => dedupeKey ?? operationId;

  int get retryAttempt => attempt;

  bool get canRetry => attempt < maxAttempts;

  LocalSyncQueueItem copyWith({
    String? itemId,
    String? operation,
    DateTime? enqueuedAt,
    String? operationId,
    String? eventId,
    String? sourceEventId,
    int? sequence,
    int? baseRevision,
    LocalSyncQueueStatus? status,
    int? attempt,
    int? maxAttempts,
    String? lastErrorCode,
    bool clearLastErrorCode = false,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    String? dedupeKey,
    Map<String, Object?>? payload,
  }) {
    return LocalSyncQueueItem(
      itemId: itemId ?? this.itemId,
      operation: operation ?? this.operation,
      enqueuedAt: enqueuedAt ?? this.enqueuedAt,
      operationId: operationId ?? this.operationId,
      eventId: eventId ?? this.eventId,
      sourceEventId: sourceEventId ?? this.sourceEventId,
      sequence: sequence ?? this.sequence,
      baseRevision: baseRevision ?? this.baseRevision,
      status: status ?? this.status,
      attempt: attempt ?? this.attempt,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      lastErrorCode: clearLastErrorCode
          ? null
          : lastErrorCode ?? this.lastErrorCode,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      payload: payload ?? this.payload,
    );
  }
}

class LocalNotificationSettings {
  LocalNotificationSettings({
    required this.updatedAt,
    this.enabled = true,
    this.privacyMode = 'private',
    this.doNotDisturbStartMinute,
    this.doNotDisturbEndMinute,
    Map<String, Object?> payload = const {},
  }) : payload = _copyJsonMap(payload);

  final bool enabled;
  final String privacyMode;
  final int? doNotDisturbStartMinute;
  final int? doNotDisturbEndMinute;
  final DateTime updatedAt;
  final Map<String, Object?> payload;
}

class LocalCompanionSnapshot {
  LocalCompanionSnapshot({
    required this.snapshotId,
    required this.generatedAt,
    required this.expiresAt,
    Map<String, Object?> payload = const {},
  }) : payload = _copyJsonMap(payload);

  final String snapshotId;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final Map<String, Object?> payload;

  bool isExpired(DateTime now) => !now.isBefore(expiresAt);
}

class MemoryLocalStore implements LocalStorePort {
  LocalAccountState? _accountState;
  final Map<String, LocalTaskSnapshot> _taskSnapshots = {};
  final List<LocalEventRecord> _events = [];
  final List<LocalSyncQueueItem> _syncQueue = [];
  LocalNotificationSettings? _notificationSettings;
  LocalCompanionSnapshot? _companionSnapshot;

  @override
  Future<void> saveAccountState(LocalAccountState state) async {
    _accountState = state;
  }

  @override
  Future<LocalAccountState?> readAccountState() async => _accountState;

  @override
  Future<void> saveTaskSnapshot(LocalTaskSnapshot snapshot) async {
    _taskSnapshots[snapshot.taskId] = snapshot;
  }

  @override
  Future<LocalTaskSnapshot?> readTaskSnapshot(String taskId) async {
    return _taskSnapshots[taskId];
  }

  @override
  Future<List<LocalTaskSnapshot>> readTaskSnapshots() async {
    return List.unmodifiable(_taskSnapshots.values);
  }

  @override
  Future<void> appendEvent(LocalEventRecord event) async {
    _events.add(event);
  }

  @override
  Future<List<LocalEventRecord>> readEvents() async {
    return List.unmodifiable(_events);
  }

  @override
  Future<void> appendSyncQueueItem(LocalSyncQueueItem item) async {
    if (_syncQueue.any(
      (queued) =>
          queued.operationId == item.operationId ||
          queued.identityKey == item.identityKey,
    )) {
      return;
    }

    final stored = item.sequence > 0
        ? item
        : item.copyWith(sequence: _nextSyncQueueSequence());
    _syncQueue.add(stored);
  }

  @override
  Future<List<LocalSyncQueueItem>> readSyncQueue() async {
    final ordered = List<LocalSyncQueueItem>.of(_syncQueue)
      ..sort(_compareSyncQueueItems);
    return List.unmodifiable(ordered);
  }

  @override
  Future<LocalSyncQueueItem?> readSyncQueueItem(String operationId) async {
    for (final item in _syncQueue) {
      if (item.operationId == operationId || item.identityKey == operationId) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<void> updateSyncQueueItem(LocalSyncQueueItem item) async {
    final index = _syncQueue.indexWhere(
      (queued) =>
          queued.itemId == item.itemId ||
          queued.operationId == item.operationId ||
          queued.identityKey == item.identityKey,
    );
    if (index == -1) {
      await appendSyncQueueItem(item);
      return;
    }

    _syncQueue[index] = item;
  }

  @override
  Future<void> replaceSyncQueue(List<LocalSyncQueueItem> items) async {
    _syncQueue.clear();
    for (final item in items) {
      await appendSyncQueueItem(item);
    }
  }

  @override
  Future<void> saveNotificationSettings(
    LocalNotificationSettings settings,
  ) async {
    _notificationSettings = settings;
  }

  @override
  Future<LocalNotificationSettings?> readNotificationSettings() async {
    return _notificationSettings;
  }

  @override
  Future<void> saveCompanionSnapshot(LocalCompanionSnapshot snapshot) async {
    _companionSnapshot = snapshot;
  }

  @override
  Future<LocalCompanionSnapshot?> readCompanionSnapshot({DateTime? now}) async {
    final snapshot = _companionSnapshot;
    if (snapshot == null) {
      return null;
    }

    final readAt = now ?? DateTime.now();
    if (snapshot.isExpired(readAt)) {
      return null;
    }

    return snapshot;
  }

  @override
  Future<void> clear() async {
    _accountState = null;
    _taskSnapshots.clear();
    _events.clear();
    _syncQueue.clear();
    _notificationSettings = null;
    _companionSnapshot = null;
  }

  int _nextSyncQueueSequence() {
    var largest = 0;
    for (final item in _syncQueue) {
      if (item.sequence > largest) {
        largest = item.sequence;
      }
    }
    return largest + 1;
  }
}

int _compareSyncQueueItems(LocalSyncQueueItem left, LocalSyncQueueItem right) {
  final sequenceComparison = left.sequence.compareTo(right.sequence);
  if (sequenceComparison != 0) {
    return sequenceComparison;
  }

  final timeComparison = left.enqueuedAt.compareTo(right.enqueuedAt);
  if (timeComparison != 0) {
    return timeComparison;
  }

  return left.itemId.compareTo(right.itemId);
}

String? _payloadString(Map<String, Object?> payload, String key) {
  final value = payload[key];
  return value is String ? value : null;
}

int? _payloadInt(Map<String, Object?> payload, String key) {
  final value = payload[key];
  return value is int ? value : null;
}

Map<String, Object?> _copyJsonMap(Map<String, Object?> source) {
  return Map.unmodifiable(
    source.map((key, value) => MapEntry(key, _copyJsonValue(value))),
  );
}

Object? _copyJsonValue(Object? value) {
  if (value is Map<String, Object?>) {
    return _copyJsonMap(value);
  }

  if (value is List<Object?>) {
    return List.unmodifiable(value.map(_copyJsonValue));
  }

  return value;
}
