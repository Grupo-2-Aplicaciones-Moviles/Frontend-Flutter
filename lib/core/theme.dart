import 'package:flutter/material.dart';

/// Colores de marca WeRide — espejo de Color.kt del front Android.
class WeRideColors {
  WeRideColors._();

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color energyGreen = Color(0xFF18FA3A);

  static const Color lightGray = Color(0xFFD9D9D9);
  static const Color mediumGray = Color(0xFFA6A6A6);
  static const Color darkGray = Color(0xFF4F4F4F);

  static const Color errorRed = Color(0xFFE53935);
  static const Color successGreen = Color(0xFF43A047);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF2196F3);

  static const Color scooterGreen = Color(0xFF4CAF50);
  static const Color bikeBlue = Color(0xFF2196F3);
  static const Color motorcycleOrange = Color(0xFFFF9800);

  static const Color starYellow = Color(0xFFFFC107);
}

ThemeData weRideTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: WeRideColors.energyGreen,
    onPrimary: WeRideColors.black,
    secondary: WeRideColors.energyGreen,
    onSecondary: WeRideColors.black,
    error: WeRideColors.errorRed,
    onError: WeRideColors.white,
    surface: Color(0xFF121212),
    onSurface: WeRideColors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: WeRideColors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: WeRideColors.black,
      foregroundColor: WeRideColors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: WeRideColors.energyGreen,
        foregroundColor: WeRideColors.black,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WeRideColors.energyGreen, width: 1.5),
      ),
      hintStyle: const TextStyle(color: WeRideColors.mediumGray),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1A1A),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0D0D0D),
      selectedItemColor: WeRideColors.energyGreen,
      unselectedItemColor: WeRideColors.mediumGray,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
