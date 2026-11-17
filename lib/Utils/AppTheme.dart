import 'package:flutter/material.dart';

// Palette shared with the EduSnap book/camera icon.
ThemeData appTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF26628C),
    primary: const Color(0xFF26628C),
    secondary: const Color(0xFF356783),
    tertiary: const Color(0xFFBFE4FA),
    surface: const Color(0xFFF7FCFF),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFBFE4FA),
      foregroundColor: const Color(0xFF163E58),
    ),
    cardTheme: CardThemeData(color: scheme.surfaceContainerLow),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
