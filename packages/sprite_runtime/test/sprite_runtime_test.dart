import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprite_runtime/sprite_runtime.dart';

void main() {
  testWidgets('renders the monster sprite placeholder', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MonsterSpritePlaceholder(
          moodLabel: '期待',
          actionLabel: '等待任务完成反馈',
        ),
      ),
    );

    expect(find.text('状态：期待'), findsOneWidget);
    expect(find.text('动作：等待任务完成反馈'), findsOneWidget);
  });
}

