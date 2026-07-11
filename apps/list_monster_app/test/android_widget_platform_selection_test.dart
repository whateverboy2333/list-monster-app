import 'package:flutter_test/flutter_test.dart';
import 'package:list_monster_app/companion_snapshot/android_widget_bridge.dart';

void main() {
  test('Web never enables the Android widget bridge', () {
    expect(isAndroidWidgetPlatform(isWeb: true, isAndroid: true), isFalse);
  });

  test('Windows does not enable the Android widget bridge', () {
    expect(isAndroidWidgetPlatform(isWeb: false, isAndroid: false), isFalse);
  });

  test('Android enables the Android widget bridge', () {
    expect(isAndroidWidgetPlatform(isWeb: false, isAndroid: true), isTrue);
  });
}
