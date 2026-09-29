import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for a theme palette (matte, non-glossy, architectural fintech aesthetic)
class ThemePalette {
  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color surfaceCard;
  final Color surfaceCardElevated;
  final Color surfaceBorder;
  final Color surfaceBorderLight;

  // Accents (Subtle matte tones without neon gloss)
  final Color goldAccent;
  final Color goldAccentLight;
  final Color emeraldAccent;
  final Color cyanAccent;
  final Color crimsonAccent;
  final Color amberAccent;

  // Typography
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // Gradients (Muted, subtle transitions)
  final LinearGradient goldGradient;
  final LinearGradient blackEditionGradient;
  final LinearGradient amexGradient;
  final LinearGradient chaseGradient;
  final LinearGradient ventureGradient;
  final LinearGradient cardOverlay;

  const ThemePalette({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceCard,
    required this.surfaceCardElevated,
    required this.surfaceBorder,
    required this.surfaceBorderLight,
    required this.goldAccent,
    required this.goldAccentLight,
    required this.emeraldAccent,
    required this.cyanAccent,
    required this.crimsonAccent,
    required this.amberAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.goldGradient,
    required this.blackEditionGradient,
    required this.amexGradient,
    required this.chaseGradient,
    required this.ventureGradient,
    required this.cardOverlay,
  });

  bool get isDark => brightness == Brightness.dark;

  ThemePalette copyWith({
    Brightness? brightness,
    Color? background,
    Color? surface,
    Color? surfaceCard,
    Color? surfaceCardElevated,
    Color? surfaceBorder,
    Color? surfaceBorderLight,
    Color? goldAccent,
    Color? goldAccentLight,
    Color? emeraldAccent,
    Color? cyanAccent,
    Color? crimsonAccent,
    Color? amberAccent,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    LinearGradient? goldGradient,
    LinearGradient? blackEditionGradient,
    LinearGradient? amexGradient,
    LinearGradient? chaseGradient,
    LinearGradient? ventureGradient,
    LinearGradient? cardOverlay,
  }) {
    return ThemePalette(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceCardElevated: surfaceCardElevated ?? this.surfaceCardElevated,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      surfaceBorderLight: surfaceBorderLight ?? this.surfaceBorderLight,
      goldAccent: goldAccent ?? this.goldAccent,
      goldAccentLight: goldAccentLight ?? this.goldAccentLight,
      emeraldAccent: emeraldAccent ?? this.emeraldAccent,
      cyanAccent: cyanAccent ?? this.cyanAccent,
      crimsonAccent: crimsonAccent ?? this.crimsonAccent,
      amberAccent: amberAccent ?? this.amberAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      goldGradient: goldGradient ?? this.goldGradient,
      blackEditionGradient: blackEditionGradient ?? this.blackEditionGradient,
      amexGradient: amexGradient ?? this.amexGradient,
      chaseGradient: chaseGradient ?? this.chaseGradient,
      ventureGradient: ventureGradient ?? this.ventureGradient,
      cardOverlay: cardOverlay ?? this.cardOverlay,
    );
  }

