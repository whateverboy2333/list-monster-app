import 'package:core/core.dart';

void main() {
  final event = DomainEvent(
    eventId: 'evt_1',
    eventName: 'task_created',
    userId: 'user_1',
    occurredAt: DateTime.now(),
    source: DomainEventSource.androidApp,
    payload: const {'taskId': 'task_1'},
  );

  print(event.eventName);
}
