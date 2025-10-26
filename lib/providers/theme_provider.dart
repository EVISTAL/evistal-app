import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// Tema Yönetimi Provider
/// Dark/Light mode geçişlerini ve durumu yönetir
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true; // Başlangıçta dark mode
  SharedPreferences? _prefs;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  /// SharedPreferences'ten tema tercihini yükle
  Future<void> _loadThemePreference() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs?.getBool(AppConstants.keyIsDarkMode) ?? true;
    notifyListeners();
  }

  /// Tema değiştir
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs?.setBool(AppConstants.keyIsDarkMode, _isDarkMode);
    notifyListeners();
  }

  /// Belirli bir tema ayarla
  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await _prefs?.setBool(AppConstants.keyIsDarkMode, _isDarkMode);
      notifyListeners();
    }
  }
}


