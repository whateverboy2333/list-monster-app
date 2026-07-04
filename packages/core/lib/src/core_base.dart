class DomainEvent {
  const DomainEvent({
    required this.eventId,
    required this.eventName,
    required this.userId,
    required this.occurredAt,
  });

  final String eventId;
  final String eventName;
  final String userId;
  final DateTime occurredAt;
}

