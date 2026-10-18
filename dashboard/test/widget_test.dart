import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stylebox_dashboard/core/utils/app_colors.dart';
import 'package:stylebox_dashboard/core/utils/app_theme.dart';

void main() {
  group('StyleBox dashboard theme', () {
    final theme = AppTheme.light();

    test('uses the Atelier palette', () {
      expect(theme.colorScheme.primary, AppColors.primaryColor);
      expect(theme.colorScheme.secondary, AppColors.secoundryColor);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.colorScheme.error, AppColors.errorColor);
    });

    test('uses bundled Cairo typography', () {
      expect(theme.textTheme.bodyMedium?.fontFamily, 'Cairo');
    });

    test('buttons are pill shaped and fields are borderless', () {
      final shape = theme.elevatedButtonTheme.style?.shape?.resolve({});
      expect(shape, isA<StadiumBorder>());
      final border = theme.inputDecorationTheme.enabledBorder;
      expect(border?.borderSide, BorderSide.none);
    });

    testWidgets('themed button renders in LTR and RTL', (tester) async {
      for (final direction in TextDirection.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Directionality(
              textDirection: direction,
              child: Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(find.text('Save'), findsOneWidget);
      }
    });
  });
}
