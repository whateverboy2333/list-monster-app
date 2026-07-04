import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  test('creates a domain event envelope', () {
    final occurredAt = DateTime.utc(2026, 7, 4);
    final event = DomainEvent(
      eventId: 'evt_1',
      eventName: 'task_completed',
      userId: 'user_1',
      occurredAt: occurredAt,
      source: DomainEventSource.androidApp,
      payload: const {'taskId': 'task_1'},
    );

    expect(event.eventName, 'task_completed');
    expect(event.occurredAt, occurredAt);
    expect(event.sourceName, 'android_app');
    expect(event.payload['taskId'], 'task_1');
  });
}
