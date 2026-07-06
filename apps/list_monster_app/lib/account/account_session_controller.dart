import 'package:account_domain/account_domain.dart';
import 'package:flutter/foundation.dart';
import 'package:local_store/local_store.dart';
import 'package:sync_domain/sync_domain.dart';

enum SimulatedLoginOutcome {
  signedIn,
  mergeConfirmationRequired,
  readOnlyBlocked,
}

class AccountSessionController extends ChangeNotifier {
  AccountSessionController({
    LocalStorePort? localStore,
    DateTime Function()? now,
    this.mockCloudTaskCount = 2,
  }) : localStore = localStore ?? MemoryLocalStore(),
       _now = now ?? DateTime.now,
       _account = Account.createGuest(
         accountId: _defaultGuestAccountId,
         createdAt: (now ?? DateTime.now)(),
       );

  static const _defaultGuestAccountId = 'local_guest';
  static const _mockRegisteredAccountId = 'mock_user_1';
  static const _mockProviderUserId = 'mock_phone_user_1';

  final LocalStorePort localStore;
  final DateTime Function() _now;
  final int mockCloudTaskCount;

  Account _account;
  GuestMergeJob? _pendingMergeJob;
  Account? _pendingRegisteredAccount;
  int _pendingGuestTaskCount = 0;
  int _pendingCloudTaskCount = 0;
  int _queueNumber = 1;
  int _mergeNumber = 1;
  bool _restored = false;

  Account get account => _account;
  AccountStatus get status => _account.status;
  GuestMergeJob? get pendingMergeJob => _pendingMergeJob;
  bool get hasPendingMerge => _pendingMergeJob?.needsConfirmation ?? false;
  int get pendingGuestTaskCount => _pendingGuestTaskCount;
  int get pendingCloudTaskCount => _pendingCloudTaskCount;
  bool get isReadOnly => _account.isReadOnlyAt(_now());

  Future<void> restore() async {
    if (_restored) {
      return;
    }
    final state = await localStore.readAccountState();
    if (state == null) {
      _restored = true;
      await _persist();
      notifyListeners();
      return;
    }

    _account = _accountFromPayload(state.payload, fallback: state);
    final pendingMerge = state.payload['pendingMerge'];
    if (pendingMerge is Map<String, Object?>) {
      _pendingMergeJob = _mergeJobFromPayload(pendingMerge);
      final registeredAccount = pendingMerge['registeredAccount'];
      if (registeredAccount is Map<String, Object?>) {
        _pendingRegisteredAccount = _accountFromMap(registeredAccount);
      }
      _pendingGuestTaskCount = _intValue(pendingMerge['guestTaskCount']) ?? 0;
      _pendingCloudTaskCount = _intValue(pendingMerge['cloudTaskCount']) ?? 0;
    }

    _restored = true;
    notifyListeners();
  }

  Future<SimulatedLoginOutcome> simulateLogin({
    required int guestTaskCount,
    int? cloudTaskCount,
  }) async {
    if (isReadOnly) {
      return SimulatedLoginOutcome.readOnlyBlocked;
    }

    final loginAt = _now();
    final identity = const LocalAuthIdentity.phone(_mockProviderUserId);
    final cloudCount = cloudTaskCount ?? mockCloudTaskCount;
    final hasGuestCloudConflict =
        _account.isGuest && guestTaskCount > 0 && cloudCount > 0;

    if (hasGuestCloudConflict) {
      final registeredAccount = Account.createRegistered(
        accountId: _mockRegisteredAccountId,
        identity: identity,
        createdAt: loginAt,
      );
      _pendingRegisteredAccount = registeredAccount;
      _pendingGuestTaskCount = guestTaskCount;
      _pendingCloudTaskCount = cloudCount;
      _pendingMergeJob = GuestMergeJob.create(
        jobId: 'merge_${_mergeNumber++}',
        guestAccount: _account,
        registeredAccount: registeredAccount,
        createdAt: loginAt,
      );
      await _persist();
      notifyListeners();
      return SimulatedLoginOutcome.mergeConfirmationRequired;
    }

    _account = _account.isGuest
        ? _account.simulateLogin(identity: identity, loginAt: loginAt)
        : _account.simulateLogin(identity: identity, loginAt: loginAt);
    _clearPendingMerge();
    await _persist();
    notifyListeners();
    return SimulatedLoginOutcome.signedIn;
  }

