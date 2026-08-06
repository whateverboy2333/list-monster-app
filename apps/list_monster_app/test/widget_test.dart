import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:account_domain/account_domain.dart';
import 'package:list_monster_app/account/account_session_controller.dart';
import 'package:list_monster_app/main.dart';
import 'package:list_monster_app/node3_core_loop.dart';
import 'package:local_store/local_store.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:sprite_runtime/sprite_runtime.dart';
import 'package:task_domain/task_domain.dart';

void main() {
  test('maps every domain stage to its matching visual stage', () {
    expect(spriteStageFor(MonsterStage.egg), MonsterSpriteStage.egg);
    expect(spriteStageFor(MonsterStage.child), MonsterSpriteStage.child);
    expect(spriteStageFor(MonsterStage.teen), MonsterSpriteStage.teen);
    expect(spriteStageFor(MonsterStage.adult), MonsterSpriteStage.adult);
  });

  testWidgets('uses the same stage sprite on Today and Monster pages', (
    tester,
  ) async {
    await tester.pumpWidget(const ListMonsterApp());
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('monster-sprite-image-egg')),
      findsOneWidget,
    );
    expect(find.textContaining('placeholder'), findsNothing);

    await tester.tap(find.byIcon(Icons.egg_alt_outlined));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('monster-sprite-image-egg')),
      findsOneWidget,
    );
    expect(find.textContaining('placeholder'), findsNothing);
  });

  testWidgets('shows the node 2 app shell', (tester) async {
    await tester.pumpWidget(const ListMonsterApp());

    expect(find.text('清单怪兽'), findsOneWidget);
    expect(find.text('今日'), findsWidgets);
    expect(find.text('长期'), findsOneWidget);
    expect(find.text('怪兽'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);
    expect(find.text('小单正在等第一个任务'), findsOneWidget);
  });

  testWidgets('switches app language and localizes date picker', (
    tester,
  ) async {
    await tester.pumpWidget(const ListMonsterApp());

    expect(find.text('今日'), findsWidgets);
    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.text('List Monster'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const ListMonsterApp());
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.text('List Monster'), findsOneWidget);

    await tester.tap(find.text('Long-term'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Long-term Task'));
    await tester.pumpAndSettle();

    expect(find.text('Long-term Goal'), findsOneWidget);
    expect(find.text('Start Date'), findsOneWidget);
    expect(find.text('End Date'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('long-term-start-date-picker')));
    await tester.pumpAndSettle();

    expect(find.text('Select Start Date'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
    await tester.tap(find.text('Cancel').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('中'));
    await tester.pumpAndSettle();

    expect(find.text('清单怪兽'), findsOneWidget);
    expect(find.text('长期'), findsOneWidget);
  });

  testWidgets('runs the node 3 local core loop', (tester) async {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      ListMonsterApp(
        taskSystemController: controller,
        openedAt: DateTime(2026, 7, 4, 9),
      ),
    );

    for (final title in ['喝一杯水', '整理桌面', '写下复盘']) {
      final input = find.byType(EditableText);
      final addButton = find.text('加入今日');
      await tester.ensureVisible(input);
      await tester.enterText(input, title);
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pump();
    }

    for (final title in ['喝一杯水', '整理桌面', '写下复盘']) {
      final taskTile = find.widgetWithText(CheckboxListTile, title);
      await tester.ensureVisible(taskTile);
      await tester.tap(taskTile);
      await tester.pump();
    }

    expect(find.text('小试身手'), findsOneWidget);
    expect(find.text('+30 XP'), findsOneWidget);
    expect(find.text('元气'), findsWidgets);

    await tester.tap(find.text('怪兽'));
    await tester.pumpAndSettle();

    expect(find.text('怪兽蛋'), findsOneWidget);
    expect(find.text('30 / 50 XP'), findsOneWidget);
  });

  test('node 3 controller records XP ledger entries', () {
    final controller = CoreLoopController(today: DateTime(2026, 7, 4));

    controller.createTask('喝一杯水');
    controller.completeTask(controller.tasks.single.id);

    expect(controller.xpLedger, hasLength(1));
    expect(controller.xpLedger.single.eventName, 'xp_granted');
    expect(
      controller.xpLedger.single.sourceType.contractName,
      'task_completed',
    );
    expect(controller.xpLedger.single.dailyTotalAfterGrant, 10);
    expect(controller.todayXp, 10);
  });

  test('node 5 controller applies high priority XP and daily cap', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
    );

    controller.createTask('高优先级任务', priority: TaskPriority.high);
    controller.completeTask(controller.tasks.single.id);

    expect(controller.todayXp, 15);
    expect(controller.xpLedger.single.amount, 15);

    for (var index = 0; index < 130; index++) {
      controller.createTask('封顶任务 $index');
      controller.completeTask(controller.tasks.last.id);
    }

    expect(controller.todayXp, XpPolicy.dailyFormalXpCap);
    expect(
      controller.xpLedger.last.dailyTotalAfterGrant,
      XpPolicy.dailyFormalXpCap,
    );
  });

  test(
    'node 5 controller grants cumulative reward on the fourth active day',
    () {
      final controller = TaskSystemController(
        today: DateTime(2026, 7, 4),
        now: DateTime(2026, 7, 4, 9),
        priorActiveDates: [
          DateTime(2026, 7, 1),
          DateTime(2026, 7, 2),
          DateTime(2026, 7, 3),
        ],
      );

      controller.createTask('继续保持');
      controller.completeTask(controller.tasks.single.id);

      expect(controller.activeDayCount, 4);
      expect(controller.todayXp, 30);
      expect(
        controller.latestCumulativeReward?.eventName,
        'cumulative_active_reward',
      );
      expect(
        controller.xpLedger.map((entry) => entry.sourceType.contractName),
        contains('cumulative_active_reward'),
      );
    },
  );

  test('node 5 controller records streak break without XP penalty', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
      priorActiveDates: [DateTime(2026, 7, 1)],
    );

    controller.createTask('重新开始');
    controller.completeTask(controller.tasks.single.id);

    expect(controller.streak.currentStreakDays, 1);
    expect(controller.todayXp, 10);
    expect(controller.events.whereType<StreakBreakEvent>(), hasLength(1));
  });

  testWidgets('node 5 app startup records previous-day summary without XP', (
    tester,
  ) async {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 5),
      now: DateTime(2026, 7, 5, 9),
      lastOpenedDate: DateTime(2026, 7, 4),
      priorCompletedEligibleCounts: {DateTime(2026, 7, 4): 2},
      priorCreatedTaskCounts: {DateTime(2026, 7, 4): 3},
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      ListMonsterApp(
        taskSystemController: controller,
        openedAt: DateTime(2026, 7, 5, 9),
      ),
    );
    await tester.pump();

    expect(controller.latestDailySummary?.eventName, 'daily_task_summary');
    expect(controller.latestDailySummary?.completedEligibleTaskCount, 2);
    expect(controller.todayXp, 0);
    expect(controller.xpLedger, isEmpty);
    expect(find.textContaining('昨天你完成了 2'), findsOneWidget);
  });

  test('node 5 controller shows previous-day feedback without XP', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 5),
      now: DateTime(2026, 7, 5, 9),
      lastOpenedDate: DateTime(2026, 7, 4),
      priorCompletedEligibleCounts: {DateTime(2026, 7, 4): 3},
      priorCreatedTaskCounts: {DateTime(2026, 7, 4): 4},
    );

    final summary = controller.recordAppOpened(DateTime(2026, 7, 5, 9));

    expect(summary?.eventName, 'daily_task_summary');
    expect(controller.todayXp, 0);
    expect(controller.xpLedger, isEmpty);
    expect(controller.latestDailySummary?.completedEligibleTaskCount, 3);
  });

  test('node 5 previous-day zero completions is silent and grants no XP', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 5),
      now: DateTime(2026, 7, 5, 9),
      lastOpenedDate: DateTime(2026, 7, 4),
      priorCompletedEligibleCounts: {DateTime(2026, 7, 4): 0},
      priorCreatedTaskCounts: {DateTime(2026, 7, 4): 2},
    );

    final summary = controller.recordAppOpened(DateTime(2026, 7, 5, 9));

    expect(summary, isNull);
    expect(controller.latestDailySummary, isNull);
    expect(controller.events.whereType<DailyTaskSummary>(), isEmpty);
    expect(controller.todayXp, 0);
    expect(controller.xpLedger, isEmpty);
    expect(controller.monster.moodState, MonsterMood.idle);
  });

  test('node 5 long-term achievement grants uncapped XP only once', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
    );

    for (var index = 0; index < 130; index++) {
      controller.createTask('封顶任务 $index');
      controller.completeTask(controller.tasks.last.id);
    }
    expect(controller.todayXp, XpPolicy.dailyFormalXpCap);

    controller.createLongTermTask(
      '两天训练',
      childTaskTitles: const ['第一天训练', '第二天训练'],
    );
    final longTermTaskId = controller.longTermTasks.single.longTermTaskId;

    for (final task in controller.longTermChildTasks(longTermTaskId).toList()) {
      controller.completeTask(task.id);
    }

    final firstLongTermEntries = controller.xpLedger
        .where((entry) => entry.sourceType == XpSourceType.longtermAchieved)
        .toList();
    expect(firstLongTermEntries, hasLength(1));
    expect(firstLongTermEntries.single.amount, XpPolicy.longTermAchievedXp);
    expect(firstLongTermEntries.single.dailyCapApplied, isFalse);
    expect(controller.todayXp, XpPolicy.dailyFormalXpCap);

    final firstChildId = controller.longTermChildTasks(longTermTaskId).first.id;
    controller.undoCompletion(firstChildId);
    controller.completeTask(firstChildId);

    final finalLongTermEntries = controller.xpLedger
        .where((entry) => entry.sourceType == XpSourceType.longtermAchieved)
        .toList();
    expect(finalLongTermEntries, hasLength(1));
  });

  test('node 5 duplicate sourceEventId does not grant XP twice', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
    );

    final firstGrant = controller.grantXpForTesting(
      sourceEventId: 'evt_duplicate',
      sourceType: XpSourceType.taskCompleted,
      rawAmount: 10,
    );
    final duplicateGrant = controller.grantXpForTesting(
      sourceEventId: 'evt_duplicate',
      sourceType: XpSourceType.taskCompleted,
      rawAmount: 10,
    );

    expect(firstGrant, isNotNull);
    expect(duplicateGrant, isNull);
    expect(controller.todayXp, 10);
    expect(controller.xpLedger, hasLength(1));
  });

  test('node 5 undo completion reverts XP only once', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
    );

    controller.createTask('撤销测试');
    final taskId = controller.tasks.single.id;
    controller.completeTask(taskId);
    controller.undoCompletion(taskId);
    controller.undoCompletion(taskId);

    expect(
      controller.xpLedger.where(
        (entry) => entry.sourceType == XpSourceType.xpReverted,
      ),
      hasLength(1),
    );
    expect(controller.todayXp, 0);
  });

  test('node 5 onboarding auto completion grants no formal XP', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
    );

    controller.createTask('引导任务');
    controller.completeTask(
      controller.tasks.single.id,
      completionSource: CompletionSource.onboardingAuto,
    );

    expect(controller.tasks.single.isCompleted, isTrue);
    expect(controller.todayXp, 0);
    expect(controller.xpLedger, isEmpty);
    expect(controller.activeDayCount, 0);
    expect(controller.latestMilestone, isNull);
  });

  test('node 5 controller wakes sleeping monster on the third pet', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 23, 30),
    );

    expect(controller.monster.moodState, MonsterMood.sleeping);

    controller.petMonster(interactedAt: DateTime(2026, 7, 4, 23, 31));
    controller.petMonster(interactedAt: DateTime(2026, 7, 4, 23, 32));
    expect(controller.monster.moodState, MonsterMood.sleeping);
    expect(controller.sleepPetCount, 2);
    expect(controller.todayXp, 0);

    final reaction = controller.petMonster(
      interactedAt: DateTime(2026, 7, 4, 23, 33),
    );

    expect(reaction.reactionKey, 'wake_up');
    expect(controller.monster.currentAction, 'wake_up');
    expect(controller.monster.moodState, isNot(MonsterMood.sleeping));
    expect(controller.todayXp, 0);
    expect(controller.xpLedger, isEmpty);
  });

  test('node 4 controller restores tasks without granting XP', () {
    final controller = TaskSystemController(today: DateTime(2026, 7, 4));

    controller.createTask('整理收集箱');
    final taskId = controller.tasks.single.id;
    expect(controller.events.whereType<TaskCreatedEvent>(), hasLength(1));

    controller.completeTask(taskId);
    expect(controller.todayXp, 10);

    controller.undoCompletion(taskId);
    expect(controller.todayXp, 0);
    expect(controller.tasks.single.status, TaskStatus.active);
    expect(controller.xpLedger.last.eventName, 'xp_reverted');
    expect(controller.xpLedger.last.payload['originalXpLedgerId'], 'xp_1');
    expect(controller.xpLedger.last.payload['reason'], 'undo_completion');

    controller.cancelTask(taskId);
    expect(controller.tasks.single.status, TaskStatus.cancelled);
    expect(controller.todayXp, 0);

    controller.restoreTask(taskId);
    expect(controller.tasks.single.status, TaskStatus.active);
    expect(controller.todayXp, 0);
    expect(controller.events.whereType<TaskRestoredEvent>(), isNotEmpty);
  });

  test(
    'node 4 controller creates long-term child tasks and achieves from them',
    () {
      final controller = TaskSystemController(today: DateTime(2026, 7, 4));

      controller.createLongTermTask(
        '准备考试',
        childTaskTitles: const ['整理资料', '完成第一章', '做模拟题'],
      );

      expect(controller.longTermTasks, hasLength(1));
      expect(controller.longTermTasks.single.canCompleteDirectly, isFalse);
      expect(
        controller.tasks.where((task) => task.type == TaskType.longTermChild),
        hasLength(3),
      );

      for (final task in controller.tasks.toList()) {
        controller.completeTask(task.id);
      }

      expect(
        controller.longTermTasks.single.status,
        LongTermTaskStatus.achieved,
      );
      expect(controller.events.whereType<LongTermAchievedEvent>(), isNotEmpty);
    },
  );

  test('node 4 controller cancels unfinished long-term child tasks only', () {
    final controller = TaskSystemController(today: DateTime(2026, 7, 4));

    controller.createLongTermTask(
      '准备考试',
      childTaskTitles: const ['整理资料', '完成第一章', '做模拟题'],
    );
    final completedChild = controller.tasks.first;
    controller.completeTask(completedChild.id);

    controller.cancelLongTermTask(
      controller.longTermTasks.single.longTermTaskId,
    );

    expect(
      controller.longTermTasks.single.status,
      LongTermTaskStatus.cancelled,
    );
    expect(controller.tasks.first.status, TaskStatus.completed);
    expect(
      controller.tasks
          .skip(1)
          .every((task) => task.status == TaskStatus.cancelled),
      isTrue,
    );
    expect(controller.events.whereType<LongTermCancelledEvent>(), isNotEmpty);
  });

  test('node 4 controller requires an explicit manual long-term breakdown', () {
    final controller = TaskSystemController(today: DateTime(2026, 7, 4));

    controller.createLongTermTask('准备考试');
    expect(controller.longTermTasks, isEmpty);
    expect(controller.tasks, isEmpty);

    controller.createLongTermTask(
      '准备考试',
      childTaskTitles: const ['整理资料', '完成第一章', '做模拟题'],
      breakdownSource: LongTermBreakdownSource.ai,
    );
    expect(controller.longTermTasks, isEmpty);
    expect(controller.tasks, isEmpty);
  });

  test('node 4 controller creates long-term tasks from manual breakdown', () {
    final controller = TaskSystemController(today: DateTime(2026, 7, 4));

    controller.createLongTermTask(
      '准备考试',
      childTaskTitles: const ['整理资料', '完成第一章', '做模拟题'],
      breakdownSource: LongTermBreakdownSource.manual,
    );

    expect(controller.longTermTasks.single.title, '准备考试');
    expect(controller.longTermTasks.single.totalTaskCount, 3);
    expect(
      controller
          .longTermChildTasks(controller.longTermTasks.single.longTermTaskId)
          .map((task) => task.title),
      ['整理资料', '完成第一章', '做模拟题'],
    );
  });

  test('node 4 controller creates long-term tasks from custom dates', () {
    final controller = TaskSystemController(today: DateTime(2026, 7, 4));
    final titles = List<String>.generate(10, (index) => '第 ${index + 1} 天计划');

    controller.createLongTermTask(
      '十天训练',
      startDate: DateTime(2026, 7, 10),
      dueDate: DateTime(2026, 7, 19),
      childTaskTitles: titles,
    );

    final longTermTask = controller.longTermTasks.single;
    final childTasks = controller.longTermChildTasks(
      longTermTask.longTermTaskId,
    );

    expect(longTermTask.startDate, DateTime(2026, 7, 10));
    expect(longTermTask.dueDate, DateTime(2026, 7, 19));
    expect(longTermTask.totalTaskCount, 10);
    expect(childTasks, hasLength(10));
    expect(childTasks.first.scheduledDate, DateTime(2026, 7, 10));
    expect(childTasks.last.scheduledDate, DateTime(2026, 7, 19));
  });

  test('node 4 controller edits long-term task date range', () {
    final controller = TaskSystemController(today: DateTime(2026, 7, 4));

    controller.createLongTermTask(
      '准备考试',
      childTaskTitles: const ['整理资料', '完成第一章', '做模拟题'],
    );
    final longTermTaskId = controller.longTermTasks.single.longTermTaskId;

    controller.updateLongTermTaskPlan(
      longTermTaskId,
      title: '准备期末考试',
      startDate: DateTime(2026, 7, 4),
      dueDate: DateTime(2026, 7, 8),
      childTaskTitles: const ['整理资料', '完成第一章', '做模拟题', '错题整理', '复盘检查'],
    );

    final updated = controller.longTermTasks.single;
    final childTasks = controller.longTermChildTasks(longTermTaskId);
    expect(updated.title, '准备期末考试');
    expect(updated.dueDate, DateTime(2026, 7, 8));
    expect(updated.totalTaskCount, 5);
    expect(childTasks, hasLength(5));
    expect(childTasks.last.title, '复盘检查');
    expect(childTasks.last.scheduledDate, DateTime(2026, 7, 8));
  });

  test(
    'node 4 controller refuses date edits that exclude completed children',
    () {
      final controller = TaskSystemController(today: DateTime(2026, 7, 4));

      controller.createLongTermTask(
        '准备考试',
        childTaskTitles: const ['整理资料', '完成第一章', '做模拟题'],
      );
      final longTermTaskId = controller.longTermTasks.single.longTermTaskId;
      final lastChildTask = controller.longTermChildTasks(longTermTaskId).last;
      controller.completeTask(lastChildTask.id);

      controller.updateLongTermTaskPlan(
        longTermTaskId,
        title: '准备考试',
        startDate: DateTime(2026, 7, 4),
        dueDate: DateTime(2026, 7, 5),
        childTaskTitles: const ['整理资料', '完成第一章'],
      );

      expect(controller.longTermTasks.single.totalTaskCount, 3);
      expect(controller.longTermTasks.single.dueDate, DateTime(2026, 7, 6));
      expect(controller.longTermChildTasks(longTermTaskId), hasLength(3));
    },
  );

  test(
    'node 4 controller cancels active children outside shortened date range',
    () {
      final controller = TaskSystemController(today: DateTime(2026, 7, 4));

      controller.createLongTermTask(
        '准备考试',
        childTaskTitles: const ['整理资料', '完成第一章', '做模拟题'],
      );
      final longTermTaskId = controller.longTermTasks.single.longTermTaskId;

      controller.updateLongTermTaskPlan(
        longTermTaskId,
        title: '准备考试',
        startDate: DateTime(2026, 7, 4),
        dueDate: DateTime(2026, 7, 5),
        childTaskTitles: const ['整理资料', '完成第一章'],
      );

      expect(controller.longTermTasks.single.totalTaskCount, 2);
      expect(
        controller
            .longTermChildTasks(longTermTaskId)
            .where((task) => task.status == TaskStatus.active),
        hasLength(2),
      );
      expect(
        controller.cancelledTasks.where(
          (task) => task.parentLongTermTaskId == longTermTaskId,
        ),
        hasLength(1),
      );
    },
  );

  test('node 4 controller records reminder intent and repeat placeholder', () {
    final controller = TaskSystemController(today: DateTime(2026, 7, 4));

    controller.createTask(
      '缴水电费',
      reminderTime: '21:30',
      repeatRuleId: 'monthly_placeholder',
    );

    expect(controller.reminderIntents, hasLength(1));
    expect(controller.tasks.single.reminderId, 'rem_1');
    expect(controller.tasks.single.dueTime, '21:30');
    expect(controller.tasks.single.repeatRuleId, 'monthly_placeholder');
    expect(controller.reminderIntents.single.plannedAt.hour, 21);
    expect(controller.reminderIntents.single.plannedAt.minute, 30);
    expect(
      controller.reminderIntents.single.eventName,
      'notification_scheduled',
    );
  });

  test('node 4 controller edits existing task reminder and repeat options', () {
    final controller = TaskSystemController(today: DateTime(2026, 7, 4));

    controller.createTask('缴水电费');
    final taskId = controller.tasks.single.id;

    controller.setTaskRepeatPlaceholder(taskId, true);
    expect(
      controller.tasks.single.repeatRuleId,
      TaskSystemController.repeatPlaceholderRuleId,
    );

    controller.setTaskReminderIntent(taskId, '22:15');
    expect(controller.tasks.single.dueTime, '22:15');
    expect(controller.tasks.single.reminderId, 'rem_1');
    expect(controller.reminderIntents.single.plannedAt.hour, 22);
    expect(controller.reminderIntents.single.plannedAt.minute, 15);

    controller.setTaskRepeatPlaceholder(taskId, false);
    controller.setTaskReminderIntent(taskId, null);
    expect(controller.tasks.single.repeatRuleId, isNull);
    expect(controller.tasks.single.dueTime, isNull);
    expect(controller.tasks.single.reminderId, isNull);
    expect(controller.reminderIntents, isEmpty);
  });

  testWidgets('shows scoped new-task options and edits existing task options', (
    tester,
  ) async {
    await tester.pumpWidget(const ListMonsterApp());

    Finder titleInput() => find.byWidgetPredicate(
      (widget) =>
          widget is TextField && widget.decoration?.labelText == '今天要完成什么',
    );

    expect(find.text('新任务选项'), findsOneWidget);
    expect(find.textContaining('只应用到下一次新增的任务'), findsOneWidget);

    final addButton = find.text('加入今日');
    await tester.enterText(titleInput(), '缴水电费');
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();

    final repeatButton = find.byTooltip('设为重复占位');
    await tester.ensureVisible(repeatButton);
    await tester.tap(repeatButton);
    await tester.pump();
    expect(find.textContaining('进行中 · 重复占位'), findsOneWidget);

    final reminderButton = find.byTooltip('设置提醒时间');
    await tester.ensureVisible(reminderButton);
    await tester.tap(reminderButton);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '22:15');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();
    expect(find.textContaining('提醒 22:15'), findsOneWidget);

    final newTaskRepeatSwitch = find.widgetWithText(SwitchListTile, '新任务重复占位');
    await tester.ensureVisible(newTaskRepeatSwitch);
    await tester.tap(newTaskRepeatSwitch);
    await tester.pump();
    final newTaskReminderSwitch = find.widgetWithText(
      SwitchListTile,
      '新任务提醒意图',
    );
    await tester.ensureVisible(newTaskReminderSwitch);
    await tester.tap(newTaskReminderSwitch);
    await tester.pump();
    final reminderTimeInput = find.widgetWithText(TextField, '提醒时间');
    await tester.ensureVisible(reminderTimeInput);
    await tester.enterText(reminderTimeInput, '21:30');
    await tester.ensureVisible(titleInput());
    await tester.enterText(titleInput(), '明天买牛奶');
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();

    expect(find.textContaining('提醒 21:30 · 重复占位'), findsOneWidget);
  });

  testWidgets('shows node 4 today cleanup and restore entry points', (
    tester,
  ) async {
    await tester.pumpWidget(const ListMonsterApp());

    final input = find.byType(EditableText);
    final addButton = find.text('加入今日');
    await tester.enterText(input, '整理收集箱');
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();

    final letGoButton = find.byTooltip('放下任务');
    await tester.ensureVisible(letGoButton);
    await tester.tap(letGoButton);
    await tester.pump();

    final letGoSection = find.widgetWithText(ExpansionTile, '已放下');
    await tester.ensureVisible(letGoSection);
    await tester.tap(letGoSection);
    await tester.pumpAndSettle();

    expect(find.text('恢复'), findsOneWidget);
  });

  testWidgets('shows long-term tasks without list grouping folders', (
    tester,
  ) async {
    await tester.pumpWidget(const ListMonsterApp());

    await tester.tap(find.text('长期'));
    await tester.pumpAndSettle();

    expect(find.text('长期任务'), findsOneWidget);
    expect(find.text('清单分组'), findsNothing);
    expect(find.text('收集箱'), findsNothing);
    expect(find.text('生活'), findsNothing);

    await tester.tap(find.text('创建长期任务'));
    await tester.pumpAndSettle();

    expect(find.text('手动拆解'), findsOneWidget);
    expect(find.text('AI 拆解（后续）'), findsOneWidget);
    expect(find.textContaining('对应日期的任务'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '开始日期'), findsNothing);
    expect(find.widgetWithText(TextFormField, '截止日期'), findsNothing);
    expect(
      find.byKey(const ValueKey('long-term-start-date-picker')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('long-term-due-date-picker')),
      findsOneWidget,
    );
    final aiChip = tester.widget<InputChip>(
      find.widgetWithText(InputChip, 'AI 拆解（后续）'),
    );
    expect(aiChip.isEnabled, isFalse);

    await tester.enterText(find.widgetWithText(TextFormField, '长期目标'), '准备考试');
    final startDate = _dateOnly(DateTime.now());
    await tester.enterText(_longTermStepField(1, startDate: startDate), '整理资料');
    await tester.enterText(
      _longTermStepField(2, startDate: startDate),
      '完成第一章',
    );
    await tester.enterText(_longTermStepField(3, startDate: startDate), '做模拟题');
    await tester.tap(find.text('创建'));
    await tester.pumpAndSettle();

    expect(find.text('准备考试'), findsOneWidget);
    expect(find.text('读一本书'), findsNothing);
    expect(find.textContaining('0/3 · 进行中'), findsOneWidget);

    await tester.tap(find.widgetWithText(ExpansionTile, '准备考试'));
    await tester.pumpAndSettle();

    expect(find.text('整理资料'), findsOneWidget);
    expect(find.text('完成第一章'), findsOneWidget);
    expect(find.text('做模拟题'), findsOneWidget);
  });

  testWidgets('validates long-term task manual breakdown form', (tester) async {
    await tester.pumpWidget(const ListMonsterApp());

    await tester.tap(find.text('长期'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('创建长期任务'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('创建'));
    await tester.pumpAndSettle();

    expect(find.text('请输入长期目标'), findsOneWidget);
    expect(find.text('请输入第 1 天任务'), findsOneWidget);
    expect(find.text('请输入第 2 天任务'), findsOneWidget);
    expect(find.text('请输入第 3 天任务'), findsOneWidget);
    expect(find.widgetWithText(ExpansionTile, '准备考试'), findsNothing);

    await tester.enterText(find.widgetWithText(TextFormField, '长期目标'), '准备考试');
    final startDate = _dateOnly(DateTime.now());
    await tester.enterText(_longTermStepField(1, startDate: startDate), '整理资料');
    await tester.enterText(
      _longTermStepField(2, startDate: startDate),
      '完成第一章',
    );
    await tester.tap(find.text('创建'));
    await tester.pumpAndSettle();

    expect(find.text('请输入第 3 天任务'), findsOneWidget);
    expect(find.widgetWithText(ExpansionTile, '准备考试'), findsNothing);
  });

  testWidgets('creates long-term task from custom date range', (tester) async {
    await tester.pumpWidget(const ListMonsterApp());

    await tester.tap(find.text('长期'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('创建长期任务'));
    await tester.pumpAndSettle();

    final startDate = DateTime(2026, 7, 10);
    final dueDate = DateTime(2026, 7, 14);
    await _selectLongTermDate(
      tester,
      const ValueKey('long-term-start-date-picker'),
      startDate,
    );
    await _selectLongTermDate(
      tester,
      const ValueKey('long-term-due-date-picker'),
      dueDate,
    );

    expect(_longTermStepField(5, startDate: startDate), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, '长期目标'), '做作品集');
    for (var day = 1; day <= 5; day++) {
      await tester.enterText(
        _longTermStepField(day, startDate: startDate),
        '作品集第 $day 步',
      );
    }
    await tester.tap(find.text('创建'));
    await tester.pumpAndSettle();

    expect(find.text('做作品集'), findsOneWidget);
    expect(find.textContaining('0/5 · 进行中'), findsOneWidget);
    expect(find.textContaining('7/10-7/14'), findsOneWidget);
  });

  testWidgets('edits long-term task date range from the task card', (
    tester,
  ) async {
    await tester.pumpWidget(const ListMonsterApp());

    await tester.tap(find.text('长期'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('创建长期任务'));
    await tester.pumpAndSettle();

    final startDate = _dateOnly(DateTime.now());
    await tester.enterText(find.widgetWithText(TextFormField, '长期目标'), '准备考试');
    await tester.enterText(_longTermStepField(1, startDate: startDate), '整理资料');
    await tester.enterText(
      _longTermStepField(2, startDate: startDate),
      '完成第一章',
    );
    await tester.enterText(_longTermStepField(3, startDate: startDate), '做模拟题');
    await tester.tap(find.text('创建'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ExpansionTile, '准备考试'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑日期与拆解'));
    await tester.pumpAndSettle();

    final newDueDate = startDate.add(const Duration(days: 4));
    await _selectLongTermDate(
      tester,
      const ValueKey('long-term-due-date-picker'),
      newDueDate,
    );
    await tester.enterText(_longTermStepField(4, startDate: startDate), '错题整理');
    await tester.enterText(_longTermStepField(5, startDate: startDate), '复盘检查');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.textContaining('0/5 · 进行中'), findsOneWidget);
    await tester.tap(find.widgetWithText(ExpansionTile, '准备考试'));
    await tester.pumpAndSettle();
    expect(find.text('复盘检查'), findsOneWidget);
  });

  testWidgets('confirms shortening long-term task date range', (tester) async {
    await tester.pumpWidget(const ListMonsterApp());

    await tester.tap(find.text('长期'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('创建长期任务'));
    await tester.pumpAndSettle();

    final startDate = _dateOnly(DateTime.now());
    await tester.enterText(find.widgetWithText(TextFormField, '长期目标'), '准备考试');
    await tester.enterText(_longTermStepField(1, startDate: startDate), '整理资料');
    await tester.enterText(
      _longTermStepField(2, startDate: startDate),
      '完成第一章',
    );
    await tester.enterText(_longTermStepField(3, startDate: startDate), '做模拟题');
    await tester.tap(find.text('创建'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ExpansionTile, '准备考试'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑日期与拆解'));
    await tester.pumpAndSettle();

    final shortenedDueDate = startDate.add(const Duration(days: 1));
    await _selectLongTermDate(
      tester,
      const ValueKey('long-term-due-date-picker'),
      shortenedDueDate,
    );
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('调整长期任务日期'), findsOneWidget);
    expect(find.textContaining('1 个未完成拆解任务'), findsOneWidget);
    await tester.tap(find.text('确认保存'));
    await tester.pumpAndSettle();

    expect(find.textContaining('0/2 · 进行中'), findsOneWidget);
  });

  testWidgets('me page shows guest, simulated login, deletion pending states', (
    tester,
  ) async {
    final store = MemoryLocalStore();
    final accountSession = AccountSessionController(
      localStore: store,
      now: () => DateTime.utc(2026, 7, 7, 8),
    );
    final taskSystem = TaskSystemController(
      today: DateTime(2026, 7, 7),
      now: DateTime(2026, 7, 7, 8),
    );
    addTearDown(accountSession.dispose);
    addTearDown(taskSystem.dispose);

    await tester.pumpWidget(
      ListMonsterApp(
        accountSessionController: accountSession,
        taskSystemController: taskSystem,
      ),
    );
    await tester.pumpAndSettle();
    await _switchToEnglish(tester);

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    expect(find.text('Guest'), findsOneWidget);

    await tester.tap(find.text('Local simulated login'));
    await tester.pumpAndSettle();
    expect(find.text('Signed in'), findsOneWidget);
    expect(accountSession.status, AccountStatus.registered);

    await tester.tap(find.text('Request deletion'));
    await tester.pumpAndSettle();
    expect(find.text('Deletion cooling-off'), findsOneWidget);
    expect(find.textContaining('Cancel deletion before editing'), findsWidgets);

    await _clearSnackBars(tester);
    final cancelDeletionButton = find.widgetWithText(
      FilledButton,
      'Cancel deletion',
    );
    await tester.ensureVisible(cancelDeletionButton);
    await tester.tap(cancelDeletionButton);
    await tester.pumpAndSettle();
    expect(find.text('Signed in'), findsOneWidget);
    expect(accountSession.status, AccountStatus.registered);
  });

  testWidgets('simulated login shows merge confirmation and cancel is no-op', (
    tester,
  ) async {
    final store = MemoryLocalStore();
    final accountSession = AccountSessionController(
      localStore: store,
      now: () => DateTime.utc(2026, 7, 7, 8),
    );
    final taskSystem = TaskSystemController(
      today: DateTime(2026, 7, 7),
      now: DateTime(2026, 7, 7, 8),
    );
    taskSystem.createTask('local guest task');
    addTearDown(accountSession.dispose);
    addTearDown(taskSystem.dispose);

    await tester.pumpWidget(
      ListMonsterApp(
        accountSessionController: accountSession,
        taskSystemController: taskSystem,
      ),
    );
    await tester.pumpAndSettle();
    await _switchToEnglish(tester);
    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Local simulated login'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Confirm guest data merge'),
      ),
      findsOneWidget,
    );
    expect(accountSession.hasPendingMerge, isTrue);
    await tester.tap(find.text('Cancel merge').last);
    await tester.pumpAndSettle();

    final queue = await store.readSyncQueue();
    expect(accountSession.status, AccountStatus.guest);
    expect(accountSession.hasPendingMerge, isFalse);
    expect(taskSystem.tasks.single.title, 'local guest task');
    expect(queue, isEmpty);
  });

  testWidgets('deletion pending blocks app write entries until cancelled', (
    tester,
  ) async {
    final accountSession = AccountSessionController(
      now: () => DateTime.utc(2026, 7, 7, 8),
    );
    await accountSession.restore();
    await accountSession.simulateLogin(guestTaskCount: 0, cloudTaskCount: 0);
    await accountSession.requestDeletion();
    final taskSystem = TaskSystemController(
      today: DateTime(2026, 7, 7),
      now: DateTime(2026, 7, 7, 8),
    );
    addTearDown(accountSession.dispose);
    addTearDown(taskSystem.dispose);

    await tester.pumpWidget(
      ListMonsterApp(
        accountSessionController: accountSession,
        taskSystemController: taskSystem,
      ),
    );
    await tester.pumpAndSettle();
    await _switchToEnglish(tester);

    await tester.enterText(
      find.widgetWithText(TextField, 'What needs to get done today?'),
      'blocked task',
    );
    final addButton = find.text('Add to Today');
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(taskSystem.tasks, isEmpty);
    expect(find.textContaining('Cancel deletion before editing'), findsWidgets);

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    await _clearSnackBars(tester);
    final cancelDeletionButton = find.widgetWithText(
      FilledButton,
      'Cancel deletion',
    );
    await tester.ensureVisible(cancelDeletionButton);
    await tester.tap(cancelDeletionButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Today').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'What needs to get done today?'),
      'allowed task',
    );
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();

    expect(taskSystem.tasks.single.title, 'allowed task');
  });
}

Finder _longTermStepField(int day, {DateTime? startDate}) =>
    find.widgetWithText(TextFormField, '第 $day 天任务');

Future<void> _selectLongTermDate(
  WidgetTester tester,
  ValueKey<String> fieldKey,
  DateTime date,
) async {
  await tester.tap(find.byKey(fieldKey));
  await tester.pumpAndSettle();
  expect(find.textContaining('选择'), findsWidgets);

  await tester.tap(find.text(date.day.toString()).last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('确定'));
  await tester.pumpAndSettle();
}

Future<void> _switchToEnglish(WidgetTester tester) async {
  if (find.text('EN').evaluate().isNotEmpty) {
    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
  }
}

Future<void> _clearSnackBars(WidgetTester tester) async {
  ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
  await tester.pumpAndSettle();
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
