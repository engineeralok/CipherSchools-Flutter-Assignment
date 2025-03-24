import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
