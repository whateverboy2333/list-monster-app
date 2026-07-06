enum AccountStatus { guest, registered, deletionPending, deleted }

enum AuthProvider { phone, wechat }

enum GuestMergeJobStatus { pendingConfirmation, confirmed, cancelled, merged }

extension AccountStatusContractName on AccountStatus {
  String get contractName {
    return switch (this) {
      AccountStatus.guest => 'guest',
      AccountStatus.registered => 'registered',
      AccountStatus.deletionPending => 'deletion_pending',
      AccountStatus.deleted => 'deleted',
    };
  }
}

extension AuthProviderContractName on AuthProvider {
  String get contractName {
    return switch (this) {
      AuthProvider.phone => 'phone',
      AuthProvider.wechat => 'wechat',
    };
  }
}

extension GuestMergeJobStatusContractName on GuestMergeJobStatus {
  String get contractName {
    return switch (this) {
      GuestMergeJobStatus.pendingConfirmation => 'pending_confirmation',
      GuestMergeJobStatus.confirmed => 'confirmed',
      GuestMergeJobStatus.cancelled => 'cancelled',
      GuestMergeJobStatus.merged => 'merged',
    };
  }
}

class LocalAuthIdentity {
  const LocalAuthIdentity({
    required this.provider,
    required this.providerUserId,
  });

  const LocalAuthIdentity.phone(String localPhoneUserId)
    : this(provider: AuthProvider.phone, providerUserId: localPhoneUserId);

  const LocalAuthIdentity.wechat(String localWechatUserId)
    : this(provider: AuthProvider.wechat, providerUserId: localWechatUserId);

  final AuthProvider provider;
  final String providerUserId;

  void validate() {
    if (providerUserId.trim().isEmpty) {
      throw ArgumentError.value(
        providerUserId,
        'providerUserId',
        'Provider user id cannot be blank.',
      );
    }
  }
}

class AccountProviderLink {
  const AccountProviderLink({
    required this.provider,
    required this.providerUserId,
    required this.linkedAt,
    required this.lastLoginAt,
  });

  factory AccountProviderLink.fromIdentity({
    required LocalAuthIdentity identity,
    required DateTime loginAt,
  }) {
    identity.validate();

    return AccountProviderLink(
      provider: identity.provider,
      providerUserId: identity.providerUserId.trim(),
      linkedAt: loginAt,
      lastLoginAt: loginAt,
    );
  }

  final AuthProvider provider;
  final String providerUserId;
  final DateTime linkedAt;
  final DateTime lastLoginAt;

  String get providerName => provider.contractName;

  AccountProviderLink recordLogin({required DateTime loginAt}) {
    return AccountProviderLink(
      provider: provider,
      providerUserId: providerUserId,
      linkedAt: linkedAt,
      lastLoginAt: loginAt,
    );
  }
}

class Account {
  Account({
    required this.accountId,
    required this.status,
    required this.createdAt,
    List<AccountProviderLink> providerLinks = const [],
    this.registeredAt,
    this.deletionRequestedAt,
    this.deletionEffectiveAt,
    this.statusBeforeDeletion,
    this.deletedAt,
  }) : providerLinks = List.unmodifiable(providerLinks);

  factory Account.createGuest({
    required String accountId,
    required DateTime createdAt,
  }) {
    _requireNonBlank(accountId, 'accountId');

    return Account(
      accountId: accountId.trim(),
      status: AccountStatus.guest,
      createdAt: createdAt,
    );
  }

  factory Account.createRegistered({
    required String accountId,
    required LocalAuthIdentity identity,
    required DateTime createdAt,
  }) {
    _requireNonBlank(accountId, 'accountId');

    final link = AccountProviderLink.fromIdentity(
      identity: identity,
      loginAt: createdAt,
    );

    return Account(
      accountId: accountId.trim(),
      status: AccountStatus.registered,
      createdAt: createdAt,
      registeredAt: createdAt,
      providerLinks: [link],
    );
  }

  static const deletionCoolingOffPeriod = Duration(days: 15);

