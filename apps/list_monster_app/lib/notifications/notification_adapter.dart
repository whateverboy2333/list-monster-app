import 'dart:async';

import 'package:task_domain/task_domain.dart';

enum NotificationPermissionStatus { granted, denied }

enum NotificationScheduleOutcome { scheduled, permissionDenied }

abstract class NotificationAdapter {
  Future<NotificationPermissionStatus> permissionStatus();

  Future<NotificationScheduleResult> schedule(NotificationSchedulePlan plan);

  Future<bool> cancel(String notificationId);

  Stream<NotificationClickIntent> get clickIntents;
}

class NotificationSchedulePlan {
  factory NotificationSchedulePlan.fromReminderIntent(ReminderIntent intent) {
    final payload = Map<String, Object?>.unmodifiable(intent.payload);
    return NotificationSchedulePlan._(
      notificationId: payload['notificationId']! as String,
      reminderId: intent.reminderId,
      taskId: intent.taskId,
      plannedAt: intent.plannedAt,
      deliverAt: intent.deliverAt,
      title: intent.notificationTitle,
      privacyMode: intent.privacyMode,
      payload: payload,
    );
  }

  factory NotificationSchedulePlan.tonight({
    required String reminderId,
    required String taskId,
    required DateTime localNow,
    DoNotDisturbWindow? dndWindow,
    TaskPriority priority = TaskPriority.none,
    bool respectDnd = true,
    String? taskTitle,
    NotificationPrivacyMode privacyMode = NotificationPrivacyMode.private,
  }) {
    return NotificationSchedulePlan.fromReminderIntent(
      ReminderIntent.tonight(
        reminderId: reminderId,
        taskId: taskId,
        localNow: localNow,
        dndWindow: dndWindow,
        priority: priority,
        respectDnd: respectDnd,
        taskTitle: taskTitle,
        privacyMode: privacyMode,
      ),
    );
  }

  factory NotificationSchedulePlan.localTime({
    required String reminderId,
    required String taskId,
    required DateTime localDate,
    required String timeOfDay,
    DoNotDisturbWindow? dndWindow,
    TaskPriority priority = TaskPriority.none,
    bool respectDnd = true,
    String? taskTitle,
    NotificationPrivacyMode privacyMode = NotificationPrivacyMode.private,
  }) {
    return NotificationSchedulePlan.fromReminderIntent(
      ReminderIntent.localTime(
        reminderId: reminderId,
        taskId: taskId,
        localDate: localDate,
        timeOfDay: timeOfDay,
        dndWindow: dndWindow,
        priority: priority,
        respectDnd: respectDnd,
        taskTitle: taskTitle,
        privacyMode: privacyMode,
      ),
    );
  }

  const NotificationSchedulePlan._({
    required this.notificationId,
    required this.reminderId,
    required this.taskId,
    required this.plannedAt,
    required this.deliverAt,
    required this.title,
    required this.privacyMode,
    required this.payload,
  });

  final String notificationId;
  final String reminderId;
  final String taskId;
  final DateTime plannedAt;
  final DateTime deliverAt;
  final String title;
  final NotificationPrivacyMode privacyMode;
  final Map<String, Object?> payload;

  bool get isDelayed => deliverAt.isAfter(plannedAt);
}

class ScheduledNotification {
  const ScheduledNotification({required this.plan, required this.scheduledAt});

  final NotificationSchedulePlan plan;
  final DateTime scheduledAt;
}

class NotificationScheduleResult {
  const NotificationScheduleResult._({
    required this.outcome,
    required this.plan,
    this.notification,
  });

  factory NotificationScheduleResult.scheduled({
    required NotificationSchedulePlan plan,
    required ScheduledNotification notification,
  }) {
    return NotificationScheduleResult._(
      outcome: NotificationScheduleOutcome.scheduled,
      plan: plan,
      notification: notification,
    );
  }

  factory NotificationScheduleResult.permissionDenied(
    NotificationSchedulePlan plan,
  ) {
    return NotificationScheduleResult._(
      outcome: NotificationScheduleOutcome.permissionDenied,
      plan: plan,
    );
  }

  final NotificationScheduleOutcome outcome;
  final NotificationSchedulePlan plan;
  final ScheduledNotification? notification;

  bool get isScheduled => outcome == NotificationScheduleOutcome.scheduled;
}

class NotificationClickIntent {
  const NotificationClickIntent({
    required this.notificationId,
    required this.reminderId,
    required this.taskId,
    required this.payload,
  });

  factory NotificationClickIntent.fromPayload(Map<String, Object?> payload) {
    return NotificationClickIntent(
      notificationId: payload['notificationId']! as String,
      reminderId: payload['reminderId']! as String,
      taskId: payload['taskId']! as String,
      payload: Map<String, Object?>.unmodifiable(payload),
    );
  }

  final String notificationId;
  final String reminderId;
  final String taskId;
  final Map<String, Object?> payload;
}

class InMemoryNotificationAdapter implements NotificationAdapter {
  InMemoryNotificationAdapter({
    NotificationPermissionStatus? permissionStatus,
    DateTime Function()? now,
  }) : _permissionStatus =
           permissionStatus ?? NotificationPermissionStatus.granted,
       _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final Map<String, ScheduledNotification> _scheduled = {};
  final StreamController<NotificationClickIntent> _clicks =
      StreamController<NotificationClickIntent>.broadcast();

  NotificationPermissionStatus _permissionStatus;

  @override
  Stream<NotificationClickIntent> get clickIntents => _clicks.stream;

  List<ScheduledNotification> get scheduledNotifications {
    return List.unmodifiable(_scheduled.values);
  }

  set permission(NotificationPermissionStatus value) {
    _permissionStatus = value;
  }

  @override
  Future<NotificationPermissionStatus> permissionStatus() async {
    return _permissionStatus;
  }

  @override
  Future<NotificationScheduleResult> schedule(
    NotificationSchedulePlan plan,
  ) async {
    if (_permissionStatus == NotificationPermissionStatus.denied) {
      return NotificationScheduleResult.permissionDenied(plan);
    }

    final notification = ScheduledNotification(plan: plan, scheduledAt: _now());
    _scheduled[plan.notificationId] = notification;
    return NotificationScheduleResult.scheduled(
      plan: plan,
      notification: notification,
    );
  }

  @override
  Future<bool> cancel(String notificationId) async {
    if (_scheduled.remove(notificationId) != null) {
      return true;
    }

    String? matchedNotificationId;
    for (final entry in _scheduled.entries) {
      if (entry.value.plan.reminderId == notificationId) {
        matchedNotificationId = entry.key;
        break;
      }
    }

    if (matchedNotificationId == null) {
      return false;
    }

    _scheduled.remove(matchedNotificationId);
    return true;
  }

  void simulateClick(String notificationId) {
    final notification = _scheduled[notificationId];
    if (notification == null) {
      return;
    }

    _clicks.add(NotificationClickIntent.fromPayload(notification.plan.payload));
  }

  Future<void> dispose() async {
    await _clicks.close();
  }
}
