import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/account/account_session_controller.dart';
import 'package:list_monster_app/companion_snapshot/android_widget_bridge.dart';
import 'package:list_monster_app/main.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:local_store/local_store.dart';

void main() {
  testWidgets(
    'android widget monster launch opens monster tab and refreshes without growth side effects',
    (tester) async {
      final bridge = _FakeAndroidWidgetBridge(
        initialIntent: const AndroidWidgetLaunchIntent(
          destination: AndroidWidgetDestination.monster,
          refreshCompanionSnapshot: true,
          source: 'android_widget',
          widgetId: 1,
        ),
      );
      final accountSession = AccountSessionController(
        localStore: MemoryLocalStore(),
      );
      final taskSystem = TaskSystemController(
        today: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 7, 10),
      );
      addTearDown(accountSession.dispose);
      addTearDown(taskSystem.dispose);

      taskSystem.createTask('finish report');
      taskSystem.completeTask(taskSystem.tasks.single.id);
      final xpLedgerLength = taskSystem.xpLedger.length;
      final currentStreakDays = taskSystem.streak.currentStreakDays;

      await tester.pumpWidget(
        ListMonsterApp(
          accountSessionController: accountSession,
          taskSystemController: taskSystem,
          androidWidgetBridge: bridge,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        2,
      );
      expect(bridge.persistedSnapshots, hasLength(1));
      expect(taskSystem.xpLedger, hasLength(xpLedgerLength));
      expect(taskSystem.streak.currentStreakDays, currentStreakDays);
    },
  );

  testWidgets(
    'running android widget today launch opens today tab and consumes refresh intent',
    (tester) async {
      final bridge = _FakeAndroidWidgetBridge();
      final accountSession = AccountSessionController(
        localStore: MemoryLocalStore(),
      );
      final taskSystem = TaskSystemController(
        today: DateTime(2026, 7, 7),
        now: DateTime(2026, 7, 7, 10),
      );
      addTearDown(accountSession.dispose);
      addTearDown(taskSystem.dispose);

      await tester.pumpWidget(
        ListMonsterApp(
          accountSessionController: accountSession,
          taskSystemController: taskSystem,
          androidWidgetBridge: bridge,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.egg_alt_outlined).last);
      await tester.pumpAndSettle();
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        2,
      );

      await bridge.emit(
        const AndroidWidgetLaunchIntent(
          destination: AndroidWidgetDestination.today,
          refreshCompanionSnapshot: true,
          source: 'android_widget',
          widgetId: 2,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        0,
      );
      expect(bridge.persistedSnapshots, hasLength(1));
    },
  );
}

final class _FakeAndroidWidgetBridge implements CompanionSnapshotWidgetBridge {
  _FakeAndroidWidgetBridge({this.initialIntent});

  AndroidWidgetLaunchIntent? initialIntent;
  AndroidWidgetLaunchIntentHandler? _handler;
  final List<LocalCompanionSnapshot> persistedSnapshots = [];

  Future<void> emit(AndroidWidgetLaunchIntent intent) async {
    await _handler?.call(intent);
  }

  @override
  Future<AndroidWidgetLaunchIntent?> consumeInitialWidgetLaunchIntent() async {
    final intent = initialIntent;
    initialIntent = null;
    return intent;
  }

  @override
  Future<void> persistSnapshot(LocalCompanionSnapshot snapshot) async {
    persistedSnapshots.add(snapshot);
  }

  @override
  void setWidgetLaunchIntentHandler(AndroidWidgetLaunchIntentHandler? handler) {
    _handler = handler;
  }
}
