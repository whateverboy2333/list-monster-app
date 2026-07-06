import 'dart:convert';

import 'package:companion_contract/companion_contract.dart';
import 'package:test/test.dart';

void main() {
  test('keeps the existing snapshot draft behavior', () {
    const snapshot = CompanionSnapshotDraft(
      schemaVersion: '0.1.3',
      monsterName: 'Todo',
      todayCompletedTasks: 2,
      todayTotalTasks: 5,
    );

    expect(snapshot.todayRemainingTasks, 3);
    expect(snapshot.staleAfterSeconds, 300);
  });

  test('round-trips a normal companion snapshot through JSON', () {
    final snapshot = _snapshot();

    final encoded = jsonEncode(snapshot.toJson());
    final decoded = jsonDecode(encoded) as Map<String, Object?>;
    final roundTripped = CompanionSnapshot.fromJson(decoded);

    expect(roundTripped.toJson(), equals(snapshot.toJson()));
    expect(
      roundTripped.isExpiredAt(DateTime.utc(2026, 7, 7, 10, 4, 59)),
      isFalse,
    );
    expect(roundTripped.todayRemainingTasks, 2);
    expect(roundTripped.previousDaySummaryDate, DateTime.utc(2026, 7, 6));
  });

  test('detects expired snapshots from stale flag or generated time', () {
    final expiredByTime = _snapshot(
      generatedAt: DateTime.utc(2026, 7, 7, 10),
      isStale: false,
      staleAfterSeconds: 300,
    );
    final expiredByFlag = _snapshot(
      generatedAt: DateTime.utc(2026, 7, 7, 10, 4),
      isStale: true,
      staleAfterSeconds: 300,
    );

    expect(expiredByTime.isExpiredAt(DateTime.utc(2026, 7, 7, 10, 5)), isTrue);
    expect(
      expiredByFlag.isExpiredAt(DateTime.utc(2026, 7, 7, 10, 4, 1)),
      isTrue,
    );
  });

  test('hides task titles for external surfaces when privacy is enabled', () {
    final hidden = _snapshot(hideTaskTitlesOutsideApp: true);
    final visible = _snapshot(hideTaskTitlesOutsideApp: false);

    expect(hidden.taskTitleForExternalSurface('Pay rent'), isNull);
    expect(visible.taskTitleForExternalSurface('Pay rent'), 'Pay rent');
  });

  test('uses frozen JSON values for companion enums', () {
    expect(CompanionStyleLine.fromJson('cool'), CompanionStyleLine.cool);
    expect(CompanionStyleLine.soft.jsonValue, 'soft');
    expect(CompanionStyleLine.neutral.jsonValue, 'neutral');

    expect(CompanionStage.fromJson('egg'), CompanionStage.egg);
    expect(CompanionStage.child.jsonValue, 'child');
    expect(CompanionStage.teen.jsonValue, 'teen');
    expect(CompanionStage.adult.jsonValue, 'adult');

    expect(CompanionMoodState.fromJson('idle'), CompanionMoodState.idle);
    expect(CompanionMoodState.energetic.jsonValue, 'energetic');
    expect(CompanionMoodState.expecting.jsonValue, 'expecting');
    expect(CompanionMoodState.sleeping.jsonValue, 'sleeping');
    expect(CompanionMoodState.missing.jsonValue, 'missing');

    expect(
      CompanionDesktopPetState.fromJson('on'),
      CompanionDesktopPetState.enabled,
    );
    expect(
      CompanionDesktopPetState.fromJson('off'),
      CompanionDesktopPetState.disabled,
    );
  });
}

CompanionSnapshot _snapshot({
  DateTime? generatedAt,
  bool isStale = false,
  int staleAfterSeconds = 300,
  bool hideTaskTitlesOutsideApp = false,
}) {
  return CompanionSnapshot(
    schemaVersion: '0.1.3',
    snapshotId: 'snapshot-1',
    userId: 'user-1',
    generatedAt: generatedAt ?? DateTime.utc(2026, 7, 7, 10),
    isStale: isStale,
    staleAfterSeconds: staleAfterSeconds,
    timezoneId: 'Asia/Shanghai',
    monsterId: 'monster-1',
    monsterName: 'Todo',
    styleLine: CompanionStyleLine.cool,
    stage: CompanionStage.child,
    level: 4,
    xpProgressPercent: 0.65,
    moodState: CompanionMoodState.expecting,
    actionKey: 'review_today',
    spriteAssetId: 'sprite-expecting',
    widgetFrameAssetId: 'widget-expecting',
    lineText: 'Two tasks left.',
    todayCompletedTasks: 3,
    todayTotalTasks: 5,
    todayRemainingTasks: 2,
    todayTaskMilestoneKey: 'small_start',
    todayTaskMilestoneTitle: 'Small start',
    previousDaySummaryDate: DateTime.utc(2026, 7, 6),
    previousDayCompletedEligibleTasks: 4,
    previousDayFeedbackTitle: 'Good work',
    previousDayFeedbackText: 'You finished four eligible tasks.',
    currentStreakDays: 6,
    bestStreakDays: 12,
    desktopPetState: CompanionDesktopPetState.enabled,
    dndActive: false,
    hideTaskTitlesOutsideApp: hideTaskTitlesOutsideApp,
  );
}
