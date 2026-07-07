import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/companion_snapshot/android_widget_bridge.dart';
import 'package:local_store/local_store.dart';

void main() {
  test(
    'method channel bridge sends widget snapshot payload contract',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const channel = MethodChannel('test_android_widget_bridge');
      final binding = TestDefaultBinaryMessengerBinding.instance;
      final calls = <MethodCall>[];
      binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        calls.add(call);
        return null;
      });
      addTearDown(
        () => binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      final bridge = MethodChannelCompanionSnapshotWidgetBridge.withChannel(
        channel,
      );

      await bridge.persistSnapshot(
        LocalCompanionSnapshot(
          snapshotId: 'snapshot-1',
          generatedAt: DateTime.utc(2026, 7, 7, 2, 3, 4, 123, 456),
          expiresAt: DateTime.utc(2026, 7, 7, 2, 8, 4, 123, 456),
          payload: const {
            'snapshotId': 'snapshot-1',
            'widgetFrameAssetId': 'assets/frame.png',
            'todayCompletedTasks': 1,
            'todayTotalTasks': 3,
            'hideTaskTitlesOutsideApp': true,
          },
        ),
      );

      expect(calls, hasLength(1));
      expect(calls.single.method, 'persistCompanionSnapshot');
      final arguments = calls.single.arguments as Map<Object?, Object?>;
      expect(
        arguments['preferencesName'],
        androidWidgetSnapshotPreferencesName,
      );
      expect(arguments['payloadKey'], androidWidgetSnapshotPayloadKey);
      expect(arguments['refreshAction'], androidWidgetRefreshAction);

      final decoded =
          jsonDecode(arguments['payloadJson']! as String)
              as Map<String, Object?>;
      expect(decoded['snapshotId'], 'snapshot-1');
      expect(decoded['generatedAt'], '2026-07-07T02:03:04.123Z');
      expect(decoded['expiresAt'], '2026-07-07T02:08:04.123Z');
      expect(
        (decoded['payload']! as Map)['widgetFrameAssetId'],
        'assets/frame.png',
      );
    },
  );

  test('method channel bridge consumes initial widget launch intent', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('test_android_widget_launch');
    final binding = TestDefaultBinaryMessengerBinding.instance;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      expect(call.method, 'consumeInitialWidgetLaunchIntent');
      return <String, Object?>{
        'destination': 'monster',
        'refreshCompanionSnapshot': true,
        'source': 'android_widget',
        'widgetId': 7,
      };
    });
    addTearDown(
      () => binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    final bridge = MethodChannelCompanionSnapshotWidgetBridge.withChannel(
      channel,
    );

    final intent = await bridge.consumeInitialWidgetLaunchIntent();

    expect(intent?.opensMonster, isTrue);
    expect(intent?.refreshCompanionSnapshot, isTrue);
    expect(intent?.source, 'android_widget');
    expect(intent?.widgetId, 7);
  });
}
