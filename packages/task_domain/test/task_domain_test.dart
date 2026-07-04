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

  test('uses frozen contract names instead of Dart enum names', () {
    expect(TaskStatus.completed.contractName, 'completed');
    expect(TaskType.longTermChild.contractName, 'long_term_child');
    expect(TaskPriority.high.contractName, 'high');
    expect(TaskDateSource.defaultToday.contractName, 'default_today');
    expect(CompletionSource.userAction.contractName, 'user_action');
  });

  test("creates today's task when no date is selected", () {
    final today = DateTime(2026, 7, 4);
    final task = TaskItem.create(
      id: 'task_1',
      userId: 'local_guest',
      draft: const TaskDraft(title: '写下今天第一件小事'),
      today: today,
    );

    expect(task.status, TaskStatus.active);
    expect(task.scheduledDate, today);
    expect(task.dateSource, TaskDateSource.defaultToday);
    expect(task.rewardEligible, isTrue);
  });

  test('completes a rewardable task with contract event data', () {
    final today = DateTime(2026, 7, 4);
    final completedAt = DateTime(2026, 7, 4, 9, 30);
    final task = TaskItem.create(
      id: 'task_1',
      userId: 'local_guest',
      draft: const TaskDraft(title: '完成任务'),
      today: today,
    );

    final result = task.complete(
      eventId: 'evt_1',
      completedAt: completedAt,
      timezoneId: 'Asia/Shanghai',
      completionOrderOfDay: 3,
      dailyRewardableCountAfter: 3,
      dailyTodayTaskCountAfter: 3,
    );

    expect(result.task.status, TaskStatus.completed);
    expect(result.task.completedAt, completedAt);
    expect(result.event.eventName, 'task_completed');
    expect(result.event.thresholdCrossed, 'small_start');
    expect(result.event.dailyRewardableCountAfter, 3);
    expect(result.event.completionSource, CompletionSource.userAction);
    expect(result.event.payload['taskType'], 'normal');
    expect(result.event.payload['completedLocalDate'], '2026-07-04');
    expect(result.event.payload['scheduledDate'], '2026-07-04');
    expect(result.event.payload['completionSource'], 'user_action');
    expect(result.event.payload['parentLongTermTaskId'], isNull);
  });
}