  Future<void> confirmPendingMerge() async {
    final pendingJob = _pendingMergeJob;
    final registeredAccount = _pendingRegisteredAccount;
    if (pendingJob == null ||
        registeredAccount == null ||
        !pendingJob.needsConfirmation) {
      return;
    }

    final confirmed = pendingJob.confirm(confirmedAt: _now());
    _pendingMergeJob = confirmed.markMerged(mergedAt: _now());
    _account = registeredAccount;
    await _appendSyncQueueItem(
      SyncOperationType.guestMerge,
      entityType: 'account',
      entityId: _account.accountId,
      eventId: _pendingMergeJob!.jobId,
      payload: {
        'guestAccountId': pendingJob.guestAccountId,
        'registeredAccountId': pendingJob.registeredAccountId,
        'guestTaskCount': _pendingGuestTaskCount,
        'cloudTaskCount': _pendingCloudTaskCount,
      },
    );
    _clearPendingMerge();
    await _persist();
    notifyListeners();
  }

  Future<void> cancelPendingMerge() async {
    final pendingJob = _pendingMergeJob;
    if (pendingJob == null || pendingJob.isTerminal) {
      return;
    }
    _pendingMergeJob = pendingJob.cancel(cancelledAt: _now());
    _clearPendingMerge();
    await _persist();
    notifyListeners();
  }

  Future<bool> requestDeletion() async {
    if (!_account.canRequestDeletion || isReadOnly) {
      return false;
    }

    _account = _account.requestDeletion(requestedAt: _now());
    _clearPendingMerge();
    await _appendSyncQueueItem(
      SyncOperationType.accountDeletionCoolingPeriodStart,
      entityType: 'account',
      entityId: _account.accountId,
      eventId: 'account_deletion_start_$_queueNumber',
      payload: {
        'deletionRequestedAt': _formatDateTime(_account.deletionRequestedAt),
        'deletionEffectiveAt': _formatDateTime(_account.deletionEffectiveAt),
      },
    );
    await _persist();
    notifyListeners();
    return true;
  }

  Future<bool> cancelDeletion() async {
    if (!_account.isDeletionPending) {
      return false;
    }

    final previousEffectiveAt = _account.deletionEffectiveAt;
    _account = _account.cancelDeletion(cancelledAt: _now());
    await _appendSyncQueueItem(
      SyncOperationType.accountDeletionCoolingPeriodCancel,
      entityType: 'account',
      entityId: _account.accountId,
      eventId: 'account_deletion_cancel_$_queueNumber',
      payload: {
        'previousDeletionEffectiveAt': _formatDateTime(previousEffectiveAt),
      },
    );
    await _persist();
    notifyListeners();
    return true;
  }

  void _clearPendingMerge() {
    _pendingMergeJob = null;
    _pendingRegisteredAccount = null;
    _pendingGuestTaskCount = 0;
    _pendingCloudTaskCount = 0;
  }

  Future<void> _persist() async {
    await localStore.saveAccountState(
      LocalAccountState(
        accountId: _account.accountId,
        isGuest: _account.isGuest,
        updatedAt: _now(),
        payload: {
          'account': _accountToMap(_account),
          if (_pendingMergeJob != null)
            'pendingMerge': {
              ..._mergeJobToMap(_pendingMergeJob!),
              if (_pendingRegisteredAccount != null)
                'registeredAccount': _accountToMap(_pendingRegisteredAccount!),
              'guestTaskCount': _pendingGuestTaskCount,
              'cloudTaskCount': _pendingCloudTaskCount,
            },
        },
      ),
    );
  }

  Future<void> _appendSyncQueueItem(
    SyncOperationType operationType, {
    required String entityType,
    required String entityId,
    required String eventId,
    Map<String, Object?> payload = const {},
  }) async {
    final draft = SyncQueueDraft(
      operationType: operationType,
      entityType: entityType,
      entityId: entityId,
      eventId: eventId,
      payload: payload,
    );
    await localStore.appendSyncQueueItem(
      LocalSyncQueueItem(
        itemId: 'account_queue_${_queueNumber++}',
        operation: draft.operationType.contractName,
        enqueuedAt: _now(),
        payload: {
          'dedupeKey': draft.dedupeKey,
          'entityType': draft.entityType,
          'entityId': draft.entityId,
          'eventId': draft.eventId,
          ...draft.payload,
        },
      ),
    );
  }
}

Account _accountFromPayload(
  Map<String, Object?> payload, {
  required LocalAccountState fallback,
}) {
  final account = payload['account'];
  if (account is Map<String, Object?>) {
    return _accountFromMap(account);
  }

  final now = fallback.updatedAt;
  return fallback.isGuest
      ? Account.createGuest(accountId: fallback.accountId, createdAt: now)
      : Account.createRegistered(
          accountId: fallback.accountId,
          identity: const LocalAuthIdentity.phone('restored_mock_user'),
          createdAt: now,
        );
}

