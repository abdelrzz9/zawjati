import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zawjati_mobile/core/widgets/app_input.dart';

void main() {
  group('ZawjatiTextField', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiTextField(
              label: 'Email',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('shows error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiTextField(
              label: 'Email',
              onChanged: (_) {},
              error: 'Invalid email',
            ),
          ),
        ),
      );

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('calls onChanged with text', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiTextField(
              label: 'Name',
              onChanged: (v) => result = v,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'John');
      expect(result, 'John');
    });

    testWidgets('shows prefix icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiTextField(
              label: 'Search',
              onChanged: (_) {},
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('toggles obscure text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiTextField(
              label: 'Password',
              onChanged: (_) {},
              obscure: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });
  });
}
