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

class LocalSyncQueueItem {
  LocalSyncQueueItem({
    required this.itemId,
    required this.operation,
    required this.enqueuedAt,
    Map<String, Object?> payload = const {},
  }) : payload = _copyJsonMap(payload);

  final String itemId;
  final String operation;
  final DateTime enqueuedAt;
  final Map<String, Object?> payload;
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
    _syncQueue.add(item);
  }

  @override
  Future<List<LocalSyncQueueItem>> readSyncQueue() async {
    return List.unmodifiable(_syncQueue);
  }

  @override
  Future<void> replaceSyncQueue(List<LocalSyncQueueItem> items) async {
    _syncQueue
      ..clear()
      ..addAll(items);
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
