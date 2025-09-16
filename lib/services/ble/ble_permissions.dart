import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

/// BLE tarama/bağlantı için gerekli izinleri ister.
/// Android 12+ için bluetoothScan/bluetoothConnect,
/// Android 6–11 için konum izni gereklidir.
Future<bool> ensureBlePermissions() async {
  if (Platform.isAndroid) {
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();
    // Eski Android sürümleri için konum izni gerekir
    final location = await Permission.locationWhenInUse.request();

    final scanGranted = scan.isGranted || scan.isLimited || location.isGranted;
    final connectGranted = connect.isGranted || connect.isLimited;

    return scanGranted && connectGranted;
  }

  // iOS'ta permission_handler, sistem diyaloglarını yönetir; ekstra bir şey gerekmez
  return true;
}

