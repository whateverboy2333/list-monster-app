import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/main.dart';
import 'package:list_monster_app/node3_core_loop.dart';
import 'package:monster_domain/monster_domain.dart';

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
}
