import 'package:flutter/material.dart';

class AppColorSchemes {
  AppColorSchemes._();

  static final ColorScheme light = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1E3A8A),
    secondary: const Color(0xFFF59E0B),
  );

  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1E3A8A),
    secondary: const Color(0xFFF59E0B),
    brightness: Brightness.dark,
  );
}
