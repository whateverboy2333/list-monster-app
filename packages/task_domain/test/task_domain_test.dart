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
    expect(NotificationPrivacyMode.private.contractName, 'private');
    expect(TaskDateSource.defaultToday.contractName, 'default_today');
    expect(CompletionSource.userAction.contractName, 'user_action');
    expect(TaskListType.inbox.contractName, 'inbox');
    expect(BatchCleanupAction.letGo.contractName, 'let_go');
    expect(LongTermTaskStatus.achieved.contractName, 'achieved');
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

    final event = task.toCreatedEvent(
      eventId: 'evt_created',
      createdAt: DateTime(2026, 7, 4, 8),
    );
    expect(event.eventName, 'task_created');
    expect(event.payload['listId'], 'inbox');
    expect(event.payload['dateSource'], 'default_today');
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

  test('undoes a completed task with a task_completion_undone event', () {
    final task =
        TaskItem.create(
              id: 'task_1',
              userId: 'local_guest',
              draft: const TaskDraft(title: 'Complete me'),
              today: DateTime(2026, 7, 4),
            )
            .complete(
              eventId: 'evt_complete',
              completedAt: DateTime(2026, 7, 4, 9),
              timezoneId: 'Asia/Shanghai',
              completionOrderOfDay: 1,
              dailyRewardableCountAfter: 1,
              dailyTodayTaskCountAfter: 1,
            )
            .task;

    final result = task.undoCompletion(
      eventId: 'evt_undo',
      undoneAt: DateTime(2026, 7, 4, 10),
      thresholdReverted: null,
    );

    expect(result.task.status, TaskStatus.active);
    expect(result.task.completedAt, isNull);
    expect(result.event.eventName, 'task_completion_undone');
    expect(result.event.payload['originalCompletedEventId'], 'evt_complete');
  });

  test(
    'cancels deletes and restores tasks without making completion events',
    () {
      final task = TaskItem.create(
        id: 'task_1',
        userId: 'local_guest',
        draft: const TaskDraft(title: 'Let go'),
        today: DateTime(2026, 7, 4),
      );

      final cancelled = task.cancel(
        eventId: 'evt_cancel',
        cancelledAt: DateTime(2026, 7, 4, 10),
        cancelReason: 'let_go',
      );
      final deleted = cancelled.task.delete(
        eventId: 'evt_delete',
        deletedAt: DateTime(2026, 7, 4, 11),
        deleteReason: 'cleanup',
      );
      final restored = deleted.task.restore(
        eventId: 'evt_restore',
        restoredAt: DateTime(2026, 7, 4, 12),
        restoreReason: 'undo_cleanup',
        restoredFromEventId: 'evt_delete',
      );

      expect(cancelled.task.status, TaskStatus.cancelled);
      expect(cancelled.event.eventName, 'task_cancelled');
      expect(cancelled.event.payload['cancelReason'], 'let_go');
      expect(deleted.task.status, TaskStatus.deleted);
      expect(deleted.event.payload['previousStatus'], 'cancelled');
      expect(restored.task.status, TaskStatus.active);
      expect(restored.event.eventName, 'task_restored');
      expect(restored.event.payload['restoredStatus'], 'active');
    },
  );

  test(
    'blocks cancelling a completed task without undoing completion first',
    () {
      final task =
          TaskItem.create(
                id: 'task_1',
                userId: 'local_guest',
                draft: const TaskDraft(title: 'Done'),
                today: DateTime(2026, 7, 4),
              )
              .complete(
                eventId: 'evt_complete',
                completedAt: DateTime(2026, 7, 4, 9),
                timezoneId: 'Asia/Shanghai',
                completionOrderOfDay: 1,
                dailyRewardableCountAfter: 1,
                dailyTodayTaskCountAfter: 1,
              )
              .task;

      expect(
        () => task.cancel(
          eventId: 'evt_cancel',
          cancelledAt: DateTime(2026, 7, 4, 10),
          cancelReason: 'let_go',
        ),
        throwsStateError,
      );
    },
  );

  test('creates task list and reminder intent contract data', () {
    const inbox = TaskList.systemInbox(userId: 'local_guest');
    final reminder = ReminderIntent.tonight(
      reminderId: 'rem_1',
      taskId: 'task_1',
      localNow: DateTime(2026, 7, 4, 18),
    );

    final task = TaskItem.create(
      id: 'task_1',
      userId: 'local_guest',
      draft: TaskDraft(
        title: 'With reminder',
        listId: inbox.listId,
        dueTime: '20:00',
        reminderId: reminder.reminderId,
        repeatRuleId: 'daily_placeholder',
      ),
      today: DateTime(2026, 7, 4),
    );

    expect(inbox.listType, TaskListType.inbox);
    expect(task.listId, 'inbox');
    expect(task.reminderId, 'rem_1');
    expect(task.repeatRuleId, 'daily_placeholder');
    expect(reminder.eventName, 'notification_scheduled');
    expect(reminder.payload['respectDnd'], isTrue);
  });

  test('creates custom local reminder times', () {
    final reminder = ReminderIntent.localTime(
      reminderId: 'rem_custom',
      taskId: 'task_1',
      localDate: DateTime(2026, 7, 4),
      timeOfDay: '21:30',
    );

    expect(reminder.plannedAt, DateTime(2026, 7, 4, 21, 30));
    expect(reminder.deliverAt, reminder.plannedAt);
    expect(reminder.payload['plannedAt'], '2026-07-04T21:30:00.000');
  });

  test('detects cross-day do not disturb windows', () {
    final dnd = DoNotDisturbWindow(startTime: '22:00', endTime: '07:00');

    expect(dnd.crossesMidnight, isTrue);
    expect(dnd.contains(DateTime(2026, 7, 4, 21, 59)), isFalse);
    expect(dnd.contains(DateTime(2026, 7, 4, 22)), isTrue);
    expect(dnd.contains(DateTime(2026, 7, 5, 6, 59)), isTrue);
    expect(dnd.contains(DateTime(2026, 7, 5, 7)), isFalse);
    expect(
      dnd.nextAllowedAt(DateTime(2026, 7, 4, 23, 30)),
      DateTime(2026, 7, 5, 7),
    );
    expect(
      dnd.nextAllowedAt(DateTime(2026, 7, 5, 6, 30)),
      DateTime(2026, 7, 5, 7),
    );
  });

  test('uses now plus one hour for tonight reminders after 20:00', () {
    final dnd = DoNotDisturbWindow(startTime: '23:00', endTime: '07:00');
    final reminder = ReminderIntent.tonight(
      reminderId: 'rem_tonight_late',
      taskId: 'task_1',
      localNow: DateTime(2026, 7, 4, 20, 30),
      dndWindow: dnd,
    );

    expect(reminder.plannedAt, DateTime(2026, 7, 4, 21, 30));
    expect(reminder.deliverAt, DateTime(2026, 7, 4, 21, 30));
    expect(dnd.contains(reminder.deliverAt), isFalse);
  });

  test('delays tonight reminders that would fall inside dnd', () {
    final dnd = DoNotDisturbWindow(startTime: '22:00', endTime: '07:00');
    final reminder = ReminderIntent.tonight(
      reminderId: 'rem_tonight_dnd',
      taskId: 'task_1',
      localNow: DateTime(2026, 7, 4, 21, 30),
      dndWindow: dnd,
    );

    expect(reminder.plannedAt, DateTime(2026, 7, 4, 22, 30));
    expect(reminder.deliverAt, DateTime(2026, 7, 5, 7));
    expect(dnd.contains(reminder.deliverAt), isFalse);
  });

  test('does not let high priority reminders bypass dnd by default', () {
    final dnd = DoNotDisturbWindow(startTime: '22:00', endTime: '07:00');
    final reminder = ReminderIntent.localTime(
      reminderId: 'rem_high',
      taskId: 'task_1',
      localDate: DateTime(2026, 7, 4),
      timeOfDay: '23:15',
      dndWindow: dnd,
      priority: TaskPriority.high,
    );

    expect(reminder.priority, TaskPriority.high);
    expect(reminder.respectDnd, isTrue);
    expect(reminder.deliverAt, DateTime(2026, 7, 5, 7));
    expect(reminder.payload['priority'], 'high');
    expect(reminder.payload['respectDnd'], isTrue);
  });

  test('uses a privacy-safe notification title by default', () {
    final reminder = ReminderIntent.localTime(
      reminderId: 'rem_private',
      taskId: 'task_1',
      localDate: DateTime(2026, 7, 4),
      timeOfDay: '21:30',
      taskTitle: 'Pick up medication',
    );

    expect(reminder.privacyMode, NotificationPrivacyMode.private);
    expect(reminder.notificationTitle, 'Task reminder');
    expect(reminder.payload['notificationTitle'], 'Task reminder');
    expect(reminder.payload['privacyMode'], 'private');
  });

  test('clears task optional scheduling fields through copyWith flags', () {
    final task = TaskItem.create(
      id: 'task_1',
      userId: 'local_guest',
      draft: const TaskDraft(
        title: 'Clear options',
        dueTime: '20:00',
        reminderId: 'rem_1',
        repeatRuleId: 'repeat_placeholder',
      ),
      today: DateTime(2026, 7, 4),
    );

    final cleared = task.copyWith(
      clearDueTime: true,
      clearReminderId: true,
      clearRepeatRuleId: true,
    );

    expect(cleared.dueTime, isNull);
    expect(cleared.reminderId, isNull);
    expect(cleared.repeatRuleId, isNull);
  });

  test(
    'creates long-term child tasks and achieves only from child progress',
    () {
      final longTerm = LongTermTask.create(
        longTermTaskId: 'long_1',
        userId: 'local_guest',
        title: 'Read a book',
        startDate: DateTime(2026, 7, 4),
        dueDate: DateTime(2026, 7, 6),
      );

      final generated = longTerm.generateChildTaskDrafts(
        childTaskTitles: const [
          'Read chapter 1',
          'Read chapter 2',
          'Review notes',
        ],
      );
      final progressed = longTerm.recordChildCompletion(
        eventId: 'evt_progress_1',
        completedTaskCount: 3,
        changedAt: DateTime(2026, 7, 6, 20),
      );

      expect(generated, hasLength(3));
      expect(generated.first.draft.type, TaskType.longTermChild);
      expect(generated.first.draft.parentLongTermTaskId, 'long_1');
      expect(generated.first.event.eventName, 'longterm_child_task_generated');
      expect(longTerm.canCompleteDirectly, isFalse);
      expect(progressed.task.status, LongTermTaskStatus.achieved);
      expect(progressed.progressEvent.eventName, 'longterm_progress_changed');
      expect(progressed.achievementEvent?.eventName, 'longterm_achieved');
    },
  );

  test('creates long-term child tasks with custom manual breakdown titles', () {
    final longTerm = LongTermTask.create(
      longTermTaskId: 'long_1',
      userId: 'local_guest',
      title: 'Prepare exam',
      startDate: DateTime(2026, 7, 4),
      dueDate: DateTime(2026, 7, 6),
    );

    final generated = longTerm.generateChildTaskDrafts(
      childTaskTitles: const ['整理资料', '完成第一章', '做模拟题'],
    );

    expect(generated, hasLength(3));
    expect(generated[0].draft.title, '整理资料');
    expect(generated[1].draft.title, '完成第一章');
    expect(generated[2].draft.title, '做模拟题');
    expect(generated[0].draft.scheduledDate, DateTime(2026, 7, 4));
    expect(generated[2].draft.scheduledDate, DateTime(2026, 7, 6));
  });

  test('updates long-term task date range through copyWith', () {
    final longTerm = LongTermTask.create(
      longTermTaskId: 'long_1',
      userId: 'local_guest',
      title: 'Prepare exam',
      startDate: DateTime(2026, 7, 4),
      dueDate: DateTime(2026, 7, 6),
    );

    final updated = longTerm.copyWith(
      title: 'Prepare final exam',
      dueDate: DateTime(2026, 7, 10),
      completedTaskCount: 2,
    );

    expect(updated.title, 'Prepare final exam');
    expect(updated.totalTaskCount, 7);
    expect(updated.completedTaskCount, 2);
    expect(updated.progress, closeTo(2 / 7, 0.001));
  });

  test('rejects blank manual long-term child task titles', () {
    final longTerm = LongTermTask.create(
      longTermTaskId: 'long_1',
      userId: 'local_guest',
      title: 'Prepare exam',
      startDate: DateTime(2026, 7, 4),
      dueDate: DateTime(2026, 7, 6),
    );

    expect(
      () => longTerm.generateChildTaskDrafts(
        childTaskTitles: const ['整理资料', '', '做模拟题'],
      ),
      throwsArgumentError,
    );
  });

  test('cancels a long-term task without marking it achieved', () {
    final longTerm = LongTermTask.create(
      longTermTaskId: 'long_1',
      userId: 'local_guest',
      title: 'Read a book',
      startDate: DateTime(2026, 7, 4),
      dueDate: DateTime(2026, 7, 6),
    );

    final result = longTerm.cancel(
      eventId: 'evt_long_cancel',
      cancelledAt: DateTime(2026, 7, 5, 12),
      cancelReason: 'let_go',
    );

    expect(
      longTerm.toCreatedEvent(eventId: 'evt_long_created').eventName,
      'longterm_created',
    );
    expect(result.task.status, LongTermTaskStatus.cancelled);
    expect(result.event.eventName, 'longterm_cancelled');
    expect(result.event.payload['cancelReason'], 'let_go');
  });

  test('rejects same-day long-term tasks', () {
    expect(
      () => LongTermTask.create(
        longTermTaskId: 'long_1',
        userId: 'local_guest',
        title: 'Not long term',
        startDate: DateTime(2026, 7, 4),
        dueDate: DateTime(2026, 7, 4),
      ),
      throwsArgumentError,
    );
  });

  test('records batch cleanup as a summary event', () {
    final event = BatchCleanupAppliedEvent(
      batchId: 'batch_1',
      action: BatchCleanupAction.letGo,
      affectedTaskIds: const ['task_1', 'task_2'],
      appliedAt: DateTime(2026, 7, 4, 21),
    );

    expect(event.eventName, 'batch_cleanup_applied');
    expect(event.payload['action'], 'let_go');
    expect(event.payload['affectedCount'], 2);
  });
}
