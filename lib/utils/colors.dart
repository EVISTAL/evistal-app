import 'package:flutter/material.dart';

/// EVISTAL App Color System
/// Spesifikasyona göre tüm renkler burada tanımlanmıştır

class AppColors {
  // ============================================================================
  // DARK MODE COLORS
  // ============================================================================
  
  // Backgrounds
  static const Color darkBackground = Color(0xFF000000); // Pure Black
  static const Color darkCardBackground = Color(0xFF1F2937); // gray-800
  static const Color darkCardBackgroundAlt = Color(0xFF111827); // gray-900
  
  // Text Colors
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // White
  static const Color darkTextSecondary = Color(0xFF9CA3AF); // gray-400
  static const Color darkTextTertiary = Color(0xFF6B7280); // gray-500
  
  // Border
  static const Color darkBorder = Color(0xFF1F2937); // gray-800
  
  // Inactive Icons
  static const Color darkIconInactive = Color(0xFF9CA3AF); // gray-400
  static const Color darkIconActive = Color(0xFFFFFFFF); // White
  
  // Additional Dark Colors
  static const Color darkGray700 = Color(0xFF374151);
  static const Color darkGray600 = Color(0xFF4B5563);
  
  // ============================================================================
  // LIGHT MODE COLORS
  // ============================================================================
  
  // Backgrounds
  static const Color lightBackground = Color(0xFFF9FAFB); // gray-50
  static const Color lightCardBackground = Color(0xFFFFFFFF); // White
  static const Color lightCardBackgroundAlt = Color(0xFFF3F4F6); // gray-100
  
  // Text Colors
  static const Color lightTextPrimary = Color(0xFF1F2937); // gray-800
  static const Color lightTextSecondary = Color(0xFF4B5563); // gray-600
  static const Color lightTextTertiary = Color(0xFF6B7280); // gray-500
  
  // Border
  static const Color lightBorder = Color(0xFFE5E7EB); // gray-200
  
  // Icons
  static const Color lightIconActive = Color(0xFF6B7280); // gray-600
  static const Color lightIconInactive = Color(0xFF9CA3AF); // gray-400
  
  // Additional Light Colors
  static const Color lightGray100 = Color(0xFFF3F4F6);
  static const Color lightGray200 = Color(0xFFE5E7EB);
  static const Color lightGray300 = Color(0xFFD1D5DB);
  static const Color lightGray400 = Color(0xFF9CA3AF);
  static const Color lightGray500 = Color(0xFF6B7280);
  
  // ============================================================================
  // RGB MODE COLORS (For Purifier Control)
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
  // ACTIVE ELEMENT GRADIENTS
  // ============================================================================
  
  // Dark Mode Active Gradient (White to gray-200)
  static const LinearGradient darkActiveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF), // White
      Color(0xFFF3F4F6), // gray-100
      Color(0xFFE5E7EB), // gray-200
    ],
  );
  
  // Light Mode Active Gradient (gray-300 to gray-500)
  static const LinearGradient lightActiveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD1D5DB), // gray-300
      Color(0xFF9CA3AF), // gray-400
      Color(0xFF6B7280), // gray-500
    ],
  );
  
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
  // SPECIAL COLORS
  // ============================================================================
  
  static const Color themeIconSun = Color(0xFFFBBF24); // yellow-400
  
  // Mode Active Background Colors (Dark Mode)
  static const Color autoModeBgDark = Color(0x4D083344); // #083344 with 30% opacity
  static const Color nightModeBgDark = Color(0x4D312E81); // #312E81 with 30% opacity
  static const Color airFlowBgDark = Color(0x4D1E3A8A); // #1E3A8A with 30% opacity
  
  // Mode Active Background Colors (Light Mode)
  static const Color autoModeBgLight = Color(0xFFCFFAFE); // cyan-100
  static const Color nightModeBgLight = Color(0xFFE0E7FF); // indigo-100
  static const Color airFlowBgLight = Color(0xFFDBEAFE); // blue-100
}


