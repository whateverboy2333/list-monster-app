library;

import 'package:flutter/material.dart';

/// Visual stages supported by the checklist monster sprite set.
enum MonsterSpriteStage { egg, child, teen, adult }

extension MonsterSpriteStageAsset on MonsterSpriteStage {
  String get assetPath => 'assets/monsters/$name.png';

  String get semanticName => switch (this) {
    MonsterSpriteStage.egg => 'monster egg',
    MonsterSpriteStage.child => 'child monster',
    MonsterSpriteStage.teen => 'teen monster',
    MonsterSpriteStage.adult => 'adult monster',
  };
}

class MonsterSprite extends StatelessWidget {
  const MonsterSprite({
    super.key,
    required this.stage,
    required this.stageLabel,
    required this.moodLabel,
    required this.actionLabel,
    this.height = 220,
  });

  final MonsterSpriteStage stage;
  final String stageLabel;
  final String moodLabel;
  final String actionLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      key: ValueKey('monster-sprite-${stage.name}'),
      container: true,
      image: true,
      label:
          '${stage.semanticName}: $stageLabel. Mood: $moodLabel. $actionLabel.',
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.04),
            scheme.surface,
          ),
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              bottom: 48,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: ExcludeSemantics(
                  child: Image.asset(
                    stage.assetPath,
                    key: ValueKey('monster-sprite-image-${stage.name}'),
                    package: 'sprite_runtime',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    filterQuality: FilterQuality.none,
                    isAntiAlias: false,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                color: scheme.surfaceContainerHigh.withValues(alpha: 0.94),
                child: Text(
                  '$moodLabel · $actionLabel',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
