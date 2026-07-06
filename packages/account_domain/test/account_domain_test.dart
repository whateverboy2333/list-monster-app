import 'package:account_domain/account_domain.dart';
import 'package:test/test.dart';

void main() {
  test('uses frozen contract names for account and merge states', () {
    expect(AccountStatus.guest.contractName, 'guest');
    expect(AccountStatus.registered.contractName, 'registered');
    expect(AccountStatus.deletionPending.contractName, 'deletion_pending');
    expect(AccountStatus.deleted.contractName, 'deleted');
    expect(AuthProvider.phone.contractName, 'phone');
    expect(AuthProvider.wechat.contractName, 'wechat');
    expect(
      GuestMergeJobStatus.pendingConfirmation.contractName,
      'pending_confirmation',
    );
  });

  test('creates a local guest account', () {
    final createdAt = DateTime(2026, 7, 7, 8);
    final account = Account.createGuest(
      accountId: 'guest_1',
      createdAt: createdAt,
    );

    expect(account.accountId, 'guest_1');
    expect(account.status, AccountStatus.guest);
    expect(account.createdAt, createdAt);
    expect(account.isGuest, isTrue);
    expect(account.isActive, isTrue);
    expect(account.isReadOnlyAt(createdAt), isFalse);
    expect(account.providerLinks, isEmpty);
  });

  test('simulates phone login by registering a guest account locally', () {
    final guest = Account.createGuest(
      accountId: 'guest_1',
      createdAt: DateTime(2026, 7, 7, 8),
    );
    final loginAt = DateTime(2026, 7, 7, 9);

    final registered = guest.simulateLogin(
      identity: const LocalAuthIdentity.phone('phone_user_1'),
      loginAt: loginAt,
    );

    expect(registered.status, AccountStatus.registered);
    expect(registered.isRegistered, isTrue);
    expect(registered.registeredAt, loginAt);
    expect(registered.hasProvider(AuthProvider.phone), isTrue);
    expect(registered.providerLink(AuthProvider.phone)?.providerName, 'phone');
    expect(
      registered.providerLink(AuthProvider.phone)?.providerUserId,
      'phone_user_1',
    );
  });

  test('simulates adding and reusing local wechat provider links', () {
    final account = Account.createRegistered(
      accountId: 'account_1',
      identity: const LocalAuthIdentity.phone('phone_user_1'),
      createdAt: DateTime(2026, 7, 7, 8),
    );

    final withWechat = account.simulateLogin(
      identity: const LocalAuthIdentity.wechat('wechat_user_1'),
      loginAt: DateTime(2026, 7, 7, 9),
    );
    final repeatedWechat = withWechat.simulateLogin(
      identity: const LocalAuthIdentity.wechat('wechat_user_1'),
      loginAt: DateTime(2026, 7, 7, 10),
    );

    expect(withWechat.providerLinks, hasLength(2));
    expect(repeatedWechat.providerLinks, hasLength(2));
    expect(
      repeatedWechat.providerLink(AuthProvider.wechat)?.lastLoginAt,
      DateTime(2026, 7, 7, 10),
    );
  });

  test('confirms and completes a guest merge job', () {
    final guest = Account.createGuest(
      accountId: 'guest_1',
      createdAt: DateTime(2026, 7, 7, 8),
    );
    final registered = Account.createRegistered(
      accountId: 'account_1',
      identity: const LocalAuthIdentity.phone('phone_user_1'),
      createdAt: DateTime(2026, 7, 7, 9),
    );
    final job = GuestMergeJob.create(
      jobId: 'merge_1',
      guestAccount: guest,
      registeredAccount: registered,
      createdAt: DateTime(2026, 7, 7, 10),
    );

    final confirmed = job.confirm(confirmedAt: DateTime(2026, 7, 7, 10, 5));
    final merged = confirmed.markMerged(mergedAt: DateTime(2026, 7, 7, 10, 10));

    expect(job.status, GuestMergeJobStatus.pendingConfirmation);
    expect(job.needsConfirmation, isTrue);
    expect(confirmed.status, GuestMergeJobStatus.confirmed);
    expect(confirmed.canMerge, isTrue);
    expect(merged.status, GuestMergeJobStatus.merged);
    expect(merged.isTerminal, isTrue);
  });

  test('cancels a pending guest merge job', () {
    final guest = Account.createGuest(
      accountId: 'guest_1',
      createdAt: DateTime(2026, 7, 7, 8),
    );
    final registered = Account.createRegistered(
      accountId: 'account_1',
      identity: const LocalAuthIdentity.phone('phone_user_1'),
      createdAt: DateTime(2026, 7, 7, 9),
    );
    final job = GuestMergeJob.create(
      jobId: 'merge_1',
      guestAccount: guest,
      registeredAccount: registered,
      createdAt: DateTime(2026, 7, 7, 10),
    );

    final cancelled = job.cancel(cancelledAt: DateTime(2026, 7, 7, 10, 5));

    expect(cancelled.status, GuestMergeJobStatus.cancelled);
    expect(cancelled.cancelledAt, DateTime(2026, 7, 7, 10, 5));
    expect(cancelled.isTerminal, isTrue);
    expect(
      () => cancelled.confirm(confirmedAt: DateTime(2026, 7, 7, 10, 6)),
      throwsStateError,
    );
  });

  test('starts a 15 day deletion cooling-off period', () {
    final account = Account.createRegistered(
      accountId: 'account_1',
      identity: const LocalAuthIdentity.phone('phone_user_1'),
      createdAt: DateTime(2026, 7, 7, 8),
    );
    final requestedAt = DateTime(2026, 7, 7, 12);

    final pending = account.requestDeletion(requestedAt: requestedAt);

    expect(pending.status, AccountStatus.deletionPending);
    expect(pending.deletionRequestedAt, requestedAt);
    expect(
      pending.deletionEffectiveAt,
      requestedAt.add(Account.deletionCoolingOffPeriod),
    );
    expect(pending.statusBeforeDeletion, AccountStatus.registered);
    expect(
      pending.isInDeletionCoolingOffAt(
        requestedAt.add(const Duration(days: 14)),
      ),
      isTrue,
    );
    expect(
      pending.isCoolingOffElapsedAt(requestedAt.add(const Duration(days: 15))),
      isTrue,
    );
  });

  test('cancels deletion and restores an active account', () {
    final account = Account.createRegistered(
      accountId: 'account_1',
      identity: const LocalAuthIdentity.phone('phone_user_1'),
      createdAt: DateTime(2026, 7, 7, 8),
    );
    final pending = account.requestDeletion(
      requestedAt: DateTime(2026, 7, 7, 12),
    );

    final restored = pending.cancelDeletion(
      cancelledAt: DateTime(2026, 7, 8, 12),
    );

    expect(restored.status, AccountStatus.registered);
    expect(restored.isActive, isTrue);
    expect(restored.deletionRequestedAt, isNull);
    expect(restored.deletionEffectiveAt, isNull);
    expect(restored.providerLinks, hasLength(1));
  });

  test('marks deletion pending and deleted accounts as read only', () {
    final account = Account.createRegistered(
      accountId: 'account_1',
      identity: const LocalAuthIdentity.phone('phone_user_1'),
      createdAt: DateTime(2026, 7, 7, 8),
    );
    final requestedAt = DateTime(2026, 7, 7, 12);
    final pending = account.requestDeletion(requestedAt: requestedAt);

    expect(pending.isReadOnlyAt(requestedAt), isTrue);
    expect(
      () => pending.completeDeletion(
        completedAt: requestedAt.add(const Duration(days: 14)),
      ),
      throwsStateError,
    );

    final deleted = pending.completeDeletion(
      completedAt: requestedAt.add(const Duration(days: 15)),
    );

    expect(deleted.status, AccountStatus.deleted);
    expect(deleted.deletedAt, requestedAt.add(const Duration(days: 15)));
    expect(deleted.isReadOnlyAt(deleted.deletedAt!), isTrue);
    expect(deleted.providerLinks, isEmpty);
  });
}
