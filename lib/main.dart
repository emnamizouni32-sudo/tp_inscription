import 'package:flutter/material.dart';

import 'screens/step_one_screen.dart';

void main() => runApp(const InscriptionApp());
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFE91E8C); 
  static const Color error = Color(0xFFD32F2F); 
  static const Color surface = Color(0xFFFFFFFF); 
  static const Color fieldBackground = Color(0xFFFDF2F8); 
}

class InscriptionApp extends StatelessWidget {
  const InscriptionApp({super.key});

  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), 
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ).copyWith(
      primary: AppColors.primary,
      error: AppColors.error,
      surface: AppColors.surface,
    );

    return MaterialApp(
      title: 'Inscription',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.surface,
        // Text / Title : Roboto 20, Medium
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          surfaceTintColor: AppColors.surface,
          foregroundColor: Colors.black87,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.fieldBackground,
          border: _border(Colors.transparent, 1),
          enabledBorder: _border(Colors.transparent, 1),
          focusedBorder: _border(AppColors.primary, 2), 
          errorBorder: _border(AppColors.error, 1),
          focusedErrorBorder: _border(AppColors.error, 2),
          errorStyle: const TextStyle(fontSize: 12, color: AppColors.error),
          helperStyle: const TextStyle(fontSize: 12),
        ),
        
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
      home: const StepOneScreen(),
    );
  }
}