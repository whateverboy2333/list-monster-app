import 'package:flutter/foundation.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:task_domain/task_domain.dart';

class CoreLoopController extends ChangeNotifier {
  CoreLoopController({
    DateTime? today,
    this.userId = 'local_guest',
    this.timezoneId = 'Asia/Shanghai',
  }) : today = _dateOnly(today ?? DateTime.now()),
       monster = MonsterSnapshot.initialEgg(
         monsterId: 'monster_local_egg',
         userId: userId,
       );

  final String userId;
  final String timezoneId;
  final DateTime today;
  MonsterSnapshot monster;

  final List<TaskItem> _tasks = [];
  final List<XpLedgerEntry> _xpLedger = [];
  int _nextTaskNumber = 1;
  int _nextEventNumber = 1;
  int _nextXpLedgerNumber = 1;
  int _todayXp = 0;
  DailyTaskMilestone? _latestMilestone;

  List<TaskItem> get tasks => List.unmodifiable(_tasks);

  List<XpLedgerEntry> get xpLedger => List.unmodifiable(_xpLedger);

  int get completedRewardableCount {
    return _tasks
        .where((task) => task.isCompleted && task.rewardEligible)
        .length;
  }

  int get todayXp => _todayXp;

  DailyTaskMilestone? get latestMilestone => _latestMilestone;

  bool get hasTasks => _tasks.isNotEmpty;

  void createTask(String title) {
    final draft = TaskDraft(title: title);
    if (!draft.canCreate) {
      return;
    }

    _tasks.add(
      TaskItem.create(
        id: 'task_${_nextTaskNumber++}',
        userId: userId,
        draft: draft,
        today: today,
      ),
    );
    notifyListeners();
  }

  void completeTask(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1 || _tasks[index].isCompleted) {
      return;
    }

    final task = _tasks[index];
    final nextRewardableCount =
        completedRewardableCount + (task.rewardEligible ? 1 : 0);
    final nextTodayCompletedCount =
        _tasks.where((item) => item.isCompleted).length + 1;

    final result = task.complete(
      eventId: 'evt_${_nextEventNumber++}',
      completedAt: DateTime.now(),
      timezoneId: timezoneId,
      completionOrderOfDay: nextRewardableCount,
      dailyRewardableCountAfter: nextRewardableCount,
      dailyTodayTaskCountAfter: nextTodayCompletedCount,
    );

    _tasks[index] = result.task;

    if (result.event.rewardEligible) {
      final xpAmount = XpPolicy.taskCompletionXp(
        completionOrderOfDay: result.event.completionOrderOfDay,
        highPriority: result.event.priority == TaskPriority.high,
      );
      final nextTodayXp = _todayXp + xpAmount;
      final ledgerEntry = XpLedgerEntry(
        xpLedgerId: 'xp_${_nextXpLedgerNumber++}',
        userId: userId,
        sourceEventId: result.event.eventId,
        sourceType: XpSourceType.taskCompleted,
        amount: xpAmount,
        localDate: today,
        timezoneId: timezoneId,
        dailyCapApplied: true,
        dailyTotalAfterGrant: nextTodayXp,
        createdAt: result.event.completedAt,
      );
      _xpLedger.add(ledgerEntry);
      monster = monster.applyXp(XpGrant.fromLedger(ledgerEntry));
      _todayXp = nextTodayXp;
      _latestMilestone =
          DailyTaskMilestone.fromCompletedCount(
            completedEligibleTaskCount: nextRewardableCount,
            localDate: today,
            timezoneId: timezoneId,
          ) ??
          _latestMilestone;
    }

    notifyListeners();
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
