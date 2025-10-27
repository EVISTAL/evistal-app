import 'package:flutter/material.dart';

/// EVISTAL App Color System
/// ThemeExtension kullanarak merkezi tema yönetimi
/// Dark ve Light mode renkleri otomatik olarak yönetilir

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  // ============================================================================
  // THEME COLORS (Otomatik dark/light değişimi)
  // ============================================================================
  
  final Color background;
  final Color cardBackground;
  final Color cardBackgroundAlt;
  
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  
  final Color border;
  
  final Color iconActive;
  final Color iconInactive;
  
  final Color primary;
  final Color primaryAccent;
  final Color primaryLight;
  
  final LinearGradient primaryGradient;
  final LinearGradient activeGradient;
  
  // Additional grays for flexibility
  final Color gray100;
  final Color gray200;
  final Color gray300;
  final Color gray400;
  final Color gray500;
  final Color gray600;
  final Color gray700;
  
  const AppColorScheme({
    required this.background,
    required this.cardBackground,
    required this.cardBackgroundAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.iconActive,
    required this.iconInactive,
    required this.primary,
    required this.primaryAccent,
    required this.primaryLight,
    required this.primaryGradient,
    required this.activeGradient,
    required this.gray100,
    required this.gray200,
    required this.gray300,
    required this.gray400,
    required this.gray500,
    required this.gray600,
    required this.gray700,
  });
  
  // ============================================================================
  // DARK MODE THEME
  // ============================================================================
  
  static const AppColorScheme dark = AppColorScheme(
    // Backgrounds
    background: Color(0xFF000000), // Pure Black
    cardBackground: Color(0xFF1F2937), // gray-800
    cardBackgroundAlt: Color(0xFF111827), // gray-900
    
    // Text Colors (Soft White)
    textPrimary: Color(0xFFE5E7EB), // gray-200 - Soft matte white
    textSecondary: Color(0xFF9CA3AF), // gray-400
    textTertiary: Color(0xFF6B7280), // gray-500
    
    // Border
    border: Color(0xFF1F2937), // gray-800
    
    // Icons
    iconActive: Color(0xFFE5E7EB), // Soft White
    iconInactive: Color(0xFF9CA3AF), // gray-400
    
    // Primary Colors (Monochrome: Black & White)
    primary: Color(0xFF000000), // Black
    primaryAccent: Color(0xFF1F1F1F), // Dark Gray
    primaryLight: Color(0xFFFFFFFF), // White
    
    // Primary Gradient (Black to Dark Gray)
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1F1F1F), // Dark Gray
        Color(0xFF000000), // Black
      ],
    ),
    
    // Active Gradient (Soft White shades)
    activeGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFE5E7EB), // Soft White (gray-200)
        Color(0xFFD1D5DB), // gray-300
        Color(0xFFBFC3C7), // gray-350 (custom)
      ],
    ),
    
    // Additional Grays
    gray100: Color(0xFFF3F4F6),
    gray200: Color(0xFFE5E7EB),
    gray300: Color(0xFFD1D5DB),
    gray400: Color(0xFF9CA3AF),
    gray500: Color(0xFF6B7280),
    gray600: Color(0xFF4B5563),
    gray700: Color(0xFF374151),
  );
  
  // ============================================================================
  // LIGHT MODE THEME
  // ============================================================================
  
  static const AppColorScheme light = AppColorScheme(
    // Backgrounds
    background: Color(0xFFF9FAFB), // gray-50
    cardBackground: Color(0xFFFFFFFF), // White
    cardBackgroundAlt: Color(0xFFF3F4F6), // gray-100
    
    // Text Colors
    textPrimary: Color(0xFF1F2937), // gray-800
    textSecondary: Color(0xFF4B5563), // gray-600
    textTertiary: Color(0xFF6B7280), // gray-500
    
    // Border
    border: Color(0xFFE5E7EB), // gray-200
    
    // Icons
    iconActive: Color(0xFF6B7280), // gray-600
    iconInactive: Color(0xFF9CA3AF), // gray-400
    
    // Primary Colors (Monochrome: Gray & White)
    primary: Color(0xFF6B7280), // gray-500
    primaryAccent: Color(0xFF9CA3AF), // gray-400
    primaryLight: Color(0xFF4B5563), // gray-600
    
    // Primary Gradient (Gray shades)
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF6B7280), // gray-500
        Color(0xFF4B5563), // gray-600
      ],
    ),
    
    // Active Gradient (Gray shades)
    activeGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFD1D5DB), // gray-300
        Color(0xFF9CA3AF), // gray-400
        Color(0xFF6B7280), // gray-500
      ],
    ),
    
    // Additional Grays
    gray100: Color(0xFFF3F4F6),
    gray200: Color(0xFFE5E7EB),
    gray300: Color(0xFFD1D5DB),
    gray400: Color(0xFF9CA3AF),
    gray500: Color(0xFF6B7280),
    gray600: Color(0xFF4B5563),
    gray700: Color(0xFF374151),
  );
  
  // ============================================================================
  // THEME EXTENSION METHODS (Required by Flutter)
  // ============================================================================
  
  @override
  ThemeExtension<AppColorScheme> copyWith({
    Color? background,
    Color? cardBackground,
    Color? cardBackgroundAlt,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? iconActive,
    Color? iconInactive,
    Color? primary,
    Color? primaryAccent,
    Color? primaryLight,
    LinearGradient? primaryGradient,
    LinearGradient? activeGradient,
    Color? gray100,
    Color? gray200,
    Color? gray300,
    Color? gray400,
    Color? gray500,
    Color? gray600,
    Color? gray700,
  }) {
    return AppColorScheme(
      background: background ?? this.background,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBackgroundAlt: cardBackgroundAlt ?? this.cardBackgroundAlt,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      iconActive: iconActive ?? this.iconActive,
      iconInactive: iconInactive ?? this.iconInactive,
      primary: primary ?? this.primary,
      primaryAccent: primaryAccent ?? this.primaryAccent,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      activeGradient: activeGradient ?? this.activeGradient,
      gray100: gray100 ?? this.gray100,
      gray200: gray200 ?? this.gray200,
      gray300: gray300 ?? this.gray300,
      gray400: gray400 ?? this.gray400,
      gray500: gray500 ?? this.gray500,
      gray600: gray600 ?? this.gray600,
      gray700: gray700 ?? this.gray700,
    );
  }
  
  @override
  ThemeExtension<AppColorScheme> lerp(
    ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) return this;
    
    return AppColorScheme(
      background: Color.lerp(background, other.background, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBackgroundAlt: Color.lerp(cardBackgroundAlt, other.cardBackgroundAlt, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      iconActive: Color.lerp(iconActive, other.iconActive, t)!,
      iconInactive: Color.lerp(iconInactive, other.iconInactive, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      activeGradient: LinearGradient.lerp(activeGradient, other.activeGradient, t)!,
      gray100: Color.lerp(gray100, other.gray100, t)!,
      gray200: Color.lerp(gray200, other.gray200, t)!,
      gray300: Color.lerp(gray300, other.gray300, t)!,
      gray400: Color.lerp(gray400, other.gray400, t)!,
      gray500: Color.lerp(gray500, other.gray500, t)!,
      gray600: Color.lerp(gray600, other.gray600, t)!,
      gray700: Color.lerp(gray700, other.gray700, t)!,
    );
  }
}

// ============================================================================
// HELPER CLASS (Static değerler - RGB Mode & Special)
// ============================================================================

class AppColors {
  // ============================================================================
  // RGB MODE COLORS (Humidifier smoke - exception to monochrome)
  // ============================================================================
  
  // Mode 0 - Gri Duman
  static const Color rgbMode0Start = Color(0xFF9CA3AF); // gray-400
  static const Color rgbMode0End = Color(0xFF6B7280); // gray-500
  static const Color rgbMode0Light = Color(0xFF9CA3AF);
  
  // Mode 1 - RGB Geçiş (Kırmızı → Yeşil → Mavi)
  static const Color rgbMode1Red = Color(0xFFEF4444); // red-500
  static const Color rgbMode1Green = Color(0xFF22C55E); // green-500
  static const Color rgbMode1Blue = Color(0xFF3B82F6); // blue-500
  static const Color rgbMode1Start = Color(0xFFEF4444); // red-500
  static const Color rgbMode1End = Color(0xFF3B82F6); // blue-500
  static const Color rgbMode1Light = Color(0xFFEF4444);
  
  // Mode 2 - Gökkuşağı
  static const Color rgbMode2Red = Color(0xFFFF0000); // Red
  static const Color rgbMode2Orange = Color(0xFFFF7F00); // Orange
  static const Color rgbMode2Yellow = Color(0xFFFFFF00); // Yellow
  static const Color rgbMode2Green = Color(0xFF00FF00); // Green
  static const Color rgbMode2Blue = Color(0xFF0000FF); // Blue
  static const Color rgbMode2Purple = Color(0xFF8B00FF); // Purple
  static const Color rgbMode2Start = Color(0xFFFF0000); // Red
  static const Color rgbMode2End = Color(0xFF8B00FF); // Purple
  static const Color rgbMode2Light = Color(0xFFFF0000);
  
  // Mode 3 - Beyaz Duman
  static const Color rgbMode3Start = Color(0xFFFFFFFF); // White
  static const Color rgbMode3End = Color(0xFFF3F4F6); // gray-100
  static const Color rgbMode3Light = Color(0xFFFFFFFF);
  
  // ============================================================================
  // RGB MODE GRADIENTS
  // ============================================================================
  
  static LinearGradient getRgbGradient(int mode) {
    switch (mode) {
      case 1:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [rgbMode1Start, rgbMode1End],
        );
      case 2:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [rgbMode2Start, rgbMode2End],
        );
      case 3:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [rgbMode3Start, rgbMode3End],
        );
      case 0:
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [rgbMode0Start, rgbMode0End],
        );
    }
  }
  
  static Color getRgbLightColor(int mode) {
    switch (mode) {
      case 1: return rgbMode1Light;
      case 2: return rgbMode2Light;
      case 3: return rgbMode3Light;
      case 0:
      default: return rgbMode0Light;
    }
  }
  
  // ============================================================================
  // SPECIAL COLORS (Disconnect panel - exception to monochrome)
  // ============================================================================
  
  static const Color disconnectRed = Color(0xFFEF4444); // red-500
  static const Color disconnectRedLight = Color(0xFFFEE2E2); // red-50
}

// ============================================================================
// THEME EXTENSION HELPER (Easy access)
// ============================================================================

extension ThemeGetter on BuildContext {
  AppColorScheme get colors => Theme.of(this).extension<AppColorScheme>()!;
}
