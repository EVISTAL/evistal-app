/// EVISTAL App Constants
/// Tüm sabit değerler ve yapılandırma parametreleri

class AppConstants {
  // ============================================================================
  // SPACING SYSTEM
  // ============================================================================
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;
  static const double spacing2Xl = 32.0;
  static const double spacing3Xl = 48.0;
  static const double spacing4Xl = 64.0;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radius2Xl = 32.0;
  static const double radius3Xl = 48.0;
  static const double radiusFull = 9999.0;

  // ============================================================================
  // FONT SIZES
  // ============================================================================
  static const double fontSizeExtraLarge = 48.0;
  static const double fontSizeLargeTitle = 34.0;
  static const double fontSizeTitle = 20.0;
  static const double fontSizeBody = 16.0;
  static const double fontSizeSubheadline = 14.0;
  static const double fontSizeCaption = 12.0;

  // ============================================================================
  // FONT WEIGHTS
  // ============================================================================
  static const int fontWeightRegular = 400;
  static const int fontWeightMedium = 500;
  static const int fontWeightSemibold = 600;
  static const int fontWeightBold = 700;

  // ============================================================================
  // ANIMATION DURATIONS (milliseconds)
  // ============================================================================
  static const int durationFast = 200;
  static const int durationNormal = 300;
  static const int durationSlow = 500;
  static const int durationThemeSwitch = 700;
  static const int durationBreathing = 2000;
  static const int durationToggle = 1500;
  static const int durationGlow = 3000;

  // ============================================================================
  // SIZES
  // ============================================================================
  static const double maxWidth = 448.0; // Max content width
  static const double bottomNavHeight = 64.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeExtraLarge = 40.0;
  static const double iconSizeXXL = 48.0;

  // ============================================================================
  // DEVICE CATEGORIES
  // ============================================================================
  static const List<String> deviceCategories = [
    'All',
    'Humidifiers',
    'Smart TV',
    'Smart Lighting',
  ];

  // ============================================================================
  // STORAGE KEYS (SharedPreferences)
  // ============================================================================
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyPurifierIsOn = 'purifier_is_on';
  static const String keyPurifierFanSpeed = 'purifier_fan_speed';
  static const String keyPurifierOscillation = 'purifier_oscillation';
  static const String keyPurifierTimer = 'purifier_timer';
  static const String keyPurifierAutoMode = 'purifier_auto_mode';
  static const String keyPurifierNightMode = 'purifier_night_mode';
  static const String keyPurifierAirFlow = 'purifier_air_flow';
  static const String keyPurifierRgbMode = 'purifier_rgb_mode';

  // ============================================================================
  // ANIMATION SCALES
  // ============================================================================
  static const double scaleOnTap = 0.95;
  static const double scaleOnHover = 1.05;
  static const double scaleNormal = 1.0;

  // ============================================================================
  // SHADOW BLUR RADII
  // ============================================================================
  static const double shadowBlurSmall = 10.0;
  static const double shadowBlurMedium = 24.0;
  static const double shadowBlurLarge = 40.0;
  static const double shadowBlurXL = 60.0;

  // ============================================================================
  // OPACITY VALUES
  // ============================================================================
  static const double opacityHigh = 0.9;
  static const double opacityMedium = 0.5;
  static const double opacityLow = 0.3;
  static const double opacityVeryLow = 0.1;
}


