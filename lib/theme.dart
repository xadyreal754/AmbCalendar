import 'package:flutter/material.dart';

class AppTheme {
  static const seed = Color(0xFFFF6F20);      // #FF6F20
  static const accent = Color(0xFFD68A3D);    // #D68A3D
  static const warm = Color(0xFFFFB04B);      // #FFB04B
  static const cream = Color(0xFFFEEEB3);     // #FEEEB3
  static const ink = Color(0xFF4B3D29);       // #4B3D29

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness b) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: b,
    ).copyWith(
      primary: seed,
      secondary: accent,
      tertiary: warm,
      surface: b == Brightness.light ? Colors.white : const Color(0xFF1C1712),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          b == Brightness.light ? cream : const Color(0xFF15100B),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: b == Brightness.light ? Colors.white : const Color(0xFF241C14),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
    );
  }
}