  final String accountId;
  final AccountStatus status;
  final DateTime createdAt;
  final DateTime? registeredAt;
  final List<AccountProviderLink> providerLinks;
  final DateTime? deletionRequestedAt;
  final DateTime? deletionEffectiveAt;
  final AccountStatus? statusBeforeDeletion;
  final DateTime? deletedAt;

  bool get isGuest => status == AccountStatus.guest;
  bool get isRegistered => status == AccountStatus.registered;
  bool get isActive => isGuest || isRegistered;
  bool get isDeletionPending => status == AccountStatus.deletionPending;
  bool get isDeleted => status == AccountStatus.deleted;

  bool get canRequestDeletion => isActive;

  bool hasProvider(AuthProvider provider) {
    return providerLinks.any((link) => link.provider == provider);
  }

  AccountProviderLink? providerLink(AuthProvider provider) {
    for (final link in providerLinks) {
      if (link.provider == provider) {
        return link;
      }
    }

    return null;
  }

  bool isCoolingOffElapsedAt(DateTime now) {
    final effectiveAt = deletionEffectiveAt;
    return isDeletionPending &&
        effectiveAt != null &&
        !now.isBefore(effectiveAt);
  }

  bool isInDeletionCoolingOffAt(DateTime now) {
    final requestedAt = deletionRequestedAt;
    final effectiveAt = deletionEffectiveAt;
    return isDeletionPending &&
        requestedAt != null &&
        effectiveAt != null &&
        !now.isBefore(requestedAt) &&
        now.isBefore(effectiveAt);
  }

  bool isReadOnlyAt(DateTime now) {
    return isDeleted || isDeletionPending || isCoolingOffElapsedAt(now);
  }

  Account simulateLogin({
    required LocalAuthIdentity identity,
    required DateTime loginAt,
  }) {
    identity.validate();

    if (isDeleted) {
      throw StateError('Deleted accounts cannot log in.');
    }
    if (isDeletionPending) {
      throw StateError('Deletion pending accounts cannot log in.');
    }

    return Account(
      accountId: accountId,
      status: AccountStatus.registered,
      createdAt: createdAt,
      registeredAt: registeredAt ?? loginAt,
      providerLinks: _upsertProviderLink(
        providerLinks,
        identity: identity,
        loginAt: loginAt,
      ),
    );
  }

  Account requestDeletion({required DateTime requestedAt}) {
    if (!canRequestDeletion) {
      throw StateError('Only active accounts can request deletion.');
    }

    return Account(
      accountId: accountId,
      status: AccountStatus.deletionPending,
      createdAt: createdAt,
      registeredAt: registeredAt,
      providerLinks: providerLinks,
      deletionRequestedAt: requestedAt,
      deletionEffectiveAt: requestedAt.add(deletionCoolingOffPeriod),
      statusBeforeDeletion: status,
    );
  }

  Account cancelDeletion({required DateTime cancelledAt}) {
    if (!isDeletionPending) {
      throw StateError('Only deletion pending accounts can cancel deletion.');
    }
    if (deletedAt != null) {
      throw StateError('Deleted accounts cannot cancel deletion.');
    }

    final restoredStatus = statusBeforeDeletion ?? AccountStatus.registered;
    if (restoredStatus != AccountStatus.guest &&
        restoredStatus != AccountStatus.registered) {
      throw StateError('Deletion can only restore an active account status.');
    }

    return Account(
      accountId: accountId,
      status: restoredStatus,
      createdAt: createdAt,
      registeredAt: registeredAt,
      providerLinks: providerLinks,
    );
  }

  Account completeDeletion({required DateTime completedAt}) {
    if (!isDeletionPending) {
      throw StateError('Only deletion pending accounts can be deleted.');
    }

    final effectiveAt = deletionEffectiveAt;
    if (effectiveAt == null || completedAt.isBefore(effectiveAt)) {
      throw StateError('Deletion cooling-off period has not elapsed.');
    }

    return Account(
      accountId: accountId,
      status: AccountStatus.deleted,
      createdAt: createdAt,
      registeredAt: registeredAt,
      providerLinks: const [],
      deletionRequestedAt: deletionRequestedAt,
      deletionEffectiveAt: effectiveAt,
      statusBeforeDeletion: statusBeforeDeletion,
      deletedAt: completedAt,
    );
  }
}

