import 'package:companion_contract/companion_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/desktop_pet/desktop_pet.dart';

void main() {
  test('opens and closes with only desktop pet on/off states', () async {
    final port = _FakeDesktopPetWindowPort();
    final controller = DesktopPetController(windowPort: port);
    addTearDown(controller.dispose);

    expect(controller.stateValue, 'desktop_pet_off');

    final snapshot = _snapshot(
      desktopPetState: CompanionDesktopPetState.enabled,
    );
    await controller.open(snapshot);

    expect(controller.stateValue, 'desktop_pet_on');
    expect(port.openedSnapshots, [snapshot]);

    await controller.close();

    expect(controller.stateValue, 'desktop_pet_off');
    expect(port.closeCount, 1);
  });

  test('encodes and decodes a companion snapshot for the pet window', () {
    final snapshot = _snapshot(
      desktopPetState: CompanionDesktopPetState.enabled,
      dndActive: true,
    );

    final decoded = decodeDesktopPetSnapshot(
      encodeDesktopPetSnapshot(snapshot),
    );

    expect(decoded.snapshotId, snapshot.snapshotId);
    expect(decoded.desktopPetState, CompanionDesktopPetState.enabled);
    expect(decoded.dndActive, isTrue);
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

CompanionSnapshot _snapshot({
  CompanionDesktopPetState desktopPetState = CompanionDesktopPetState.disabled,
  bool dndActive = false,
}) {
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
    lineText: 'Sensitive task title must not be shown',
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
    desktopPetState: desktopPetState,
    dndActive: dndActive,
    hideTaskTitlesOutsideApp: true,
  );
}
