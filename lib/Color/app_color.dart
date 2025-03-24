import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2E8B57); // Sea Green
  static const Color buttonColor = Color(0xFF3CB371); // Medium Sea Green
  static const Color secondaryColor = Color(0xFF228B22); // Forest Green
  static const Color accentColor = Color(0xFF32CD32); // Lime Green
  static const Color backgroundColor = Color(0xFF90EE90); // Light Green
  static const Color textColor = Color(0xFF006400); // Dark Green (For readability)
  static const Color buttonTextColor = Color(0xFFFFFFFF); // White (For contrast)
  static const Color containerBackground = Color(0xFF008000); // Green

  static ThemeData orangeTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: textColor, fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: buttonTextColor,
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: secondaryColor,
      titleTextStyle: TextStyle(color: buttonTextColor, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: buttonTextColor),
    ),
    cardColor: containerBackground,
  );
}
