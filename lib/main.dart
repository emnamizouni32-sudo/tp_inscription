import 'package:flutter/material.dart';

import 'screens/step_one_screen.dart';

void main() => runApp(const InscriptionApp());

/// Mêmes couleurs que les styles locaux Figma (page « Composants »).
/// Si tu changes une couleur dans Figma, change-la ici aussi.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFE91E8C); // Color / Primary
  static const Color error = Color(0xFFD32F2F); // Color / Error
  static const Color surface = Color(0xFFFFFFFF); // Color / Surface
  static const Color fieldBackground = Color(0xFFFDF2F8); // Color / Field background
}

class InscriptionApp extends StatelessWidget {
  const InscriptionApp({super.key});

  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // rayon 8 comme dans Figma
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
        // Variantes Default / Focus / Error du composant « Champ de saisie »
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.fieldBackground,
          border: _border(Colors.transparent, 1),
          enabledBorder: _border(Colors.transparent, 1),
          focusedBorder: _border(AppColors.primary, 2), // Focus : 2 px Primary
          errorBorder: _border(AppColors.error, 1),
          focusedErrorBorder: _border(AppColors.error, 2),
          errorStyle: const TextStyle(fontSize: 12, color: AppColors.error),
          helperStyle: const TextStyle(fontSize: 12),
        ),
        // Bouton Primary : hauteur 48, rayon 24
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        // Bouton Secondary
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