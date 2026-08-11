import 'dart:io';

import 'package:companion_contract/companion_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/companion_snapshot/companion_snapshot_refresh_service.dart';
import 'package:list_monster_app/desktop_pet/desktop_pet.dart';

void main() {
  test('desktop pet module stays on the companion snapshot contract', () {
    final source = File('lib/desktop_pet/desktop_pet.dart').readAsStringSync();

    expect(source, isNot(contains('TaskSystemController')));
    expect(source, isNot(contains('task_domain')));
    expect(source, isNot(contains('xpLedger')));
    expect(source, isNot(contains('.tasks')));
    expect(source, isNot(contains('.streak')));
  });

  test('do-not-disturb snapshot uses low motion and no strong feedback', () {
    final model = DesktopPetViewModel.fromSnapshot(_snapshot(dndActive: true));

    expect(model.motion, DesktopPetMotion.low);
    expect(model.showReminderBubble, isFalse);
    expect(model.playsSound, isFalse);
    expect(model.usesStrongFeedback, isFalse);
  });

  testWidgets('renders generic reminder copy without task titles', (
    tester,
  ) async {
    const sensitiveTitle = 'Pay the private invoice';
    await tester.pumpWidget(
      MaterialApp(
        home: DesktopPetSnapshotView(
          snapshotSource: _FakeSnapshotSource(
            _snapshot(lineText: sensitiveTitle),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A gentle check-in is ready.'), findsOneWidget);
    expect(find.textContaining(sensitiveTitle), findsNothing);
    expect(
      find.byKey(const ValueKey('desktop-pet-reminder-bubble')),
      findsOneWidget,
    );
  });

  testWidgets(
    'renders the completed task progress without leaking model text',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DesktopPetSnapshotView(
            snapshotSource: _FakeSnapshotSource(_snapshot()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Today 1/3'), findsOneWidget);
      expect(find.textContaining('DesktopPetViewModel'), findsNothing);
    },
  );

  testWidgets('do-not-disturb snapshot suppresses reminder bubble', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DesktopPetSnapshotView(
          snapshotSource: _FakeSnapshotSource(_snapshot(dndActive: true)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('desktop-pet-reminder-bubble')),
      findsNothing,
    );
    expect(find.text('Quietly keeping you company.'), findsNothing);
  });
}

class _FakeSnapshotSource implements DesktopPetSnapshotSource {
  const _FakeSnapshotSource(this.snapshot);

  final CompanionSnapshot snapshot;

  @override
  Future<CompanionSnapshotReadResult> read() async {
    return CompanionSnapshotReadResult.fresh(snapshot);
  }
}

CompanionSnapshot _snapshot({String? lineText, bool dndActive = false}) {
  return CompanionSnapshot(
    schemaVersion: '0.1.3',
    snapshotId: 'snapshot-1',
    userId: 'user-1',
    generatedAt: DateTime.utc(2026, 7, 7, 8),
    isStale: false,
    staleAfterSeconds: 300,
    timezoneId: 'Asia/Shanghai',
    monsterId: 'monster-1',
    monsterName: 'Xiaodan',
    styleLine: CompanionStyleLine.soft,
    stage: CompanionStage.child,
    level: 2,
    xpProgressPercent: 0.4,
    moodState: CompanionMoodState.expecting,
    actionKey: 'idle',
    spriteAssetId: 'sprite-child-expecting',
    widgetFrameAssetId: 'widget-child-soft',
    lineText: lineText ?? 'Sensitive task title must not be shown',
    todayCompletedTasks: 1,
    todayTotalTasks: 3,
    todayRemainingTasks: 2,
    todayTaskMilestoneKey: null,
    todayTaskMilestoneTitle: null,
    previousDaySummaryDate: null,
    previousDayCompletedEligibleTasks: null,
    previousDayFeedbackTitle: null,
    previousDayFeedbackText: null,
    currentStreakDays: 4,
    bestStreakDays: 5,
    desktopPetState: CompanionDesktopPetState.enabled,
    dndActive: dndActive,
    hideTaskTitlesOutsideApp: true,
  );
}
