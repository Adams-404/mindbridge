import 'package:flutter/material.dart';

class MindBridgeTheme {
  static const milk = Color(0xFFF4F0E7);
  static const paper = Color(0xFFFBF9F3);
  static const ink = Color(0xFF202B26);
  static const forest = Color(0xFF29483D);
  static const forest2 = Color(0xFF385B4E);
  static const clay = Color(0xFFB86D50);
  static const muted = Color(0xFF74766D);
  static const line = Color(0xFFD9D4C8);
  static const sage = Color(0xFFE8EDE5);
  static const sageBorder = Color(0xFFC8D3C5);
  static const blush = Color(0xFFF0E3D9);
  static const blushBorder = Color(0xFFE0C9BA);

  // Neo-Brutalist design tokens
  static const double borderWidth = 1.8;
  static const double borderRadius = 12.0;

  static final neoBorder = Border.all(color: ink, width: borderWidth);
  static final subtleBorder = Border.all(color: line, width: 1.2);

  static const neoShadow = [
    BoxShadow(color: ink, offset: Offset(3.5, 3.5), blurRadius: 0),
  ];

  static const neoShadowSmall = [
    BoxShadow(color: ink, offset: Offset(2, 2), blurRadius: 0),
  ];

  static const neoShadowLarge = [
    BoxShadow(color: ink, offset: Offset(5, 5), blurRadius: 0),
  ];

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: forest,
      brightness: Brightness.light,
      surface: paper,
      primary: forest,
      secondary: clay,
      onSurface: ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: milk,
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: milk,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.8),
      ),
      cardTheme: CardThemeData(
        color: paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: ink, width: borderWidth),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: paper,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius - 2),
            side: const BorderSide(color: ink, width: borderWidth),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: forest,
          backgroundColor: paper,
          elevation: 0,
          side: const BorderSide(color: ink, width: borderWidth),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius - 2),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 32,
          height: 1.1,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          height: 1.6,
          color: muted,
        ),
      ),
    );
  }
}
