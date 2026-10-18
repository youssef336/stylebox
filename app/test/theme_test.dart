import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/helper_functions/themes.dart';

void main() {
  group('StyleBox Atelier theme', () {
    test('light theme uses the Bordeaux / champagne palette', () {
      final theme = LightColorTheme();
      expect(theme.colorScheme.primary, KprimaryColor);
      expect(theme.colorScheme.secondary, KaccentColor);
      expect(theme.scaffoldBackgroundColor, KlightModeBgColor);
      expect(theme.textTheme.bodyMedium?.fontFamily, 'Cairo');
    });

    test('dark theme uses the espresso surfaces', () {
      final theme = DarkColorTheme();
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, KdarkModePrimary);
      expect(theme.scaffoldBackgroundColor, KdarkModeBgColor);
    });

    test('actions are pill shaped and fields borderless', () {
      final theme = LightColorTheme();
      final shape = theme.elevatedButtonTheme.style?.shape?.resolve({});
      expect(shape, isA<StadiumBorder>());
      expect(
        theme.inputDecorationTheme.enabledBorder?.borderSide,
        BorderSide.none,
      );
    });
  });
}
