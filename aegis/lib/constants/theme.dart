import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Palette
  static const Color background = Color(0xFF08080C);
  static const Color surface = Color(0xFF111118);
  static const Color surfaceCard = Color(0xFF171722);
  static const Color surfaceCardElevated = Color(0xFF1F1F2E);
  static const Color surfaceBorder = Color(0xFF28283C);
  static const Color surfaceBorderLight = Color(0xFF383850);

  // Accents
  static const Color goldAccent = Color(0xFFE5B869);
  static const Color goldAccentLight = Color(0xFFF7D59A);
  static const Color emeraldAccent = Color(0xFF00E676);
  static const Color cyanAccent = Color(0xFF00E5FF);
  static const Color crimsonAccent = Color(0xFFFF3366);
  static const Color amberAccent = Color(0xFFFFB300);

  // Typography Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0B8);
  static const Color textMuted = Color(0xFF6B6B80);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF7D59A), Color(0xFFD49E45), Color(0xFF9E6B1F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blackEditionGradient = LinearGradient(
    colors: [Color(0xFF2A2A38), Color(0xFF161622), Color(0xFF0D0D15)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amexGradient = LinearGradient(
    colors: [Color(0xFF2C3E50), Color(0xFF1A252F), Color(0xFF11171D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient chaseGradient = LinearGradient(
    colors: [Color(0xFF1E3C72), Color(0xFF2A5298), Color(0xFF142038)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ventureGradient = LinearGradient(
    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardOverlayGlass = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: goldAccent,
      cardColor: surfaceCard,
      colorScheme: const ColorScheme.dark(
        primary: goldAccent,
        secondary: cyanAccent,
        surface: surface,
        error: crimsonAccent,
        onPrimary: Colors.black,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      useMaterial3: true,
    );
  }
}
