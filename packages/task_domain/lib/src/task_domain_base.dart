enum TaskStatus { active, completed, cancelled, deleted }

enum TaskType { normal, longTermChild }

class TaskDraft {
  const TaskDraft({
    required this.title,
    this.type = TaskType.normal,
    this.rewardEligible = true,
  });

  final String title;
  final TaskType type;
  final bool rewardEligible;

  bool get canCreate => title.trim().isNotEmpty;
}

