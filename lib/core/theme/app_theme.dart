import 'package:flutter/material.dart';

import 'color_schemes.dart';
import 'design_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return _buildTheme(AppColorSchemes.light);
  }

  static ThemeData dark() {
    return _buildTheme(AppColorSchemes.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      fontFamilyFallback: const ['Noto Sans CJK JP'],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: _cardTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: AppSpacing.md,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppTapTarget.min),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppTapTarget.min),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.primaryContainer,
      ),
    );
  }

  static const TextTheme _textTheme = TextTheme();

  static CardThemeData _cardTheme(ColorScheme colorScheme) => CardThemeData(
    elevation: 0,
    color: colorScheme.surfaceContainerLow,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    margin: EdgeInsets.zero,
  );

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) =>
      InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      );
}
