enum MonsterMood {
  idle('空闲'),
  energetic('元气'),
  expecting('期待'),
  sleeping('睡觉'),
  missing('想念');

  const MonsterMood(this.label);

  final String label;
}

class XpGrant {
  const XpGrant({
    required this.sourceEventId,
    required this.amount,
  });

  final String sourceEventId;
  final int amount;

  bool get isPositive => amount > 0;
}

