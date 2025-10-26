import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/device_model.dart';
import '../utils/constants.dart';

/// Cihaz Durumu Yönetimi Provider
/// Tüm cihazların ve özellikle My Purifier'ın durumunu yönetir
class DeviceProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  
  // My Purifier durumu
  PurifierState _purifierState = PurifierState();
  
  // Tüm cihazlar listesi
  List<DeviceModel> _devices = [];
  
  // Seçili kategori
  String _selectedCategory = 'All';

  // Getters
  PurifierState get purifierState => _purifierState;
  List<DeviceModel> get devices => _devices;
  String get selectedCategory => _selectedCategory;
  
  // Kategoriye göre filtrelenmiş cihazlar
  List<DeviceModel> get filteredDevices {
    if (_selectedCategory == 'All') {
      return _devices;
    }
    return _devices.where((device) => device.category == _selectedCategory).toList();
  }

  DeviceProvider() {
    _initializeDevices();
    _loadPurifierState();
  }

  /// Cihazları başlat
  void _initializeDevices() {
    _devices = [
      // ========== HUMIDIFIERS ==========
      DeviceModel(
        id: '1',
        name: 'EVISTAL\'s Humidifier',
        type: DeviceType.purifier,
        icon: LucideIcons.house,
        isActive: true,
        category: 'Humidifiers',
      ),
      DeviceModel(
        id: '3',
        name: 'Bedroom Humidifier',
        type: DeviceType.purifier,
        icon: LucideIcons.droplets,
        isActive: false,
        category: 'Humidifiers',
      ),
      
      // ========== SMART TV ==========
      DeviceModel(
        id: '4',
        name: 'Living Room TV',
        type: DeviceType.tv,
        icon: LucideIcons.tv,
        isActive: false,
        category: 'Smart TV',
      ),
      DeviceModel(
        id: '5',
        name: 'Bedroom TV',
        type: DeviceType.tv,
        icon: LucideIcons.monitor,
        isActive: false,
        category: 'Smart TV',
      ),
      DeviceModel(
        id: '6',
        name: 'Kitchen TV',
        type: DeviceType.tv,
        icon: LucideIcons.tv,
        isActive: false,
        category: 'Smart TV',
      ),
      
      // ========== SMART LIGHTING ==========
      DeviceModel(
        id: '7',
        name: 'Living Room Light',
        type: DeviceType.lighting,
        icon: LucideIcons.lightbulb,
        isActive: false,
        category: 'Smart Lighting',
      ),
      DeviceModel(
        id: '8',
        name: 'Bedroom Light',
        type: DeviceType.lighting,
        icon: LucideIcons.lightbulb,
        isActive: true,
        category: 'Smart Lighting',
      ),
      DeviceModel(
        id: '9',
        name: 'Kitchen Light',
        type: DeviceType.lighting,
        icon: LucideIcons.lightbulb,
        isActive: false,
        category: 'Smart Lighting',
      ),
    ];
  }

  /// SharedPreferences'ten purifier durumunu yükle
  Future<void> _loadPurifierState() async {
    _prefs = await SharedPreferences.getInstance();
    
    _purifierState = PurifierState(
      isOn: _prefs?.getBool(AppConstants.keyPurifierIsOn) ?? false,
      fanSpeed: _prefs?.getInt(AppConstants.keyPurifierFanSpeed) ?? 0,
      oscillation: _prefs?.getBool(AppConstants.keyPurifierOscillation) ?? false,
      timer: _prefs?.getString(AppConstants.keyPurifierTimer) ?? '15m',
      autoMode: _prefs?.getBool(AppConstants.keyPurifierAutoMode) ?? false,
      nightMode: _prefs?.getBool(AppConstants.keyPurifierNightMode) ?? false,
      airFlow: _prefs?.getBool(AppConstants.keyPurifierAirFlow) ?? false,
      rgbMode: _prefs?.getInt(AppConstants.keyPurifierRgbMode) ?? 0,
    );
    
    notifyListeners();
  }

  /// Purifier durumunu kaydet
  Future<void> _savePurifierState() async {
    await _prefs?.setBool(AppConstants.keyPurifierIsOn, _purifierState.isOn);
    await _prefs?.setInt(AppConstants.keyPurifierFanSpeed, _purifierState.fanSpeed);
    await _prefs?.setBool(AppConstants.keyPurifierOscillation, _purifierState.oscillation);
    await _prefs?.setString(AppConstants.keyPurifierTimer, _purifierState.timer);
    await _prefs?.setBool(AppConstants.keyPurifierAutoMode, _purifierState.autoMode);
    await _prefs?.setBool(AppConstants.keyPurifierNightMode, _purifierState.nightMode);
    await _prefs?.setBool(AppConstants.keyPurifierAirFlow, _purifierState.airFlow);
    await _prefs?.setInt(AppConstants.keyPurifierRgbMode, _purifierState.rgbMode);
  }

  // ============================================================================
  // PURIFIER KONTROL FONKSİYONLARI
  // ============================================================================

  /// Purifier'ı aç/kapat
  Future<void> togglePurifierPower() async {
    _purifierState = _purifierState.copyWith(isOn: !_purifierState.isOn);
    await _savePurifierState();
    notifyListeners();
  }

  /// Fan hızını değiştir (0 -> 1 -> 2 -> 0)
  Future<void> cycleFanSpeed() async {
    int newSpeed = (_purifierState.fanSpeed + 1) % 3;
    _purifierState = _purifierState.copyWith(fanSpeed: newSpeed);
    await _savePurifierState();
    notifyListeners();
  }

  /// Salınımı aç/kapat
  Future<void> toggleOscillation() async {
    _purifierState = _purifierState.copyWith(oscillation: !_purifierState.oscillation);
    await _savePurifierState();
    notifyListeners();
  }

  /// Auto mode'u aç/kapat
  Future<void> toggleAutoMode() async {
    _purifierState = _purifierState.copyWith(autoMode: !_purifierState.autoMode);
    await _savePurifierState();
    notifyListeners();
  }

  /// Night mode'u aç/kapat
  Future<void> toggleNightMode() async {
    _purifierState = _purifierState.copyWith(nightMode: !_purifierState.nightMode);
    await _savePurifierState();
    notifyListeners();
  }

  /// Air flow'u aç/kapat
  Future<void> toggleAirFlow() async {
    _purifierState = _purifierState.copyWith(airFlow: !_purifierState.airFlow);
    await _savePurifierState();
    notifyListeners();
  }

  /// RGB mode'u değiştir (0 -> 1 -> 2 -> 3 -> 0)
  Future<void> cycleRgbMode() async {
    int newMode = (_purifierState.rgbMode + 1) % 4;
    _purifierState = _purifierState.copyWith(rgbMode: newMode);
    await _savePurifierState();
    notifyListeners();
  }

  // ============================================================================
  // KATEGORİ YÖNETİMİ
  // ============================================================================

  /// Kategori seç
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // ============================================================================
  // CİHAZ YÖNETİMİ
  // ============================================================================

  /// Cihazı ID'ye göre getir
  DeviceModel? getDeviceById(String id) {
    try {
      return _devices.firstWhere((device) => device.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Cihaz durumunu değiştir
  void toggleDevice(String id) {
    int index = _devices.indexWhere((device) => device.id == id);
    if (index != -1) {
      _devices[index] = _devices[index].copyWith(isActive: !_devices[index].isActive);
      notifyListeners();
    }
  }
}

