import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/task_system_controller.dart';
import 'package:monster_domain/monster_domain.dart';
import 'package:sync_domain/sync_domain.dart';
import 'package:task_domain/task_domain.dart';

void main() {
  test('交接永久挂起时完成调用先更新本地反馈和成长状态且只奖励一次', () async {
    final pendingHandoff = Completer<void>();
    final handoffStarted = Completer<void>();
    var handoffCalls = 0;
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
      priorActiveDates: [
        DateTime(2026, 7, 1),
        DateTime(2026, 7, 2),
        DateTime(2026, 7, 3),
      ],
      syncHandoff: (operation) {
        handoffCalls += 1;
        if (!handoffStarted.isCompleted) {
          handoffStarted.complete();
        }
        return pendingHandoff.future;
      },
    );

    controller.createTask('挂起交接仍即时完成');
    final taskId = controller.tasks.single.id;
    controller.completeTask(taskId);
    controller.completeTask(taskId);

    final completedEvent = controller.events
        .whereType<TaskCompletedEvent>()
        .single;
    expect(controller.tasks.single.status, TaskStatus.completed);
    expect(controller.monster.currentAction, 'eat');
    expect(controller.todayXp, 30);
    expect(controller.streak.currentStreakDays, 4);
    expect(controller.streak.bestStreakDays, 4);
    expect(controller.activeDayCount, 4);
    expect(controller.latestCumulativeReward, isNotNull);
    expect(
      controller.xpLedger.where(
        (entry) =>
            entry.sourceType == XpSourceType.taskCompleted &&
            entry.sourceEventId == completedEvent.eventId,
      ),
      hasLength(1),
    );
    expect(
      controller.xpLedger.where(
        (entry) => entry.sourceType == XpSourceType.cumulativeActiveReward,
      ),
      hasLength(1),
    );
    expect(controller.events.whereType<StreakUpdatedEvent>(), hasLength(1));
    expect(
      controller.events.whereType<CumulativeActiveRewardEvent>(),
      hasLength(1),
    );
    expect(controller.syncHandoffOperations, hasLength(1));

    await handoffStarted.future.timeout(const Duration(seconds: 1));
    expect(handoffCalls, 1);
    expect(pendingHandoff.isCompleted, isFalse);
    expect(controller.tasks.single.status, TaskStatus.completed);
    expect(controller.todayXp, 30);
    expect(controller.streak.currentStreakDays, 4);
    expect(controller.latestCumulativeReward, isNotNull);
  });

  test('未注入交接回调时完成撤销和恢复保留本地交接记录', () {
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
    );

    controller.createTask('仅本地交接任务');
    final taskId = controller.tasks.single.id;

    expect(() => controller.completeTask(taskId), returnsNormally);
    expect(controller.tasks.single.status, TaskStatus.completed);
    expect(() => controller.undoCompletion(taskId), returnsNormally);
    expect(controller.tasks.single.status, TaskStatus.active);
    controller.cancelTask(taskId);
    expect(() => controller.restoreTask(taskId), returnsNormally);
    expect(controller.tasks.single.status, TaskStatus.active);

    expect(controller.syncHandoffOperations, hasLength(3));
    expect(
      controller.syncHandoffOperations.map(
        (operation) => operation.operationType,
      ),
      [
        SyncOperationType.taskComplete,
        SyncOperationType.taskUndoCompletion,
        SyncOperationType.taskRestore,
      ],
    );
    for (final operation in controller.syncHandoffOperations) {
      expect(operation.entityId, taskId);
      expect(operation.operationId, operation.eventId);
      expect(operation.sourceEventId, operation.eventId);
    }
  });

  test('任务完成撤销恢复向同步底座交接稳定身份和操作类型', () async {
    final operations = <SyncQueueDraft>[];
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
      syncHandoff: (operation) {
        operations.add(operation);
        return Future<void>.value();
      },
    );

    controller.createTask('同步交接任务');
    final taskId = controller.tasks.single.id;
    controller.completeTask(taskId);
    controller.undoCompletion(taskId);
    controller.cancelTask(taskId);
    controller.restoreTask(taskId);
    await Future<void>.delayed(Duration.zero);

    expect(operations.map((operation) => operation.operationType), [
      SyncOperationType.taskComplete,
      SyncOperationType.taskUndoCompletion,
      SyncOperationType.taskRestore,
    ]);
    expect(operations, hasLength(3));
    expect(
      operations.map((operation) => operation.eventId).toSet(),
      hasLength(3),
    );
    for (final operation in operations) {
      expect(operation.entityType, 'task');
      expect(operation.entityId, taskId);
      expect(operation.sourceEventId, operation.eventId);
      expect(operation.operationId, operation.eventId);
      expect(operation.payload['eventName'], isNotNull);
    }
    expect(controller.syncHandoffOperations, hasLength(3));
  });

  test('交接失败不阻塞本地反馈且不会重复发成长奖励', () async {
    final failedOperations = <SyncQueueDraft>[];
    final controller = TaskSystemController(
      today: DateTime(2026, 7, 4),
      now: DateTime(2026, 7, 4, 9),
      syncHandoff: (operation) async {
        failedOperations.add(operation);
        throw StateError('sync unavailable');
      },
    );

    controller.createTask('离线完成任务');
    final taskId = controller.tasks.single.id;
    controller.completeTask(taskId);

    expect(controller.tasks.single.status, TaskStatus.completed);
    expect(controller.todayXp, 10);
    expect(
      controller.xpLedger.where(
        (entry) => entry.sourceType == XpSourceType.taskCompleted,
      ),
      hasLength(1),
    );
    expect(controller.syncHandoffOperations, hasLength(1));

    await Future<void>.delayed(Duration.zero);
    controller.undoCompletion(taskId);
    await Future<void>.delayed(Duration.zero);

    expect(controller.tasks.single.status, TaskStatus.active);
    expect(controller.todayXp, 0);
    expect(
      controller.xpLedger.where(
        (entry) => entry.sourceType == XpSourceType.xpReverted,
      ),
      hasLength(1),
    );
    expect(failedOperations, hasLength(2));
    expect(failedOperations.map((operation) => operation.operationType), [
      SyncOperationType.taskComplete,
      SyncOperationType.taskUndoCompletion,
    ]);
  });
}
