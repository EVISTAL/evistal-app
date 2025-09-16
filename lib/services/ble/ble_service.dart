import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  BleService._();
  static final BleService instance = BleService._();

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? writeCharacteristic;

  // Adaptör (Bluetooth) durum akışı
  Stream<BluetoothAdapterState> get adapterState => FlutterBluePlus.adapterState;

  // Tarama sonuçları akışı (ScanResult listesi)
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  // Şu an tarama yapılıyor mu?
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  Future<void> startScan({Duration timeout = const Duration(seconds: 20)}) async {
    if (await FlutterBluePlus.isScanning.first) {
      await FlutterBluePlus.stopScan();
    }
    await FlutterBluePlus.startScan(
      timeout: timeout,
      androidScanMode: AndroidScanMode.lowLatency,
    );
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Future<void> connect(BluetoothDevice device) async {
    final state = await device.connectionState.first;
    if (state != BluetoothConnectionState.connected) {
      await device.connect(timeout: const Duration(seconds: 10));
    }
    await setupBleCharacteristics(device); // Bağlantıdan sonra characteristic'leri ayarla
  }

  Future<void> setupBleCharacteristics(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    const String serviceUuid = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
    const String writeCharUuid = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
    const String notifyCharUuid = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

    BluetoothCharacteristic? writeChar;
    BluetoothCharacteristic? notifyChar;

    for (var service in services) {
      if (service.uuid.toString().toLowerCase() == serviceUuid) {
        for (var c in service.characteristics) {
          if (c.uuid.toString().toLowerCase() == writeCharUuid) {
            writeChar = c;
          }
          if (c.uuid.toString().toLowerCase() == notifyCharUuid) {
            notifyChar = c;
          }
        }
      }
    }

    if (writeChar == null) {
      throw Exception("Write characteristic (RX) bulunamadı!");
    }

    BleService.instance.connectedDevice = device;
    BleService.instance.writeCharacteristic = writeChar;

    if (notifyChar != null) {
      await notifyChar.setNotifyValue(true);
      notifyChar.value.listen((value) {
        final gelenMesaj = String.fromCharCodes(value);
        // ignore: avoid_print
        print("ESP32'den gelen mesaj: $gelenMesaj");
      });
    }
  }

  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }

  Future<List<BluetoothDevice>> connectedDevices() async {
    return FlutterBluePlus.connectedDevices;
  }

  static Future<void> sendCommand(String command) async {
    assert(() {
      // ignore: avoid_print
      print('[BLE] Gönderilen komut: $command');
      return true;
    }());
    final service = BleService.instance;
    if (service.connectedDevice == null || service.writeCharacteristic == null) {
      throw Exception('Cihaza bağlı değil veya characteristic tanımlı değil!');
    }
    await service.writeCharacteristic!.write(command.codeUnits, withoutResponse: true);
  }
}