Account _accountFromMap(Map<String, Object?> map) {
  return Account(
    accountId: _stringValue(map['accountId']) ?? _defaultRestoredAccountId,
    status: _accountStatusFromName(_stringValue(map['status'])),
    createdAt:
        _dateTimeValue(map['createdAt']) ??
        DateTime.fromMillisecondsSinceEpoch(0),
    registeredAt: _dateTimeValue(map['registeredAt']),
    providerLinks: _providerLinksFromPayload(map['providerLinks']),
    deletionRequestedAt: _dateTimeValue(map['deletionRequestedAt']),
    deletionEffectiveAt: _dateTimeValue(map['deletionEffectiveAt']),
    statusBeforeDeletion: _accountStatusFromNameOrNull(
      _stringValue(map['statusBeforeDeletion']),
    ),
    deletedAt: _dateTimeValue(map['deletedAt']),
  );
}

const _defaultRestoredAccountId = 'restored_account';

Map<String, Object?> _accountToMap(Account account) {
  return {
    'accountId': account.accountId,
    'status': account.status.contractName,
    'createdAt': _formatDateTime(account.createdAt),
    'registeredAt': _formatDateTime(account.registeredAt),
    'providerLinks': account.providerLinks
        .map(
          (link) => {
            'provider': link.provider.contractName,
            'providerUserId': link.providerUserId,
            'linkedAt': _formatDateTime(link.linkedAt),
            'lastLoginAt': _formatDateTime(link.lastLoginAt),
          },
        )
        .toList(growable: false),
    'deletionRequestedAt': _formatDateTime(account.deletionRequestedAt),
    'deletionEffectiveAt': _formatDateTime(account.deletionEffectiveAt),
    'statusBeforeDeletion': account.statusBeforeDeletion?.contractName,
    'deletedAt': _formatDateTime(account.deletedAt),
  };
}

List<AccountProviderLink> _providerLinksFromPayload(Object? value) {
  if (value is! List<Object?>) {
    return const [];
  }
  return value
      .whereType<Map<String, Object?>>()
      .map((map) {
        return AccountProviderLink(
          provider: _authProviderFromName(_stringValue(map['provider'])),
          providerUserId:
              _stringValue(map['providerUserId']) ?? 'restored_user',
          linkedAt:
              _dateTimeValue(map['linkedAt']) ??
              DateTime.fromMillisecondsSinceEpoch(0),
          lastLoginAt:
              _dateTimeValue(map['lastLoginAt']) ??
              DateTime.fromMillisecondsSinceEpoch(0),
        );
      })
      .toList(growable: false);
}

GuestMergeJob _mergeJobFromPayload(Map<String, Object?> map) {
  return GuestMergeJob(
    jobId: _stringValue(map['jobId']) ?? 'restored_merge',
    guestAccountId: _stringValue(map['guestAccountId']) ?? 'local_guest',
    registeredAccountId:
        _stringValue(map['registeredAccountId']) ?? 'mock_user_1',
    status: _mergeStatusFromName(_stringValue(map['status'])),
    createdAt:
        _dateTimeValue(map['createdAt']) ??
        DateTime.fromMillisecondsSinceEpoch(0),
    confirmedAt: _dateTimeValue(map['confirmedAt']),
    cancelledAt: _dateTimeValue(map['cancelledAt']),
    mergedAt: _dateTimeValue(map['mergedAt']),
  );
}

Map<String, Object?> _mergeJobToMap(GuestMergeJob job) {
  return {
    'jobId': job.jobId,
    'guestAccountId': job.guestAccountId,
    'registeredAccountId': job.registeredAccountId,
    'status': job.status.contractName,
    'createdAt': _formatDateTime(job.createdAt),
    'confirmedAt': _formatDateTime(job.confirmedAt),
    'cancelledAt': _formatDateTime(job.cancelledAt),
    'mergedAt': _formatDateTime(job.mergedAt),
  };
}

AccountStatus _accountStatusFromName(String? value) {
  return _accountStatusFromNameOrNull(value) ?? AccountStatus.guest;
}

AccountStatus? _accountStatusFromNameOrNull(String? value) {
  return switch (value) {
    'guest' => AccountStatus.guest,
    'registered' => AccountStatus.registered,
    'deletion_pending' => AccountStatus.deletionPending,
    'deleted' => AccountStatus.deleted,
    _ => null,
  };
}

AuthProvider _authProviderFromName(String? value) {
  return switch (value) {
    'wechat' => AuthProvider.wechat,
    _ => AuthProvider.phone,
  };
}

GuestMergeJobStatus _mergeStatusFromName(String? value) {
  return switch (value) {
    'confirmed' => GuestMergeJobStatus.confirmed,
    'cancelled' => GuestMergeJobStatus.cancelled,
    'merged' => GuestMergeJobStatus.merged,
    _ => GuestMergeJobStatus.pendingConfirmation,
  };
}

String? _stringValue(Object? value) => value is String ? value : null;

int? _intValue(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num && value % 1 == 0) {
    return value.toInt();
  }
  return null;
}

DateTime? _dateTimeValue(Object? value) {
  if (value is DateTime) {
    return value;
  }
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

String? _formatDateTime(DateTime? value) => value?.toUtc().toIso8601String();
