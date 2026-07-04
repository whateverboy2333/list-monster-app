enum DomainEventSource {
  androidApp,
  pcApp,
  desktopPet,
  widget,
  notification,
  system,
}

extension DomainEventSourceContractName on DomainEventSource {
  String get contractName {
    return switch (this) {
      DomainEventSource.androidApp => 'android_app',
      DomainEventSource.pcApp => 'pc_app',
      DomainEventSource.desktopPet => 'desktop_pet',
      DomainEventSource.widget => 'widget',
      DomainEventSource.notification => 'notification',
      DomainEventSource.system => 'system',
    };
  }
}

class DomainEvent {
  const DomainEvent({
    required this.eventId,
    required this.eventName,
    required this.userId,
    required this.occurredAt,
    this.source = DomainEventSource.androidApp,
    this.payload = const <String, Object?>{},
  });

  final String eventId;
  final String eventName;
  final String userId;
  final DateTime occurredAt;
  final DomainEventSource source;
  final Map<String, Object?> payload;

  String get sourceName => source.contractName;
}
