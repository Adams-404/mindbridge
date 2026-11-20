import 'package:material_ui/material_ui.dart';

class MindBridgeTheme {
  static const milk = Color(0xFFF4F0E7);
  static const paper = Color(0xFFFBF9F3);
  static const ink = Color(0xFF202B26);
  static const forest = Color(0xFF29483D);
  static const clay = Color(0xFFB86D50);
  static const muted = Color(0xFF74766D);

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
        titleTextStyle: TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        color: paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFD9D4C8)),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: paper,
        indicatorColor: const Color(0xFFE3E9E0),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: paper,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: forest,
          side: const BorderSide(color: forest),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 30, height: 1.12, fontWeight: FontWeight.w700, letterSpacing: -1.2, color: ink),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ink),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
        bodyLarge: TextStyle(fontSize: 15, height: 1.6, color: ink),
        bodyMedium: TextStyle(fontSize: 13, height: 1.6, color: muted),
      ),
    );
  }
}
