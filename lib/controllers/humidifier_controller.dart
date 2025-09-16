import 'package:flutter/material.dart';
import '../services/ble/ble_service.dart';

class HumidifierController extends ChangeNotifier {
  int _colorMode = 0; // 0: kapalı, 1: rainbow, 2: rgb, 3: beyaz
  int _diffuserMode = 0; // 0: kapalı, 1: mod1, 2: mod2

  int get colorMode => _colorMode;
  int get diffuserMode => _diffuserMode;

  void nextColorMode() {
    _colorMode = (_colorMode + 1) % 4; // 0-1-2-3-0 döngüsü
    String command = 'AT+RMOD=$_colorMode';
    BleService.sendCommand(command); // BLE'ye string olarak gönder
    notifyListeners();
  }

  void nextDiffuserMode() {
    _diffuserMode = (_diffuserMode + 1) % 3; // 0-1-2-0 döngüsü
    String command = 'AT+DMOD=$_diffuserMode';
    BleService.sendCommand(command); // BLE'ye string olarak gönder
    notifyListeners();
  }
}