class GuestMergeJob {
  GuestMergeJob({
    required this.jobId,
    required this.guestAccountId,
    required this.registeredAccountId,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.cancelledAt,
    this.mergedAt,
  }) {
    _requireNonBlank(jobId, 'jobId');
    _requireNonBlank(guestAccountId, 'guestAccountId');
    _requireNonBlank(registeredAccountId, 'registeredAccountId');
  }

  factory GuestMergeJob.create({
    required String jobId,
    required Account guestAccount,
    required Account registeredAccount,
    required DateTime createdAt,
  }) {
    if (!guestAccount.isGuest) {
      throw StateError('Guest merge source must be a guest account.');
    }
    if (!registeredAccount.isRegistered) {
      throw StateError('Guest merge target must be a registered account.');
    }
    if (guestAccount.accountId == registeredAccount.accountId) {
      throw ArgumentError.value(
        registeredAccount.accountId,
        'registeredAccount',
        'Guest and registered accounts must be different accounts.',
      );
    }

    return GuestMergeJob(
      jobId: jobId.trim(),
      guestAccountId: guestAccount.accountId,
      registeredAccountId: registeredAccount.accountId,
      status: GuestMergeJobStatus.pendingConfirmation,
      createdAt: createdAt,
    );
  }

  final String jobId;
  final String guestAccountId;
  final String registeredAccountId;
  final GuestMergeJobStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final DateTime? mergedAt;

  bool get needsConfirmation =>
      status == GuestMergeJobStatus.pendingConfirmation;
  bool get canMerge => status == GuestMergeJobStatus.confirmed;
  bool get isTerminal =>
      status == GuestMergeJobStatus.cancelled ||
      status == GuestMergeJobStatus.merged;

  GuestMergeJob confirm({required DateTime confirmedAt}) {
    if (status != GuestMergeJobStatus.pendingConfirmation) {
      throw StateError('Only pending guest merge jobs can be confirmed.');
    }

    return GuestMergeJob(
      jobId: jobId,
      guestAccountId: guestAccountId,
      registeredAccountId: registeredAccountId,
      status: GuestMergeJobStatus.confirmed,
      createdAt: createdAt,
      confirmedAt: confirmedAt,
    );
  }

  GuestMergeJob cancel({required DateTime cancelledAt}) {
    if (status != GuestMergeJobStatus.pendingConfirmation &&
        status != GuestMergeJobStatus.confirmed) {
      throw StateError(
        'Only pending or confirmed guest merge jobs can cancel.',
      );
    }

    return GuestMergeJob(
      jobId: jobId,
      guestAccountId: guestAccountId,
      registeredAccountId: registeredAccountId,
      status: GuestMergeJobStatus.cancelled,
      createdAt: createdAt,
      confirmedAt: confirmedAt,
      cancelledAt: cancelledAt,
    );
  }

  GuestMergeJob markMerged({required DateTime mergedAt}) {
    if (status != GuestMergeJobStatus.confirmed) {
      throw StateError('Only confirmed guest merge jobs can be merged.');
    }

    return GuestMergeJob(
      jobId: jobId,
      guestAccountId: guestAccountId,
      registeredAccountId: registeredAccountId,
      status: GuestMergeJobStatus.merged,
      createdAt: createdAt,
      confirmedAt: confirmedAt,
      mergedAt: mergedAt,
    );
  }
}

List<AccountProviderLink> _upsertProviderLink(
  List<AccountProviderLink> links, {
  required LocalAuthIdentity identity,
  required DateTime loginAt,
}) {
  final nextLinks = <AccountProviderLink>[];
  var replaced = false;

  for (final link in links) {
    if (link.provider == identity.provider &&
        link.providerUserId == identity.providerUserId.trim()) {
      nextLinks.add(link.recordLogin(loginAt: loginAt));
      replaced = true;
    } else {
      nextLinks.add(link);
    }
  }

  if (!replaced) {
    nextLinks.add(
      AccountProviderLink.fromIdentity(identity: identity, loginAt: loginAt),
    );
  }

  return nextLinks;
}

void _requireNonBlank(String value, String name) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, name, '$name cannot be blank.');
  }
}
