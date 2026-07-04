import 'package:task_domain/task_domain.dart';
import 'package:test/test.dart';

void main() {
  test('requires a title before a task can be created', () {
    expect(const TaskDraft(title: '').canCreate, isFalse);
    expect(const TaskDraft(title: '写下今天第一件小事').canCreate, isTrue);
  });

  test('defaults normal tasks to reward eligible', () {
    const draft = TaskDraft(title: '完成任务');

    expect(draft.type, TaskType.normal);
    expect(draft.rewardEligible, isTrue);
  });
}

