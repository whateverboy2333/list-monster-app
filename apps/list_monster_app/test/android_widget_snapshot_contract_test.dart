import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/companion_snapshot/android_widget_bridge.dart';
import 'package:local_store/local_store.dart';

void main() {
  test('android widget snapshot contract reports empty state', () {
    final result = AndroidWidgetSnapshotReadResult.fromPersistedJson(
      null,
      now: DateTime.utc(2026, 7, 7, 2),
    );

    expect(result.state, AndroidWidgetSnapshotState.empty);
    expect(result.payload, isNull);
  });

  test('android widget snapshot contract reports fresh state', () {
    final generatedAt = DateTime.utc(2026, 7, 7, 2);
    final persistedJson = encodeAndroidWidgetSnapshot(
      LocalCompanionSnapshot(
        snapshotId: 'snapshot-fresh',
        generatedAt: generatedAt,
        expiresAt: generatedAt.add(const Duration(minutes: 5)),
        payload: const {
          'snapshotId': 'snapshot-fresh',
          'isStale': false,
          'generatedAt': '2026-07-07T02:00:00.000Z',
          'staleAfterSeconds': 300,
          'widgetFrameAssetId': 'assets/frame.png',
          'todayCompletedTasks': 2,
          'todayTotalTasks': 4,
          'todayRemainingTasks': 2,
          'currentStreakDays': 3,
          'hideTaskTitlesOutsideApp': true,
        },
      ),
    );

    final result = AndroidWidgetSnapshotReadResult.fromPersistedJson(
      persistedJson,
      now: generatedAt.add(const Duration(minutes: 1)),
    );

    expect(result.state, AndroidWidgetSnapshotState.fresh);
    expect(result.payload?['widgetFrameAssetId'], 'assets/frame.png');
    expect(result.payload?['todayCompletedTasks'], 2);
  });

  test('android widget snapshot contract reports expired state', () {
    final generatedAt = DateTime.utc(2026, 7, 7, 2);
    final persistedJson = encodeAndroidWidgetSnapshot(
      LocalCompanionSnapshot(
        snapshotId: 'snapshot-expired',
        generatedAt: generatedAt,
        expiresAt: generatedAt.add(const Duration(seconds: 1)),
        payload: const {
          'snapshotId': 'snapshot-expired',
          'isStale': false,
          'generatedAt': '2026-07-07T02:00:00.000Z',
          'staleAfterSeconds': 1,
          'lineText': 'safe external copy',
          'hideTaskTitlesOutsideApp': true,
        },
      ),
    );

    final result = AndroidWidgetSnapshotReadResult.fromPersistedJson(
      persistedJson,
      now: generatedAt.add(const Duration(seconds: 2)),
    );

    expect(result.state, AndroidWidgetSnapshotState.expired);
    expect(result.payload.toString(), isNot(contains('sensitive-title')));
  });

  test('android widget snapshot contract reports unreadable state', () {
    final result = AndroidWidgetSnapshotReadResult.fromPersistedJson(
      '{invalid',
      now: DateTime.utc(2026, 7, 7, 2),
    );

    expect(result.state, AndroidWidgetSnapshotState.unreadable);
    expect(result.payload, isNull);
  });
}
