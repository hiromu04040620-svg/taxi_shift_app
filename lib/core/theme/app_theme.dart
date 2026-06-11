import 'package:flutter/material.dart';

import 'color_schemes.dart';
import 'design_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.light,
      textTheme: _textTheme,
      fontFamilyFallback: const ['Noto Sans CJK JP'],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: _cardTheme,
      inputDecorationTheme: _inputDecorationTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.dark,
      textTheme: _textTheme,
      fontFamilyFallback: const ['Noto Sans CJK JP'],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: _cardTheme,
      inputDecorationTheme: _inputDecorationTheme,
    );
  }

  static const TextTheme _textTheme = TextTheme();

  static final CardThemeData _cardTheme = CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    margin: const EdgeInsets.all(AppSpacing.sm),
  );

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      );
}
