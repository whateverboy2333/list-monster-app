import 'package:companion_contract/companion_contract.dart';

void main() {
  const snapshot = CompanionSnapshotDraft(
    schemaVersion: '0.1.3',
    monsterName: '小单',
    todayCompletedTasks: 1,
    todayTotalTasks: 3,
  );

  print(snapshot.todayRemainingTasks);
}

