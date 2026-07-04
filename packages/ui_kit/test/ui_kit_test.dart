import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  test('creates the light theme', () {
    final theme = ListMonsterTheme.light();

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary.toARGB32(), 0xFF2E7D68);
  });
}
