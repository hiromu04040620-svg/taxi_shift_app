import 'package:flutter/material.dart';

class AppColorSchemes {
  AppColorSchemes._();

  static final ColorScheme light =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF006B5F),
        secondary: const Color(0xFF8A5D00),
        tertiary: const Color(0xFF5B6097),
      ).copyWith(
        surface: const Color(0xFFF8FAF8),
        surfaceContainerLowest: const Color(0xFFFFFFFF),
        surfaceContainerLow: const Color(0xFFF1F4F1),
        surfaceContainer: const Color(0xFFEBEFEC),
        surfaceContainerHigh: const Color(0xFFE5EAE6),
        surfaceContainerHighest: const Color(0xFFDDE3DF),
      );

  static final ColorScheme dark =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF70D8C8),
        secondary: const Color(0xFFF2BE55),
        tertiary: const Color(0xFFC2C5FF),
        brightness: Brightness.dark,
      ).copyWith(
        surface: const Color(0xFF111513),
        surfaceContainerLowest: const Color(0xFF0C0F0E),
        surfaceContainerLow: const Color(0xFF181D1A),
        surfaceContainer: const Color(0xFF1D231F),
        surfaceContainerHigh: const Color(0xFF242B27),
        surfaceContainerHighest: const Color(0xFF2C342F),
      );
}
