import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ClinOps Design Token System
/// 
/// Brand colors, typography, and spacing derived from the ClinOps design brief.
/// All visual decisions should reference these tokens rather than ad-hoc values.
class ClinOpsTheme {
  // Private constructor to prevent instantiation
  ClinOpsTheme._();

  // ============================================
  // COLOR TOKENS
  // ============================================
  
  /// Primary brand color - deep petrol/teal
  /// Used for: nav shell, headers, primary structure
  static const Color primary = Color(0xFF0F4C4C);
  
  /// Primary dark - hover/pressed states
  static const Color primaryDark = Color(0xFF0A3535);
  
  /// Accent color - warm ochre/gold
  /// Used for: primary buttons, Thread motif, key highlights (sparingly)
  static const Color accent = Color(0xFFC98A2C);
  
  /// Neutral background - warm off-white
  static const Color background = Color(0xFFF7F5F1);
  
  /// Neutral surface - pure white for cards/panels
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Neutral ink - primary text with slight green undertone
  static const Color ink = Color(0xFF1C2624);
  
  /// Neutral muted - secondary text, captions
  static const Color muted = Color(0xFF6B7674);
  
  /// Semantic success - paid/cleared states
  static const Color success = Color(0xFF2E7D5B);
  
  /// Semantic warning - pending/awaiting states (reuses accent)
  static const Color warning = Color(0xFFC98A2C);
  
  /// Semantic danger - unpaid/blocked states
  static const Color danger = Color(0xFFB3402C);
  
  /// Semantic info - in-progress states
  static const Color info = Color(0xFF2E6E8E);
  
  /// Border color - muted neutral for hairline borders
  static const Color border = Color(0xFFE0DCD4);

  // ============================================
  // TYPOGRAPHY TOKENS
  // ============================================
  
  /// Display/Heading face - Space Grotesk
  /// Used for: section titles, station names, dashboard numbers
  static const String fontFamilyDisplay = 'SpaceGrotesk';
  
  /// Body face - Inter
  /// Used for: body text, form labels, table content
  static const String fontFamilyBody = 'Inter';
  
  /// Utility/Data face - IBM Plex Mono
  /// Used for: hospital IDs, timestamps, structured prescription values
  static const String fontFamilyMono = 'IBMPlexMono';

  // ============================================
  // SPACING TOKENS (8px base scale)
  // ============================================
  
  static const double space1 = 8.0;
  static const double space2 = 16.0;
  static const double space3 = 24.0;
  static const double space4 = 32.0;
  static const double space5 = 48.0;
  static const double space6 = 64.0;

  // ============================================
  // LAYOUT TOKENS
  // ============================================
  
  /// Corner radius for cards and inputs
  static const double radius = 6.0;
  
  /// Hairline border width
  static const double borderWidth = 1.0;

  // ============================================
  // MATERIAL THEME DATA
  // ============================================
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        primaryContainer: primaryDark,
        secondary: accent,
        surface: surface,
        background: background,
        error: danger,
        onPrimary: surface,
        onSecondary: surface,
        onSurface: ink,
        onBackground: ink,
        onError: surface,
      ),
      
      scaffoldBackgroundColor: background,
      
      // Typography
      textTheme: TextTheme(
        // Display sizes - Space Grotesk
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 57,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 45,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        
        // Headings - Space Grotesk
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        
        // Title - Space Grotesk
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        titleMedium: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        titleSmall: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        
        // Body - Inter
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ink,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ink,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: muted,
        ),
        
        // Label - Inter
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: muted,
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: space3, vertical: space2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: borderWidth),
          padding: const EdgeInsets.symmetric(horizontal: space3, vertical: space2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: space2, vertical: space1),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: space2,
          vertical: space2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: border, width: borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: border, width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: primary, width: borderWidth),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: danger, width: borderWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: danger, width: borderWidth),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: muted,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: muted,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: border, width: borderWidth),
        ),
        margin: const EdgeInsets.all(space1),
      ),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: surface,
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: borderWidth,
        space: space2,
      ),
    );
  }
}

/// Extension for easy access to mono font for utility data
extension ClinOpsTextStyles on BuildContext {
  /// Get mono font style for hospital IDs, timestamps, structured data
  TextStyle get monoStyle => GoogleFonts.ibmPlexMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: ClinOpsTheme.ink,
  );
  
  /// Get mono style for small utility text
  TextStyle get monoSmallStyle => GoogleFonts.ibmPlexMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: ClinOpsTheme.muted,
  );
}
