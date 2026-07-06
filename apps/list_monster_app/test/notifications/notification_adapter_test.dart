import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/notifications/notification_adapter.dart';
import 'package:task_domain/task_domain.dart';

void main() {
  group('notification adapter port', () {
    test('reports denied permission and does not schedule', () async {
      final adapter = InMemoryNotificationAdapter(
        permissionStatus: NotificationPermissionStatus.denied,
      );
      addTearDown(adapter.dispose);

      final plan = NotificationSchedulePlan.localTime(
        reminderId: 'rem_denied',
        taskId: 'task_denied',
        localDate: DateTime(2026, 7, 4),
        timeOfDay: '21:30',
      );

      expect(
        await adapter.permissionStatus(),
        NotificationPermissionStatus.denied,
      );

      final result = await adapter.schedule(plan);

      expect(result.outcome, NotificationScheduleOutcome.permissionDenied);
      expect(result.isScheduled, isFalse);
      expect(adapter.scheduledNotifications, isEmpty);
    });

    test('schedules a reminder plan from task domain intent', () async {
      final adapter = InMemoryNotificationAdapter(
        now: () => DateTime(2026, 7, 4, 9),
      );
      addTearDown(adapter.dispose);

      final plan = NotificationSchedulePlan.localTime(
        reminderId: 'rem_1',
        taskId: 'task_1',
        localDate: DateTime(2026, 7, 4),
        timeOfDay: '21:30',
      );

      final result = await adapter.schedule(plan);

      expect(result.isScheduled, isTrue);
      expect(adapter.scheduledNotifications, hasLength(1));
      expect(
        adapter.scheduledNotifications.single.plan.notificationId,
        'local_rem_1',
      );
      expect(
        adapter.scheduledNotifications.single.plan.deliverAt,
        DateTime(2026, 7, 4, 21, 30),
      );
      expect(
        adapter.scheduledNotifications.single.scheduledAt,
        DateTime(2026, 7, 4, 9),
      );
    });

    test('cancels a scheduled notification', () async {
      final adapter = InMemoryNotificationAdapter();
      addTearDown(adapter.dispose);

      final plan = NotificationSchedulePlan.localTime(
        reminderId: 'rem_cancel',
        taskId: 'task_cancel',
        localDate: DateTime(2026, 7, 4),
        timeOfDay: '21:30',
      );
      await adapter.schedule(plan);

      expect(await adapter.cancel(plan.notificationId), isTrue);
      expect(adapter.scheduledNotifications, isEmpty);
      expect(await adapter.cancel(plan.notificationId), isFalse);
    });

    test('delays by dnd without bypassing by default', () {
      final plan = NotificationSchedulePlan.localTime(
        reminderId: 'rem_dnd',
        taskId: 'task_dnd',
        localDate: DateTime(2026, 7, 4),
        timeOfDay: '22:30',
        dndWindow: DoNotDisturbWindow(startTime: '22:00', endTime: '07:00'),
        priority: TaskPriority.high,
      );

      expect(plan.plannedAt, DateTime(2026, 7, 4, 22, 30));
      expect(plan.deliverAt, DateTime(2026, 7, 5, 7));
      expect(plan.isDelayed, isTrue);
      expect(plan.payload['respectDnd'], isTrue);
      expect(plan.payload['priority'], 'high');
    });

    test('uses tonight fallback and privacy-safe title by default', () {
      final plan = NotificationSchedulePlan.tonight(
        reminderId: 'rem_tonight',
        taskId: 'task_tonight',
        localNow: DateTime(2026, 7, 4, 20, 30),
        dndWindow: DoNotDisturbWindow(startTime: '23:00', endTime: '07:00'),
        taskTitle: 'Pay the electricity bill',
      );

      expect(plan.plannedAt, DateTime(2026, 7, 4, 21, 30));
      expect(plan.deliverAt, DateTime(2026, 7, 4, 21, 30));
      expect(plan.title, 'Task reminder');
      expect(plan.privacyMode, NotificationPrivacyMode.private);
      expect(plan.payload['notificationTitle'], 'Task reminder');
      expect(plan.payload.containsValue('Pay the electricity bill'), isFalse);
    });

    test('emits click backflow intent from scheduled payload', () async {
      final adapter = InMemoryNotificationAdapter();
      addTearDown(adapter.dispose);

      final plan = NotificationSchedulePlan.localTime(
        reminderId: 'rem_click',
        taskId: 'task_click',
        localDate: DateTime(2026, 7, 4),
        timeOfDay: '21:30',
      );
      await adapter.schedule(plan);

      final intent = expectLater(
        adapter.clickIntents,
        emits(
          isA<NotificationClickIntent>()
              .having(
                (intent) => intent.notificationId,
                'notificationId',
                plan.notificationId,
              )
              .having((intent) => intent.reminderId, 'reminderId', 'rem_click')
              .having((intent) => intent.taskId, 'taskId', 'task_click'),
        ),
      );

      adapter.simulateClick(plan.notificationId);

      await intent;
    });
  });
}
