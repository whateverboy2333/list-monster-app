import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_store/local_store.dart';

const androidWidgetBridgeChannelName = 'list_monster/companion_snapshot_widget';
const androidWidgetSnapshotPreferencesName = 'list_monster_companion_snapshot';
const androidWidgetSnapshotPayloadKey = 'payload_json';
const androidWidgetRefreshAction =
    'com.listmonster.list_monster_app.widget.REFRESH_COMPANION_WIDGET';
const _platformCallTimeout = Duration(milliseconds: 500);

enum AndroidWidgetDestination { today, monster }

enum AndroidWidgetSnapshotState { empty, fresh, expired, unreadable }

typedef AndroidWidgetLaunchIntentHandler =
    FutureOr<void> Function(AndroidWidgetLaunchIntent intent);

abstract interface class CompanionSnapshotWidgetBridge {
  Future<void> persistSnapshot(LocalCompanionSnapshot snapshot);

  Future<AndroidWidgetLaunchIntent?> consumeInitialWidgetLaunchIntent();

  void setWidgetLaunchIntentHandler(AndroidWidgetLaunchIntentHandler? handler);
}

class AndroidWidgetLaunchIntent {
  const AndroidWidgetLaunchIntent({
    required this.destination,
    required this.refreshCompanionSnapshot,
    this.source,
    this.widgetId,
  });

  factory AndroidWidgetLaunchIntent.fromMap(Map<Object?, Object?> values) {
    final destination = switch (values['destination']) {
      'monster' => AndroidWidgetDestination.monster,
      _ => AndroidWidgetDestination.today,
    };
    return AndroidWidgetLaunchIntent(
      destination: destination,
      refreshCompanionSnapshot:
          values['refreshCompanionSnapshot'] == true ||
          values['refresh'] == 'companion_snapshot',
      source: values['source'] as String?,
      widgetId: _intFrom(values['widgetId']),
    );
  }

  static AndroidWidgetLaunchIntent? tryParse(Object? value) {
    if (value is Map<Object?, Object?>) {
      return AndroidWidgetLaunchIntent.fromMap(value);
    }
    if (value is Map) {
      return AndroidWidgetLaunchIntent.fromMap(
        value.map((key, mapValue) => MapEntry(key, mapValue)),
      );
    }
    return null;
  }

  final AndroidWidgetDestination destination;
  final bool refreshCompanionSnapshot;
  final String? source;
  final int? widgetId;

  bool get opensToday => destination == AndroidWidgetDestination.today;
  bool get opensMonster => destination == AndroidWidgetDestination.monster;