  /// Dark Palette: Stealth graphite & matte obsidian
  static const ThemePalette dark = ThemePalette(
    brightness: Brightness.dark,
    background: Color(0xFF0C0D11),
    surface: Color(0xFF14161E),
    surfaceCard: Color(0xFF1A1D27),
    surfaceCardElevated: Color(0xFF222634),
    surfaceBorder: Color(0xFF2A2E3D),
    surfaceBorderLight: Color(0xFF383D50),
    goldAccent: Color(0xFFD4AF37), // Matte champagne brass
    goldAccentLight: Color(0xFFE6C875),
    emeraldAccent: Color(0xFF10B981), // Matte emerald
    cyanAccent: Color(0xFF0EA5E9), // Slate cyan
    crimsonAccent: Color(0xFFF43F5E), // Terracotta crimson
    amberAccent: Color(0xFFF59E0B),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    goldGradient: LinearGradient(
      colors: [Color(0xFFDFC27D), Color(0xFFB8860B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    blackEditionGradient: LinearGradient(
      colors: [Color(0xFF222634), Color(0xFF14161E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    amexGradient: LinearGradient(
      colors: [Color(0xFF2A3644), Color(0xFF1B232D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    chaseGradient: LinearGradient(
      colors: [Color(0xFF1A335C), Color(0xFF11223F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    ventureGradient: LinearGradient(
      colors: [Color(0xFF5B21B6), Color(0xFF3B0764)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardOverlay: LinearGradient(
      colors: [Color(0x14FFFFFF), Color(0x05FFFFFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  /// Light Palette: Warm gallery paper, crisp matte card surfaces, deep ink typography
  static const ThemePalette light = ThemePalette(
    brightness: Brightness.light,
    background: Color(0xFFF6F7F9), // Warm gallery paper canvas
    surface: Color(0xFFFFFFFF),
    surfaceCard: Color(0xFFFFFFFF),
    surfaceCardElevated: Color(0xFFF1F3F6),
    surfaceBorder: Color(0xFFE2E4E9), // Hairline subtle border
    surfaceBorderLight: Color(0xFFD1D5DB),
    goldAccent: Color(0xFF9E742E), // Rich matte brass (strong contrast on light)
    goldAccentLight: Color(0xFFB8860B),
    emeraldAccent: Color(0xFF0D7A46), // British racing matte green
    cyanAccent: Color(0xFF0369A1), // Deep slate cyan
    crimsonAccent: Color(0xFFBE123C), // Matte berry crimson
    amberAccent: Color(0xFFB45309),
    textPrimary: Color(0xFF0F172A), // Deep ink charcoal
    textSecondary: Color(0xFF475569), // Slate secondary
    textMuted: Color(0xFF94A3B8),
    goldGradient: LinearGradient(
      colors: [Color(0xFFC59B3C), Color(0xFF9E742E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    blackEditionGradient: LinearGradient(
      colors: [Color(0xFF1E232E), Color(0xFF0F121A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    amexGradient: LinearGradient(
      colors: [Color(0xFF2A3644), Color(0xFF1B232D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    chaseGradient: LinearGradient(
      colors: [Color(0xFF1A335C), Color(0xFF11223F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    ventureGradient: LinearGradient(
      colors: [Color(0xFF5B21B6), Color(0xFF3B0764)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardOverlay: LinearGradient(
      colors: [Color(0x0A000000), Color(0x00000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

/// Centralized Config Engine: Changing active palette or theme mode updates all colors across the app
class AppThemeConfig {
  static ThemeMode _themeMode = ThemeMode.dark;
  static ThemePalette darkPalette = ThemePalette.dark;
  static ThemePalette lightPalette = ThemePalette.light;
  static ThemePalette? _customPalette;

  static ThemeMode get themeMode => _themeMode;
  static bool get isDark => _themeMode == ThemeMode.dark;

  static ThemePalette get palette => current;
  static ThemePalette get current {
    if (_customPalette != null) return _customPalette!;
    return isDark ? darkPalette : lightPalette;
  }

  static void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
  }

  static void toggleThemeMode() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  static void setCustomPalette(ThemePalette palette) {
    _customPalette = palette;
  }

  static void resetToDefaults() {
    _customPalette = null;
    darkPalette = ThemePalette.dark;
    lightPalette = ThemePalette.light;
  }
}

/// Main AppTheme class exposing dynamic getters backed by AppThemeConfig
class AppTheme {
  static ThemePalette get palette => AppThemeConfig.current;

  // Primary Palette
  static Color get background => palette.background;
  static Color get surface => palette.surface;
  static Color get surfaceCard => palette.surfaceCard;
  static Color get surfaceCardElevated => palette.surfaceCardElevated;
  static Color get surfaceBorder => palette.surfaceBorder;
  static Color get surfaceBorderLight => palette.surfaceBorderLight;

  // Accents
  static Color get goldAccent => palette.goldAccent;
  static Color get goldAccentLight => palette.goldAccentLight;
  static Color get emeraldAccent => palette.emeraldAccent;
  static Color get cyanAccent => palette.cyanAccent;
  static Color get crimsonAccent => palette.crimsonAccent;
  static Color get amberAccent => palette.amberAccent;

  // Typography Colors
  static Color get textPrimary => palette.textPrimary;
  static Color get textSecondary => palette.textSecondary;
  static Color get textMuted => palette.textMuted;

  // Gradients
  static LinearGradient get goldGradient => palette.goldGradient;
  static LinearGradient get blackEditionGradient => palette.blackEditionGradient;
  static LinearGradient get amexGradient => palette.amexGradient;
  static LinearGradient get chaseGradient => palette.chaseGradient;
  static LinearGradient get ventureGradient => palette.ventureGradient;
  static LinearGradient get cardOverlayGlass => palette.cardOverlay;

  static ThemeData get darkTheme => _buildTheme(ThemePalette.dark);
  static ThemeData get lightTheme => _buildTheme(ThemePalette.light);

  static ThemeData _buildTheme(ThemePalette p) {
    final isDark = p.brightness == Brightness.dark;
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();

    return ThemeData(
      brightness: p.brightness,
      scaffoldBackgroundColor: p.background,
      primaryColor: p.goldAccent,
      cardColor: p.surfaceCard,
      colorScheme: ColorScheme(
        brightness: p.brightness,
        primary: p.goldAccent,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: p.cyanAccent,
        onSecondary: Colors.white,
        error: p.crimsonAccent,
        onError: Colors.white,
        surface: p.surface,
        onSurface: p.textPrimary,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        baseTheme.textTheme,
      ).apply(
        bodyColor: p.textPrimary,
        displayColor: p.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: p.textPrimary),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: p.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: p.surfaceBorder,
        thickness: 1,
      ),
      useMaterial3: true,
    );
  }
}
