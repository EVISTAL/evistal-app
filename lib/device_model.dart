// Cihazın çalışma modları
enum DeviceMode { kapali, mod1, mod2 }

// Cihazın ışık (renk) modları
enum LightMode { kapali, rgb, beyaz }

// Temel cihaz modeli
class Device {
  String name;
  DeviceMode currentMode;
  LightMode currentLightMode;

  Device({
    required this.name,
    this.currentMode = DeviceMode.kapali,
    this.currentLightMode = LightMode.kapali,
  });

  // Mod butonuna basınca çağrılır
  void nextMode() {
    switch (currentMode) {
      case DeviceMode.kapali:
        currentMode = DeviceMode.mod1;
        break;
      case DeviceMode.mod1:
        currentMode = DeviceMode.mod2;
        break;
      case DeviceMode.mod2:
        currentMode = DeviceMode.kapali;
        break;
    }
  }

  // Renk butonuna basınca çağrılır
  void nextLightMode() {
    switch (currentLightMode) {
      case LightMode.kapali:
        currentLightMode = LightMode.rgb;
        break;
      case LightMode.rgb:
        currentLightMode = LightMode.beyaz;
        break;
      case LightMode.beyaz:
        currentLightMode = LightMode.kapali;
        break;
    }
  }
}