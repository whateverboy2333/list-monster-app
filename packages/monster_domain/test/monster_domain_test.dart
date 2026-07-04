import 'package:monster_domain/monster_domain.dart';
import 'package:test/test.dart';

void main() {
  test('keeps the expected monster mood labels', () {
    expect(MonsterMood.expecting.label, '期待');
    expect(MonsterMood.sleeping.label, '睡觉');
  });

  test('identifies positive XP grants', () {
    expect(const XpGrant(sourceEventId: 'evt_1', amount: 10).isPositive, isTrue);
    expect(const XpGrant(sourceEventId: 'evt_2', amount: -10).isPositive, isFalse);
  });
}

