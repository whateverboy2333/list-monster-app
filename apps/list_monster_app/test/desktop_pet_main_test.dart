import 'package:companion_contract/companion_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/account/account_session_controller.dart';
import 'package:list_monster_app/desktop_pet/desktop_pet.dart';
import 'package:list_monster_app/main.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:local_store/local_store.dart';

void main() {
  testWidgets('main app opens and closes desktop pet without exiting', (
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
    final port = _FakeDesktopPetWindowPort();
    addTearDown(accountSession.dispose);
    addTearDown(taskSystem.dispose);

    await tester.pumpWidget(
      ListMonsterApp(
        accountSessionController: accountSession,
        taskSystemController: taskSystem,
        desktopPetWindowPort: port,
        openedAt: DateTime(2026, 7, 7, 8),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.text('desktop_pet_off'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('desktop-pet-open-button')));
    await tester.pumpAndSettle();

    expect(find.text('desktop_pet_on'), findsWidgets);
    expect(port.openedSnapshots, hasLength(1));
    expect(
      port.openedSnapshots.single.desktopPetState,
      CompanionDesktopPetState.enabled,
    );
    final openedSnapshot = await store.readCompanionSnapshot(
      now: DateTime.utc(2026, 7, 7, 8),
    );
    expect(openedSnapshot?.payload['desktopPetState'], 'on');

    await tester.tap(find.byKey(const ValueKey('desktop-pet-close-button')));
    await tester.pumpAndSettle();

    expect(find.text('desktop_pet_off'), findsWidgets);
    expect(port.closeCount, 1);
    final closedSnapshot = await store.readCompanionSnapshot(
      now: DateTime.utc(2026, 7, 7, 8),
    );
    expect(closedSnapshot?.payload['desktopPetState'], 'off');
    expect(find.byType(ListMonsterShell), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}

class _FakeDesktopPetWindowPort implements DesktopPetWindowPort {
  final openedSnapshots = <CompanionSnapshot>[];
  int closeCount = 0;

  @override
  Future<void> open(CompanionSnapshot snapshot) async {
    openedSnapshots.add(snapshot);
  }

  @override
  Future<void> close() async {
    closeCount += 1;
  }
}
