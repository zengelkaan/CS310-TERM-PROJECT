import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color lightPink = Color(0xFFF8E1F4);
  static const Color backgroundPink = Color(0xFFFCE4EC); // Very light pink for backgrounds
  static const Color accentColor = Color(0xFFC2185B);
  static const Color white = Colors.white;
  static const Color black = Colors.black87;
  static const Color grey = Colors.grey;

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: black,
    fontFamily: 'Poppins', // Custom font
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: black,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: black,
    fontFamily: 'Poppins',
  );

  static const TextStyle subText = TextStyle(
    fontSize: 12,
    color: grey,
    fontFamily: 'Poppins',
  );

  // Padding
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryPink,
      primarySwatch: Colors.pink,
      scaffoldBackgroundColor: white,
      fontFamily: 'Poppins', // Applied globally
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: black),
        titleTextStyle: TextStyle(
          color: black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: lightPink,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

