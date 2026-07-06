import 'package:monster_domain/monster_domain.dart';
import 'package:test/test.dart';

void main() {
  test('keeps the expected monster mood labels', () {
    expect(MonsterMood.expecting.label, '期待');
    expect(MonsterMood.sleeping.label, '睡觉');
  });

  test('uses frozen monster and XP contract names', () {
    expect(MonsterMood.energetic.contractName, 'energetic');
    expect(MonsterStage.egg.contractName, 'egg');
    expect(XpSourceType.taskCompleted.contractName, 'task_completed');
  });

  test('identifies positive XP grants', () {
    expect(
      const XpGrant(sourceEventId: 'evt_1', amount: 10).isPositive,
      isTrue,
    );
    expect(
      const XpGrant(sourceEventId: 'evt_2', amount: -10).isPositive,
      isFalse,
    );
  });

  test('records task XP in a ledger-shaped entry', () {
    final entry = XpLedgerEntry(
      xpLedgerId: 'xp_1',
      userId: 'local_guest',
      sourceEventId: 'evt_1',
      sourceType: XpSourceType.taskCompleted,
      amount: 10,
      localDate: DateTime(2026, 7, 4),
      timezoneId: 'Asia/Shanghai',
      dailyCapApplied: true,
      dailyTotalAfterGrant: 10,
      createdAt: DateTime(2026, 7, 4, 9),
    );

    expect(entry.eventName, 'xp_granted');
    expect(entry.payload['xpLedgerId'], 'xp_1');
    expect(entry.payload['sourceEventId'], 'evt_1');
    expect(entry.payload['sourceType'], 'task_completed');
    expect(entry.payload['dailyTotalAfterGrant'], 10);
    expect(XpGrant.fromLedger(entry).amount, 10);
  });

  test('names XP reversal ledger entries as xp_reverted', () {
    final entry = XpLedgerEntry(
      xpLedgerId: 'xp_2',
      userId: 'local_guest',
      sourceEventId: 'evt_2',
      sourceType: XpSourceType.xpReverted,
      originalXpLedgerId: 'xp_1',
      amount: -10,
      localDate: DateTime(2026, 7, 4),
      timezoneId: 'Asia/Shanghai',
      dailyCapApplied: true,
      dailyTotalAfterGrant: 0,
      reason: 'undo_completion',
      createdAt: DateTime(2026, 7, 4, 10),
    );

    expect(entry.eventName, 'xp_reverted');
    expect(entry.amount, -10);
    expect(entry.originalXpLedgerId, 'xp_1');
    expect(entry.payload['originalXpLedgerId'], 'xp_1');
    expect(entry.payload['revertedAt'], '2026-07-04T10:00:00.000');
    expect(entry.payload['reason'], 'undo_completion');
  });

  test('calculates task completion XP from completion order and priority', () {
    expect(
      XpPolicy.taskCompletionXp(completionOrderOfDay: 1, highPriority: false),
      10,
    );
    expect(
      XpPolicy.taskCompletionXp(completionOrderOfDay: 1, highPriority: true),
      15,
    );
    expect(
      XpPolicy.taskCompletionXp(completionOrderOfDay: 6, highPriority: true),
      5,
    );
    expect(
      XpPolicy.taskCompletionXp(completionOrderOfDay: 11, highPriority: false),
      1,
    );
    expect(XpPolicy.capFormalXp(currentDailyXp: 120, rawAmount: 15), 5);
    expect(XpPolicy.capFormalXp(currentDailyXp: 125, rawAmount: 10), 0);
  });

  test('keeps the monster in egg stage while XP and mood change', () {
    final monster = MonsterSnapshot.initialEgg(
      monsterId: 'monster_1',
      userId: 'local_guest',
    );

    final updated = monster.applyXp(
      const XpGrant(sourceEventId: 'evt_1', amount: 10),
    );

    expect(updated.stage, MonsterStage.egg);
    expect(updated.lifetimeXp, 10);
    expect(updated.currentLevelXp, 10);
    expect(updated.moodState, MonsterMood.energetic);

    final leveled = monster.applyXp(
      const XpGrant(sourceEventId: 'evt_2', amount: 120),
    );
    expect(leveled.level, 3);
    expect(leveled.currentLevelXp, 20);
  });

  test('creates daily task milestone feedback at 3 and 6 completions', () {
    final smallStart = DailyTaskMilestone.fromCompletedCount(
      completedEligibleTaskCount: 3,
      localDate: DateTime(2026, 7, 4),
      timezoneId: 'Asia/Shanghai',
    );
    final fruitfulDay = DailyTaskMilestone.fromCompletedCount(
      completedEligibleTaskCount: 6,
      localDate: DateTime(2026, 7, 4),
      timezoneId: 'Asia/Shanghai',
    );

    expect(smallStart?.eventName, 'daily_task_milestone');
    expect(smallStart?.milestoneKey, 'small_start');
    expect(smallStart?.title, '小试身手');
    expect(smallStart?.payload['localDate'], '2026-07-04');
    expect(smallStart?.payload['actionKey'], 'task_milestone');
    expect(fruitfulDay?.milestoneKey, 'fruitful_day');
    expect(fruitfulDay?.title, '收获满满');
  });

  test(
    'updates streak and records an internal break without punishment data',
    () {
      final streak = StreakSnapshot.empty(
        timezoneId: 'Asia/Shanghai',
      ).recordActiveDay(DateTime(2026, 7, 1)).streak;

      final result = streak.recordActiveDay(DateTime(2026, 7, 4));

      expect(result.streak.currentStreakDays, 1);
      expect(result.streak.bestStreakDays, 1);
      expect(result.updatedEvent?.eventName, 'streak_updated');
      expect(result.breakEvent?.eventName, 'streak_break');
      expect(
        result.breakEvent?.payload['reason'],
        'no_rewardable_task_completed',
      );
    },
  );

  test('creates daily summary and pet reaction events with frozen names', () {
    final summary = DailyTaskSummary(
      summaryForDate: DateTime(2026, 7, 4),
      timezoneId: 'Asia/Shanghai',
      completedEligibleTaskCount: 3,
      createdTaskCount: 4,
      feedbackText: '昨天你完成了 3 件小事，小单都记得。',
    );
    final pet = MonsterPetReactionEvent(
      monsterId: 'monster_1',
      reactionKey: 'wake_up',
      touchCountInSleep: 3,
      interactedAt: DateTime(2026, 7, 5, 23),
    );

    expect(summary.eventName, 'daily_task_summary');
    expect(summary.payload['summaryForDate'], '2026-07-04');
    expect(pet.eventName, 'monster_pet_reacted');
    expect(pet.payload['reactionKey'], 'wake_up');
  });
}
