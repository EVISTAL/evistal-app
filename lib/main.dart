import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/device_provider.dart';
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
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      
      // Renk Şeması
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightTextPrimary,
        secondary: AppColors.lightTextSecondary,
        surface: AppColors.lightCardBackground,
        error: Colors.red,
      ),
      
      // Metin Teması
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontSizeExtraLarge,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: AppConstants.fontSizeTitle,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeSubheadline,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextSecondary,
        ),
      ),
      
      // Icon Teması
      iconTheme: const IconThemeData(
        color: AppColors.lightIconActive,
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
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // Renk Şeması
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkTextPrimary,
        secondary: AppColors.darkTextSecondary,
        surface: AppColors.darkCardBackground,
        error: Colors.red,
      ),
      
      // Metin Teması
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontSizeExtraLarge,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: AppConstants.fontSizeTitle,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeSubheadline,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextSecondary,
        ),
      ),
      
      // Icon Teması
      iconTheme: const IconThemeData(
        color: AppColors.darkIconActive,
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
