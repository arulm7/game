import 'package:flutter/material.dart';

class AppTheme {
  // Deep Botanical Garden Colors
  static const Color gardenDarkBg = Color(0xFF040D09);
  static const Color gardenMidBg = Color(0xFF091E16);
  static const Color gardenSurface = Color(0xFF0E2E22);
  static const Color gardenSurfaceElevated = Color(0xFF164433);

  // Glass & Terrarium
  static const Color glassBorder = Color(0x7376C893);
  static const Color glassFill = Color(0x1F52B788);
  static const Color glassHighlight = Color(0x52FFFFFF);

  // Living Botanical Accents
  static const Color rosePetal = Color(0xFFFF4D6D);
  static const Color roseGlow = Color(0xFFFF758F);
  static const Color roseCore = Color(0xFFC9184A);
  static const Color roseDeep = Color(0xFF590D22);

  static const Color leafGreen = Color(0xFF52B788);
  static const Color leafDeep = Color(0xFF1B4332);
  static const Color mintGlow = Color(0xFF74C69D);
  static const Color emeraldSap = Color(0xFF2D6A4F);

  // Relic & Biological Threat Accents
  static const Color amberSeed = Color(0xFFFFD166);
  static const Color goldAccent = Color(0xFFFFC043);
  static const Color bioBlight = Color(0xFF9D4EDD);
  static const Color plaqueWarning = Color(0xFFFF5964);
  static const Color plaqueCrust = Color(0xFF6B1D2F);
  static const Color energyCyan = Color(0xFF38BDF8);

  // Gradients
  static const LinearGradient gardenBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF030A07),
      Color(0xFF071912),
      Color(0xFF0D281D),
      Color(0xFF05120D),
    ],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x38A7F3D0),
      Color(0x1552B788),
      Color(0x0A10B981),
      Color(0x2E059669),
    ],
  );

  static const LinearGradient roseGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFF8FA3),
      Color(0xFFFF4D6D),
      Color(0xFFC9184A),
      Color(0xFF590D22),
    ],
  );

  // Card Themed Gradients
  static const LinearGradient isotonicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B3B4B), Color(0xFF06202B)],
  );

  static const LinearGradient beetrootGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A1024), Color(0xFF2B0713)],
  );

  static const LinearGradient potassiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3D3208), Color(0xFF241D03)],
  );

  static const LinearGradient relaxationGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F3D2C), Color(0xFF08241A)],
  );

  static const LinearGradient isometricGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B1547), Color(0xFF220B2B)],
  );

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: gardenDarkBg,
      colorScheme: const ColorScheme.dark(
        primary: leafGreen,
        secondary: rosePetal,
        surface: gardenSurface,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Color(0xFFE8F5E9),
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFD8F3DC)),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.4,
          color: Color(0xFFE8F5E9),
        ),
      ),
    );
  }
}
