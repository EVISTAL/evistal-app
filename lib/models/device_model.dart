import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';

/// Cihaz Tipleri
enum DeviceType {
  purifier,
  airConditioner,
  tv,
  lighting,
  speaker,
}

/// Cihaz Modeli
/// Tüm akıllı ev cihazlarının temel yapısı
class DeviceModel {
  final String id;
  final String name;
  final DeviceType type;
  final IconData icon;
  final bool isActive;
  final String category; // "Living", "Bedroom", "Outdoor"

  DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.isActive,
    required this.category,
  });

  /// Icon'u device type'a göre döndürür
  static IconData getIconForType(DeviceType type) {
    switch (type) {
      case DeviceType.purifier:
        return LucideIcons.house;
      case DeviceType.airConditioner:
        return LucideIcons.house;
      case DeviceType.tv:
        return LucideIcons.tv;
      case DeviceType.lighting:
        return LucideIcons.lightbulb;
      case DeviceType.speaker:
        return LucideIcons.speaker;
    }
  }

  DeviceModel copyWith({
    String? id,
    String? name,
    DeviceType? type,
    IconData? icon,
    bool? isActive,
    String? category,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      category: category ?? this.category,
    );
  }
}

/// Hava Temizleyici Durumu
/// My Purifier cihazının tüm kontrol durumlarını içerir
class PurifierState {
  final bool isOn;
  final int fanSpeed; // 0, 1, 2
  final bool oscillation;
  final String timer; // "15m"
  final bool autoMode;
  final bool nightMode;
  final bool airFlow;
  final int rgbMode; // 0, 1, 2, 3

  PurifierState({
    this.isOn = false,
    this.fanSpeed = 0,
    this.oscillation = false,
    this.timer = '15m',
    this.autoMode = false,
    this.nightMode = false,
    this.airFlow = false,
    this.rgbMode = 0,
  });

  PurifierState copyWith({
    bool? isOn,
    int? fanSpeed,
    bool? oscillation,
    String? timer,
    bool? autoMode,
    bool? nightMode,
    bool? airFlow,
    int? rgbMode,
  }) {
    return PurifierState(
      isOn: isOn ?? this.isOn,
      fanSpeed: fanSpeed ?? this.fanSpeed,
      oscillation: oscillation ?? this.oscillation,
      timer: timer ?? this.timer,
      autoMode: autoMode ?? this.autoMode,
      nightMode: nightMode ?? this.nightMode,
      airFlow: airFlow ?? this.airFlow,
      rgbMode: rgbMode ?? this.rgbMode,
    );
  }

  /// Map'e çevir (SharedPreferences için)
  Map<String, dynamic> toMap() {
    return {
      'isOn': isOn,
      'fanSpeed': fanSpeed,
      'oscillation': oscillation,
      'timer': timer,
      'autoMode': autoMode,
      'nightMode': nightMode,
      'airFlow': airFlow,
      'rgbMode': rgbMode,
    };
  }

  /// Map'ten oluştur
  factory PurifierState.fromMap(Map<String, dynamic> map) {
    return PurifierState(
      isOn: map['isOn'] ?? false,
      fanSpeed: map['fanSpeed'] ?? 0,
      oscillation: map['oscillation'] ?? false,
      timer: map['timer'] ?? '15m',
      autoMode: map['autoMode'] ?? false,
      nightMode: map['nightMode'] ?? false,
      airFlow: map['airFlow'] ?? false,
      rgbMode: map['rgbMode'] ?? 0,
    );
  }
}

