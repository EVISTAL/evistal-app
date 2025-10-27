import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/device_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/device_selection_screen.dart';
import 'utils/colors.dart';
import 'utils/constants.dart';

void main() {
  // Sistem UI ayarları
  WidgetsFlutterBinding.ensureInitialized();
  
  // Status bar ve navigation bar'ı şeffaf yap
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const EvistalApp());
}

/// EVISTAL Ana Uygulama
class EvistalApp extends StatelessWidget {
  const EvistalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Tema Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        // Cihaz Provider
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        
        // Hava Durumu Provider
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'EVISTAL Smart Home',
            debugShowCheckedModeBanner: false,
            
            // Tema ayarları
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            
            // Ana ekran
            home: const DeviceSelectionScreen(),
          );
        },
      ),
    );
  }

  /// Light Tema
  ThemeData _buildLightTheme() {
    const colorScheme = AppColorScheme.light;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colorScheme.background,
      
      // Custom Color Extension (Merkezi tema sistemi)
      extensions: const <ThemeExtension<dynamic>>[
        AppColorScheme.light,
      ],
      
      // Renk Şeması
      colorScheme: ColorScheme.light(
        primary: colorScheme.textPrimary,
        secondary: colorScheme.textSecondary,
        surface: colorScheme.cardBackground,
        error: Colors.red,
      ),
      
      // Metin Teması
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontSizeExtraLarge,
          fontWeight: FontWeight.w700,
          color: colorScheme.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: AppConstants.fontSizeTitle,
          fontWeight: FontWeight.w500,
          color: colorScheme.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontWeight: FontWeight.w400,
          color: colorScheme.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeSubheadline,
          fontWeight: FontWeight.w400,
          color: colorScheme.textSecondary,
        ),
      ),
      
      // Icon Teması
      iconTheme: IconThemeData(
        color: colorScheme.iconActive,
        size: AppConstants.iconSizeMedium,
      ),
      
      // Geçiş Animasyonu
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Dark Tema
  ThemeData _buildDarkTheme() {
    const colorScheme = AppColorScheme.dark;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colorScheme.background,
      
      // Custom Color Extension (Merkezi tema sistemi)
      extensions: const <ThemeExtension<dynamic>>[
        AppColorScheme.dark,
      ],
      
      // Renk Şeması
      colorScheme: ColorScheme.dark(
        primary: colorScheme.textPrimary,
        secondary: colorScheme.textSecondary,
        surface: colorScheme.cardBackground,
        error: Colors.red,
      ),
      
      // Metin Teması
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontSizeExtraLarge,
          fontWeight: FontWeight.w700,
          color: colorScheme.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: AppConstants.fontSizeTitle,
          fontWeight: FontWeight.w500,
          color: colorScheme.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontWeight: FontWeight.w400,
          color: colorScheme.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeSubheadline,
          fontWeight: FontWeight.w400,
          color: colorScheme.textSecondary,
        ),
      ),
      
      // Icon Teması
      iconTheme: IconThemeData(
        color: colorScheme.iconActive,
        size: AppConstants.iconSizeMedium,
      ),
      
      // Geçiş Animasyonu
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
