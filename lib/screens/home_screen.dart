// lib/screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../device_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/ble/ble_service.dart';
import '../services/ble/ble_permissions.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Renkler (tarama ekranıyla uyumlu lacivert palet) ---
  static const kPrimary = Color(0xFF1D4ED8); // ana lacivert
  static const kPrimaryDark = Color(0xFF1E3A8A); // koyu lacivert
  static const kPanel = Color(0xFF0F172A); // içerik koyu zemin
  static const kCardBorder = Colors.white30;

  List<Device> devices = [
    Device(name: "Humidifier"),
    Device(name: "Lamba"),
    Device(name: "Fan"),
  ];

  String? _connectedDisplayName; // Örn: EVISTAL

  // ------------------ CRUD / UI helpers ------------------
  void addDevice(String name) => setState(() => devices.add(Device(name: name)));
  void removeDevice(int index) => setState(() => devices.removeAt(index));

  void _confirmDelete(int index) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Cihazı Sil',
      desc: 'Cihazı silmek istediğinizden emin misiniz?',
      btnCancelOnPress: () {},
      btnOkOnPress: () => removeDevice(index),
      btnCancelText: 'Hayır',
      btnOkText: 'Evet',
      btnOkColor: Colors.red,
      btnCancelColor: Colors.grey,
    ).show();
  }

  // ------------------ BLE helpers ------------------
  Future<bool> _ensureAdapterOn() async {
    final state = await BleService.instance.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Bluetooth Kapalı',
          desc: 'Lütfen Bluetooth\'u açın.',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      }
      return false;
    }
    return true;
  }

  Future<void> _startBleScan() async {
    final adapterOk = await _ensureAdapterOn();
    if (!adapterOk) return;

    final ok = await ensureBlePermissions();
    if (!ok) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'İzin Hatası',
          desc: 'Gerekli Bluetooth izinleri verilmedi.',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      }
      return;
    }
    await BleService.instance.startScan();

    if (mounted) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.scale,
        title: 'Tarama Başladı',
        desc: 'BLE cihazları taranıyor...',
        btnOkOnPress: () {},
        btnOkColor: kPrimary,
      ).show();
    }
    if (!mounted) return;

    _openScanSheet();
  }

  Future<void> _disconnectBle() async {
    try {
      final connected = await BleService.instance.connectedDevices();
      for (final d in connected) {
        await BleService.instance.disconnect(d);
      }
      if (mounted) {
        setState(() => _connectedDisplayName = null);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'Bağlantı Kesildi',
          desc: 'Cihaz bağlantısı başarıyla kesildi.',
          btnOkOnPress: () {},
          btnOkColor: Colors.green,
        ).show();
      }
    } catch (_) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Bağlantı Hatası',
          desc: 'Bağlantı kesilemedi.',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      }
    }
  }

  void _confirmDisconnectBle() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'Bağlantıyı Kes',
      desc: 'Bağlantıyı kesmek istediğinize emin misiniz?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async => _disconnectBle(),
      btnCancelText: 'Hayır',
      btnOkText: 'Evet',
      btnOkColor: kPrimary,
      btnCancelColor: Colors.grey,
    ).show();
  }

  Future<void> _connectEvistal() async {
    final adapterOk = await _ensureAdapterOn();
    if (!adapterOk) return;

    final ok = await ensureBlePermissions();
    if (!ok) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'İzin Hatası',
          desc: 'Gerekli Bluetooth izinleri verilmedi.',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      }
      return;
    }

    await BleService.instance.startScan(timeout: const Duration(seconds: 12));
    final completer = Completer<BluetoothDevice?>();
    late final StreamSubscription sub;
    const target = 'evistal';
    sub = BleService.instance.scanResults.listen((results) {
      for (final r in results) {
        final adName = r.advertisementData.advName.toLowerCase();
        final platform = r.device.platformName.toLowerCase();
        final name = adName.isNotEmpty ? adName : platform;
        if (name == target) {
          completer.complete(r.device);
          break;
        }
      }
    });
    final device =
        await completer.future.timeout(const Duration(seconds: 12), onTimeout: () => null);
    await sub.cancel();
    await BleService.instance.stopScan();

    if (device == null) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Cihaz Bulunamadı',
          desc: 'EVISTAL cihazı bulunamadı.',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      }
      return;
    }

    try {
      await BleService.instance.connect(device);
      if (mounted) {
        setState(() => _connectedDisplayName = 'EVISTAL');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'Bağlantı Başarılı',
          desc: 'EVISTAL cihazına başarıyla bağlandı.',
          btnOkOnPress: () {},
          btnOkColor: Colors.green,
        ).show();
      }
    } catch (_) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Bağlantı Başarısız',
          desc: 'EVISTAL cihazına bağlanılamadı.',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      }
    }
  }

  // ------------------ UI widgets ------------------
  Widget _buildPowerToggle(bool isOn) {
    return GestureDetector(
      onTap: () => isOn ? _confirmDisconnectBle() : _connectEvistal(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 68,
        height: 34,
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFF22C55E) : const Color(0xFFE11D48),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              alignment: isOn ? Alignment.centerLeft : Alignment.centerRight,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'ON', // metin yönünü knobun tersine koyuyoruz, animasyonda değişiyor
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: CircleAvatar(radius: 14, backgroundColor: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deviceCard(Device device, int index) {
    return GestureDetector(
      onTap: () {
        if (device.name == "Humidifier") {
          Navigator.pushNamed(context, '/humidifier', arguments: device);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kPrimary.withOpacity(0.85),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: kCardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.devices_other, size: 46, color: Colors.white),
                const Spacer(),
                Text(
                  device.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                color: Colors.white12,
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Sil',
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _confirmDelete(index),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: device.name == 'Humidifier'
                  ? _buildPowerToggle(_connectedDisplayName != null)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ BUILD ------------------
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimary, kPrimaryDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              // --- Custom Header ---
              Container(
                padding: EdgeInsets.fromLTRB(16, top > 0 ? 0 : 12, 16, 12),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Devices',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .2,
                      ),
                    ),
                    if (_connectedDisplayName != null)
                      Text(
                        'Bağlı: ${_connectedDisplayName!}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),

              // --- İçerik Paneli ---
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: kPanel,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                    child: Column(
                      children: [
                        // Scan BLE butonu
                        Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 380),
                            child: ElevatedButton.icon(
                              onPressed: _startBleScan,
                              icon: const Icon(Icons.search),
                              label: const Text("Scan BLE"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimary,
                                foregroundColor: Colors.white,
                                elevation: 6,
                                shadowColor: Colors.black45,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: const BorderSide(color: kCardBorder),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Cihaz Grid
                        Expanded(
                          child: GridView.builder(
                            itemCount: devices.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) =>
                                _deviceCard(devices[index], index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ BLE Scan Modal (lacivert) ------------------
  void _openScanSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        const targetNameLower = 'evistal';
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: kPrimaryDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5)),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kPrimary.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kPrimary.withOpacity(0.40),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.bluetooth_searching,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'EVISTAL Tarama',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              StreamBuilder<List<ScanResult>>(
                                stream: BleService.instance.scanResults,
                                builder: (context, snap) {
                                  final results = snap.data ?? const [];
                                  final Map<String, ScanResult> unique = {
                                    for (final r in results) r.device.remoteId.str: r
                                  };
                                  final list = unique.values.toList();
                                  final filteredCount = list.where((r) {
                                    final adName = r.advertisementData.advName;
                                    final platform = r.device.platformName;
                                    final name = adName.isNotEmpty ? adName : platform;
                                    return name.toLowerCase() == targetNameLower;
                                  }).length;
                                  return Text(
                                    '$filteredCount cihaz bulundu',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<bool>(
                          stream: BleService.instance.isScanning,
                          builder: (context, snap) {
                            final scanning = snap.data ?? false;
                            return Container(
                              decoration: BoxDecoration(
                                color: (scanning ? Colors.red : Colors.green)
                                    .withOpacity(0.8),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                tooltip:
                                    scanning ? 'Taramayı durdur' : 'Yeniden tara',
                                icon: Icon(
                                  scanning ? Icons.stop : Icons.refresh,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  if (scanning) {
                                    await BleService.instance.stopScan();
                                  } else {
                                    await BleService.instance.startScan();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // DURUM
                  StreamBuilder<bool>(
                    stream: BleService.instance.isScanning,
                    builder: (context, snap) {
                      final scanning = snap.data ?? false;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: kPrimary.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: scanning ? Colors.green : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              scanning ? 'Taranıyor...' : 'Tarama durduruldu',
                              style: TextStyle(
                                color: scanning ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // LİSTE
                  Expanded(
                    child: StreamBuilder<List<ScanResult>>(
                      stream: BleService.instance.scanResults,
                      builder: (context, snapshot) {
                        final results = snapshot.data ?? const [];
                        final Map<String, ScanResult> unique = {
                          for (final r in results) r.device.remoteId.str: r
                        };
                        final list = unique.values.toList();

                        final filtered = list.where((r) {
                          final adName = r.advertisementData.advName;
                          final platform = r.device.platformName;
                          final name = adName.isNotEmpty ? adName : platform;
                          return name.toLowerCase() == targetNameLower;
                        }).toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: kPrimary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bluetooth_disabled,
                                      size: 60,
                                      color: Colors.white.withOpacity(0.6)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Cihaz Bulunamadı',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'EVISTAL cihazınızı açık olduğundan emin olun',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final r = filtered[i];
                            final d = r.device;
                            final adName = r.advertisementData.advName;
                            final platform = d.platformName;
                            final id = d.remoteId.str;
                            final name = adName.isNotEmpty
                                ? adName
                                : (platform.isNotEmpty ? platform : id);
                            final uuids = r.advertisementData.serviceUuids
                                .map((g) => g.toString())
                                .toList();

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: kPrimary.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(20),
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: kPrimaryDark,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(Icons.device_hub,
                                      color: Colors.white, size: 24),
                                ),
                                title: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.signal_cellular_alt,
                                              size: 16,
                                              color: Colors.white
                                                  .withOpacity(0.7)),
                                          const SizedBox(width: 4),
                                          Text(
                                            'RSSI: ${r.rssi}',
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.8),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (uuids.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'UUIDs: ${uuids.length} servis',
                                          style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(0.6),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () async {
                                    try {
                                      await BleService.instance.connect(d);
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                      if (mounted) {
                                        setState(() =>
                                            _connectedDisplayName = name);
                                        AwesomeDialog(
                                          context: this.context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.scale,
                                          title: 'Bağlantı Başarılı',
                                          desc:
                                              '$name cihazına başarıyla bağlandı.',
                                          btnOkOnPress: () {},
                                          btnOkColor: Colors.green,
                                        ).show();

                                        final humidifier = devices.firstWhere(
                                          (e) => e.name == 'Humidifier',
                                          orElse: () => devices.first,
                                        );
                                        Navigator.pushNamed(
                                          this.context,
                                          '/humidifier',
                                          arguments: humidifier,
                                        );
                                      }
                                    } catch (_) {
                                      if (mounted) {
                                        AwesomeDialog(
                                          context: this.context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.scale,
                                          title: 'Bağlantı Başarısız',
                                          desc:
                                              '$name cihazına bağlanılamadı.',
                                          btnOkOnPress: () {},
                                          btnOkColor: Colors.red,
                                        ).show();
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Bağlan',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
