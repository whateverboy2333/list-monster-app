import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/main.dart';
import 'package:list_monster_app/node3_core_loop.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:task_domain/task_domain.dart';

void main() {
  testWidgets('shows the node 2 app shell', (tester) async {
    await tester.pumpWidget(const ListMonsterApp());

    expect(find.text('清单怪兽'), findsOneWidget);
    expect(find.text('今日'), findsWidgets);
    expect(find.text('清单'), findsOneWidget);
    expect(find.text('怪兽'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);
    expect(find.text('小单正在等第一个任务'), findsOneWidget);
  });

  testWidgets('runs the node 3 local core loop', (tester) async {
    await tester.pumpWidget(const ListMonsterApp());

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

      controller.createLongTermTask('读一本书');

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

    controller.createLongTermTask('读一本书');
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
    expect(find.textContaining('active · inbox · 重复占位'), findsOneWidget);

    final reminderButton = find.byTooltip('设置提醒时间');
    await tester.ensureVisible(reminderButton);
    await tester.tap(reminderButton);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '22:15');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();
    expect(find.textContaining('提醒 22:15'), findsOneWidget);

    await tester.tap(find.widgetWithText(SwitchListTile, '新任务重复占位'));
    await tester.pump();
    await tester.tap(find.widgetWithText(SwitchListTile, '新任务提醒意图'));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, '提醒时间'), '21:30');
    await tester.enterText(titleInput(), '明天买牛奶');
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();

    expect(find.textContaining('提醒 21:30 · 重复占位'), findsOneWidget);
  });

  testWidgets('shows node 4 list grouping and restore entry points', (
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

    await tester.tap(find.text('清单'));
    await tester.pumpAndSettle();

    expect(find.text('清单分组'), findsOneWidget);
    expect(find.text('已放下'), findsOneWidget);
    expect(find.text('恢复'), findsOneWidget);
  });
}