  static int? _intFrom(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

class AndroidWidgetSnapshotReadResult {
  const AndroidWidgetSnapshotReadResult({
    required this.state,
    required this.payload,
  });

  factory AndroidWidgetSnapshotReadResult.fromPersistedJson(
    String? persistedJson, {
    required DateTime now,
  }) {
    if (persistedJson == null || persistedJson.trim().isEmpty) {
      return const AndroidWidgetSnapshotReadResult(
        state: AndroidWidgetSnapshotState.empty,
        payload: null,
      );
    }

    try {
      final decoded = jsonDecode(persistedJson);
      if (decoded is! Map<String, Object?>) {
        return const AndroidWidgetSnapshotReadResult(
          state: AndroidWidgetSnapshotState.unreadable,
          payload: null,
        );
      }
      final payloadValue = decoded['payload'];
      final payload = payloadValue is Map<String, Object?>
          ? payloadValue
          : decoded;
      final expired = _isExpired(decoded, payload, now.toUtc());
      return AndroidWidgetSnapshotReadResult(
        state: expired
            ? AndroidWidgetSnapshotState.expired
            : AndroidWidgetSnapshotState.fresh,
        payload: Map.unmodifiable(payload),
      );
    } on FormatException {
      return const AndroidWidgetSnapshotReadResult(
        state: AndroidWidgetSnapshotState.unreadable,
        payload: null,
      );
    } on TypeError {
      return const AndroidWidgetSnapshotReadResult(
        state: AndroidWidgetSnapshotState.unreadable,
        payload: null,
      );
    }
  }

  final AndroidWidgetSnapshotState state;
  final Map<String, Object?>? payload;

  static bool _isExpired(
    Map<String, Object?> envelope,
    Map<String, Object?> payload,
    DateTime now,
  ) {
    if (payload['isStale'] == true) {
      return true;
    }

    final expiresAt = _dateTimeFrom(envelope['expiresAt']);
    if (expiresAt != null) {
      return !now.isBefore(expiresAt.toUtc());
    }

    final generatedAt = _dateTimeFrom(payload['generatedAt']);
    final staleAfterSeconds = payload['staleAfterSeconds'];
    if (generatedAt == null || staleAfterSeconds is! int) {
      return true;
    }
    return !now.isBefore(
      generatedAt.toUtc().add(Duration(seconds: staleAfterSeconds)),
    );
  }

  static DateTime? _dateTimeFrom(Object? value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

class MethodChannelCompanionSnapshotWidgetBridge
    implements CompanionSnapshotWidgetBridge {
  MethodChannelCompanionSnapshotWidgetBridge()
    : this.withChannel(const MethodChannel(androidWidgetBridgeChannelName));

  @visibleForTesting
  MethodChannelCompanionSnapshotWidgetBridge.withChannel(this._channel);

  final MethodChannel _channel;
  AndroidWidgetLaunchIntentHandler? _handler;

  @override
  Future<void> persistSnapshot(LocalCompanionSnapshot snapshot) async {
    final persistedJson = encodeAndroidWidgetSnapshot(snapshot);
    try {
      await _channel
          .invokeMethod<void>('persistCompanionSnapshot', {
            'preferencesName': androidWidgetSnapshotPreferencesName,
            'payloadKey': androidWidgetSnapshotPayloadKey,
            'payloadJson': persistedJson,
            'refreshAction': androidWidgetRefreshAction,
          })
          .timeout(_platformCallTimeout);
    } on MissingPluginException {
      // Non-Android test and desktop targets do not host the widget bridge.
    } on FlutterError {
      // Pure Dart tests may exercise the refresh service without a Flutter binding.
    } on TimeoutException {
      // Widget persistence must not block the in-app task or pet flow.
    }
  }

  @override
  Future<AndroidWidgetLaunchIntent?> consumeInitialWidgetLaunchIntent() async {
    try {
      final result = await _channel.invokeMethod<Object?>(
        'consumeInitialWidgetLaunchIntent',
      );
      return AndroidWidgetLaunchIntent.tryParse(result);
    } on MissingPluginException {
      return null;
    } on FlutterError {
      return null;
    }
  }

  @override
  void setWidgetLaunchIntentHandler(AndroidWidgetLaunchIntentHandler? handler) {
    _handler = handler;
    if (handler == null) {
      _channel.setMethodCallHandler(null);
      return;
    }

    _channel.setMethodCallHandler((call) async {
      if (call.method != 'widgetLaunchIntent') {
        return null;
      }
      final intent = AndroidWidgetLaunchIntent.tryParse(call.arguments);
      if (intent != null) {
        await _handler?.call(intent);
      }
      return null;
    });
  }
}

String encodeAndroidWidgetSnapshot(LocalCompanionSnapshot snapshot) {
  return jsonEncode({
    'snapshotId': snapshot.snapshotId,
    'generatedAt': _formatUtcMillis(snapshot.generatedAt),
    'expiresAt': _formatUtcMillis(snapshot.expiresAt),
    'payload': snapshot.payload,
  });
}

String _formatUtcMillis(DateTime value) {
  final utc = value.toUtc();
  String two(int number) => number.toString().padLeft(2, '0');
  String three(int number) => number.toString().padLeft(3, '0');
  return '${utc.year.toString().padLeft(4, '0')}-'
      '${two(utc.month)}-${two(utc.day)}T'
      '${two(utc.hour)}:${two(utc.minute)}:${two(utc.second)}.'
      '${three(utc.millisecond)}Z';
}
