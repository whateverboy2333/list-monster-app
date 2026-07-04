import 'package:companion_contract/companion_contract.dart';
import 'package:test/test.dart';

void main() {
  test('computes remaining tasks from the snapshot draft', () {
    const snapshot = CompanionSnapshotDraft(
      schemaVersion: '0.1.3',
      monsterName: '小单',
      todayCompletedTasks: 2,
      todayTotalTasks: 5,
    );

    expect(snapshot.todayRemainingTasks, 3);
    expect(snapshot.staleAfterSeconds, 300);
  });
}

