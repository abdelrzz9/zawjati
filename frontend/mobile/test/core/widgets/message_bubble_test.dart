import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zawjati_mobile/core/widgets/message_bubble.dart';

void main() {
  group('ZawjatiMessageBubble', () {
    testWidgets('renders user message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiMessageBubble(
              content: 'Hello from user',
              isUser: true,
              timestamp: DateTime.now(),
            ),
          ),
        ),
      );

      expect(find.text('Hello from user'), findsOneWidget);
    });

    testWidgets('renders assistant message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiMessageBubble(
              content: 'Hello from assistant',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          ),
        ),
      );

      expect(find.text('Hello from assistant'), findsOneWidget);
    });

    testWidgets('formats timestamp', (tester) async {
      final now = DateTime(2024, 1, 1, 12, 30);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiMessageBubble(
              content: 'Test',
              isUser: false,
              timestamp: now,
            ),
          ),
        ),
      );

      expect(find.textContaining('12:30'), findsOneWidget);
    });
  });
}
