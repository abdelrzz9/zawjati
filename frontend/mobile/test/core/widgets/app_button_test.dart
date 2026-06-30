import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zawjati_mobile/core/widgets/app_button.dart';

void main() {
  group('ZawjatiButton', () {
    testWidgets('renders with text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiButton(
              label: 'Click Me',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiButton(
              label: 'Click Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Click Me'));
      expect(pressed, true);
    });

    testWidgets('shows loading state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiButton(
              label: 'Loading',
              onPressed: () {},
              loading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('disables when loading', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiButton(
              label: 'Disabled',
              onPressed: () => pressed = true,
              loading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ZawjatiButton));
      expect(pressed, false);
    });

    testWidgets('renders with custom variant', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZawjatiButton(
              label: 'Outline',
              onPressed: () {},
              variant: ZawjatiButtonVariant.outlined,
            ),
          ),
        ),
      );

      expect(find.text('Outline'), findsOneWidget);
    });
  });
}
