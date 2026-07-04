class CompanionSnapshotDraft {
  const CompanionSnapshotDraft({
    required this.schemaVersion,
    required this.monsterName,
    required this.todayCompletedTasks,
    required this.todayTotalTasks,
    this.staleAfterSeconds = 300,
  });

  final String schemaVersion;
  final String monsterName;
  final int todayCompletedTasks;
  final int todayTotalTasks;
  final int staleAfterSeconds;

  int get todayRemainingTasks => todayTotalTasks - todayCompletedTasks;
}

