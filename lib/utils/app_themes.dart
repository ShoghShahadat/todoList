import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// A utility class to manage the theme properties for the application.
class AppTheme {
  final String name;
  final MaterialColor color;

  const AppTheme({required this.name, required this.color});

  // A static list of available themes for the user to choose from.
  static final List<AppTheme> themes = [
    const AppTheme(name: 'آبی', color: Colors.blue),
    const AppTheme(name: 'قرمز', color: Colors.red),
    const AppTheme(name: 'سبز', color: Colors.green),
    const AppTheme(name: 'نارنجی', color: Colors.orange),
    const AppTheme(name: 'بنفش', color: Colors.purple),
    const AppTheme(name: 'صورتی', color: Colors.pink),
    const AppTheme(name: 'چای سبز', color: Colors.teal),
    const AppTheme(name: 'کهربایی', color: Colors.amber),
  ];

  // A helper method to generate a light ThemeData based on the theme's color.
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: color,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: AppBarTheme(
        backgroundColor: color,
        elevation: 0,
        titleTextStyle: GoogleFonts.vazirmatn(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        // Ensure icons in the AppBar are white for good contrast.
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.vazirmatn(color: Colors.black87),
        bodyMedium: GoogleFonts.vazirmatn(color: Colors.black54),
        titleLarge: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
      ),
      useMaterial3: true,
    );
  }

  // A helper method to generate a dark ThemeData based on the theme's color.
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: color,
      scaffoldBackgroundColor: const Color(0xFF212121),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        titleTextStyle: GoogleFonts.vazirmatn(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        // *** THE MAGIC HAPPENS HERE! ***
        // Icons in the AppBar will now take on the selected theme color.
        iconTheme: IconThemeData(color: color),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.vazirmatn(color: Colors.white),
        bodyMedium: GoogleFonts.vazirmatn(color: Colors.white70),
        titleLarge: GoogleFonts.vazirmatn(
            fontWeight: FontWeight.bold, color: Colors.white),
      ),
      useMaterial3: true,
    );
  }
}
