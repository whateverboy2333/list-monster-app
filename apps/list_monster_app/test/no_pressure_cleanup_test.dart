import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:task_domain/task_domain.dart';

void main() {
  test('批量清理只放下未完成 active 任务并保护完成事实', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
    );

    controller.createTask('已完成任务');
    final completedTaskId = controller.tasks.single.id;
    controller.completeTask(completedTaskId);
    controller.createTask('待清理任务 A');
    controller.createTask('待清理任务 B');
    controller.createTask('已先行放下任务');
    final alreadyCancelledTaskId = controller.tasks.last.id;
    controller.cancelTask(alreadyCancelledTaskId, cancelReason: 'manual');

    final xpBeforeCleanup = controller.todayXp;
    controller.applyNoPressureCleanup();

    expect(controller.tasks.first.status, TaskStatus.completed);
    expect(
      controller.tasks
          .where((task) => task.id != completedTaskId)
          .where((task) => task.id != alreadyCancelledTaskId)
          .every((task) => task.status == TaskStatus.cancelled),
      isTrue,
    );
    expect(
      controller.tasks
          .firstWhere((task) => task.id == alreadyCancelledTaskId)
          .status,
      TaskStatus.cancelled,
    );
    expect(controller.todayXp, xpBeforeCleanup);
    expect(
      controller.xpLedger.where(
        (entry) => entry.sourceType == XpSourceType.taskCompleted,
      ),
      hasLength(1),
    );

    final batch = controller.events
        .whereType<BatchCleanupAppliedEvent>()
        .single;
    expect(batch.eventName, 'batch_cleanup_applied');
    expect(batch.action, BatchCleanupAction.letGo);
    expect(batch.affectedTaskIds, hasLength(2));
    expect(batch.affectedTaskIds, contains(controller.tasks[1].id));
    expect(batch.affectedTaskIds, contains(controller.tasks[2].id));
    expect(controller.events.whereType<TaskCancelledEvent>(), hasLength(3));
  });

  test('最近一批清理可整批撤销且重复撤销无副作用', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
    );

    controller.createTask('清理任务 A');
    controller.createTask('清理任务 B');
    controller.createTask('清理任务 C');
    final taskIds = controller.tasks.map((task) => task.id).toList();

    controller.applyNoPressureCleanup();
    expect(controller.cancelledTasks, hasLength(3));

    controller.undoLastBatchCleanup();

    expect(
      controller.tasks.every((task) => task.status == TaskStatus.active),
      isTrue,
    );
    final restoredEvents = controller.events
        .whereType<TaskRestoredEvent>()
        .toList();
    expect(restoredEvents, hasLength(3));
    expect(restoredEvents.map((event) => event.taskId), containsAll(taskIds));
    expect(restoredEvents.map((event) => event.eventId).toSet(), hasLength(3));
    expect(controller.todayXp, 0);
    expect(controller.xpLedger, isEmpty);

    controller.undoLastBatchCleanup();

    expect(
      controller.tasks.every((task) => task.status == TaskStatus.active),
      isTrue,
    );
    expect(controller.events.whereType<TaskRestoredEvent>(), hasLength(3));
    expect(controller.todayXp, 0);
    expect(controller.xpLedger, isEmpty);
  });
}
