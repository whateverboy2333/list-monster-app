library;

import 'package:flutter/material.dart';

class MonsterSpritePlaceholder extends StatelessWidget {
  const MonsterSpritePlaceholder({
    super.key,
    required this.moodLabel,
    required this.actionLabel,
  });

  final String moodLabel;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'monster sprite placeholder',
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.egg_alt_outlined, size: 48, color: scheme.primary),
              const SizedBox(height: 12),
              Text('状态：$moodLabel'),
              Text('动作：$actionLabel'),
            ],
          ),
        ),
      ),
    );
  }
}

