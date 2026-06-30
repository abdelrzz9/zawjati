import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app smoke test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Zawjati'),
          ),
        ),
      ),
    );

    expect(find.text('Zawjati'), findsOneWidget);
  });
}
