import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprite_runtime/sprite_runtime.dart';

void main() {
  test('maps every stage to a distinct packaged asset', () {
    expect(
      MonsterSpriteStage.values.map((stage) => stage.assetPath).toSet(),
      hasLength(MonsterSpriteStage.values.length),
    );
    expect(MonsterSpriteStage.egg.assetPath, endsWith('/egg.png'));
    expect(MonsterSpriteStage.child.assetPath, endsWith('/child.png'));
    expect(MonsterSpriteStage.teen.assetPath, endsWith('/teen.png'));
    expect(MonsterSpriteStage.adult.assetPath, endsWith('/adult.png'));
  });

  testWidgets('renders a crisp stage sprite with descriptive semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MonsterSprite(
            stage: MonsterSpriteStage.teen,
            stageLabel: 'Teen',
            moodLabel: 'Energetic',
            actionLabel: 'Waiting for a task',
          ),
        ),
      ),
    );

    expect(find.text('Energetic · Waiting for a task'), findsOneWidget);
    expect(find.byKey(const ValueKey('monster-sprite-teen')), findsOneWidget);

    final image = tester.widget<Image>(
      find.byKey(const ValueKey('monster-sprite-image-teen')),
    );
    expect(image.filterQuality, FilterQuality.none);
    expect(image.isAntiAlias, isFalse);
    expect(image.fit, BoxFit.contain);

    final semantics = tester.getSemantics(
      find.byKey(const ValueKey('monster-sprite-teen')),
    );
    expect(semantics.label, contains('teen monster'));
    expect(semantics.label, isNot(contains('placeholder')));
  });
}
