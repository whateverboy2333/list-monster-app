import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  testWidgets('all stage assets keep transparent safety margins', (
    tester,
  ) async {
    await tester.runAsync(() async {
      for (final stage in MonsterSpriteStage.values) {
        final data = await rootBundle.load(
          'packages/sprite_runtime/${stage.assetPath}',
        );
        final codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        final frame = await codec.getNextFrame();
        final image = frame.image;

        try {
          final rgba = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          expect(rgba, isNotNull, reason: '${stage.name} must decode as RGBA');

          int alphaAt(int x, int y) =>
              rgba!.getUint8(((y * image.width + x) * 4) + 3);

          final leftOpaque = <int>[
            for (var y = 0; y < image.height; y++) alphaAt(0, y),
          ].where((alpha) => alpha != 0).length;
          final rightOpaque = <int>[
            for (var y = 0; y < image.height; y++) alphaAt(image.width - 1, y),
          ].where((alpha) => alpha != 0).length;
          final topOpaque = <int>[
            for (var x = 0; x < image.width; x++) alphaAt(x, 0),
          ].where((alpha) => alpha != 0).length;
          final bottomOpaque = <int>[
            for (var x = 0; x < image.width; x++) alphaAt(x, image.height - 1),
          ].where((alpha) => alpha != 0).length;

          expect(leftOpaque, 0, reason: '${stage.name} touches the left edge');
          expect(
            rightOpaque,
            0,
            reason: '${stage.name} touches the right edge',
          );
          expect(topOpaque, 0, reason: '${stage.name} touches the top edge');
          expect(
            bottomOpaque,
            0,
            reason: '${stage.name} touches the bottom edge',
          );
        } finally {
          image.dispose();
          codec.dispose();
        }
      }
    });
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
