import 'dart:async';
import 'package:flutter/material.dart';
import '../device_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/ble/ble_service.dart';
import '../services/ble/ble_permissions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Device> devices = [
    Device(name: "Humidifier"),
    Device(name: "Lamba"),
    Device(name: "Fan"),
  ];

  String? _connectedDisplayName; // Örn: EVISTAL

  void addDevice(String name) {
    setState(() {
      devices.add(Device(name: name));
    });
  }

  void removeDevice(int index) {
    setState(() {
      devices.removeAt(index);
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cihazı Sil'),
        content: const Text('Cihazı silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hayır'),
          ),
          TextButton(
            onPressed: () {
              removeDevice(index);
              Navigator.of(context).pop();
            },
            child: const Text('Evet'),
          ),
        ],
      ),
    );
  }

  Future<bool> _ensureAdapterOn() async {
    final state = await BleService.instance.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bluetooth kapalı. Lütfen Bluetooth’u açın.')),
        );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gerekli Bluetooth izinleri verilmedi.')),
        );
      }
      return;
    }
    await BleService.instance.startScan();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Taramaya başlandı')),
      );
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
        setState(() {
          _connectedDisplayName = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bağlantı kesildi')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bağlantı kesilemedi')),
        );
      }
    }
  }

  void _confirmDisconnectBle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bağlantıyı Kes'),
        content: const Text('Bağlantıyı kesmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hayır'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _disconnectBle();
            },
            child: const Text('Evet'),
          ),
        ],
      ),
    );
  }

  Future<void> _connectEvistal() async {
    final adapterOk = await _ensureAdapterOn();
    if (!adapterOk) return;

    final ok = await ensureBlePermissions();
    if (!ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gerekli Bluetooth izinleri verilmedi.')),
        );
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
    final device = await completer.future.timeout(const Duration(seconds: 12), onTimeout: () => null);
    await sub.cancel();
    await BleService.instance.stopScan();

    if (device == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cihaz bulunamadı (EVISTAL)')),
        );
      }
      return;
    }

    try {
      await BleService.instance.connect(device);
      if (mounted) {
        setState(() {
          _connectedDisplayName = 'EVISTAL';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bağlandı: EVISTAL')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bağlantı başarısız')),
        );
      }
    }
  }

  void _openScanSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        const targetNameLower = 'evistal';
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bluetooth, color: Color(0xFF13007F)),
                    const SizedBox(width: 8),
                    const Text(
                      'Evistal',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    StreamBuilder<List<ScanResult>>(
                      stream: BleService.instance.scanResults,
                      builder: (context, snap) {
                        final results = snap.data ?? const [];
                        final Map<String, ScanResult> unique = {};
                        for (final r in results) {
                          unique[r.device.remoteId.str] = r;
                        }
                        final list = unique.values.toList();
                        final filteredCount = list.where((r) {
                          final adName = r.advertisementData.advName;
                          final platform = r.device.platformName;
                          final name = adName.isNotEmpty ? adName : platform;
                          return name.toLowerCase() == targetNameLower;
                        }).length;
                        return Text('Bulunan: $filteredCount');
                      },
                    ),
                    const SizedBox(width: 8),
                    StreamBuilder<bool>(
                      stream: BleService.instance.isScanning,
                      builder: (context, snap) {
                        final scanning = snap.data ?? false;
                        return Row(
                          children: [
                            if (scanning) ...[
                              const SizedBox(width: 8),
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 8),
                              const Text('Taranıyor...'),
                            ],
                            IconButton(
                              tooltip: scanning ? 'Taramayı durdur' : 'Yeniden tara',
                              icon: Icon(scanning ? Icons.stop_circle_outlined : Icons.refresh),
                              onPressed: () async {
                                if (scanning) {
                                  await BleService.instance.stopScan();
                                } else {
                                  await BleService.instance.startScan();
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    avatar: Icon(Icons.filter_alt_outlined, size: 18),
                    label: Text('Filtre: EVISTAL (sabit)'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: StreamBuilder<List<ScanResult>>(
                    stream: BleService.instance.scanResults,
                    builder: (context, snapshot) {
                      final results = snapshot.data ?? const [];
                      final Map<String, ScanResult> unique = {};
                      for (final r in results) {
                        unique[r.device.remoteId.str] = r;
                      }
                      final list = unique.values.toList();

                      final filtered = list.where((r) {
                        final adName = r.advertisementData.advName;
                        final platform = r.device.platformName;
                        final name = adName.isNotEmpty ? adName : platform;
                        return name.toLowerCase() == targetNameLower;
                      }).toList();

                      if (filtered.isEmpty) {
                        return const Center(child: Text('Eşleşen cihaz bulunamadı.'));
                      }

                      return ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final r = filtered[i];
                          final d = r.device;
                          final adName = r.advertisementData.advName;
                          final platform = d.platformName;
                          final id = d.remoteId.str;
                          final name = adName.isNotEmpty ? adName : (platform.isNotEmpty ? platform : id);
                          final uuids = r.advertisementData.serviceUuids.map((g) => g.toString()).toList();
                          return ListTile(
                            leading: const Icon(Icons.device_hub, color: Color(0xFF13007F)),
                            title: Text(name),
                            subtitle: Text(uuids.isNotEmpty ? 'RSSI: ${r.rssi} • UUIDs: ${uuids.join(', ')}' : 'RSSI: ${r.rssi}'),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await BleService.instance.connect(d);
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                  if (mounted) {
                                    setState(() {
                                      _connectedDisplayName = name;
                                    });
                                    ScaffoldMessenger.of(this.context).showSnackBar(
                                      SnackBar(content: Text('Bağlandı: $name')),
                                    );
                                    final humidifier = devices.firstWhere(
                                      (e) => e.name == 'Humidifier',
                                      orElse: () => devices.first,
                                    );
                                    Navigator.pushNamed(this.context, '/humidifier', arguments: humidifier);
                                  }
                                } catch (_) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(this.context).showSnackBar(
                                      SnackBar(content: Text('Bağlantı başarısız: $name')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Bağlan'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPowerToggle(bool isOn) {
    return GestureDetector(
      onTap: () {
        if (isOn) {
          _confirmDisconnectBle();
        } else {
          _connectEvistal();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 64,
        height: 32,
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFF2ECC71) : Colors.red,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Stack(
          children: [
            // Metni topuzun ters tarafına hizala ki üstünü kapatmasın
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: isOn ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  isOn ? 'ON' : 'OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            // Topuz
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF85C9FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('My Devices'),
            if (_connectedDisplayName != null)
              Text(
                'Bağlı: ${_connectedDisplayName!}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cihaz Tara',
            icon: const Icon(Icons.search),
            onPressed: _startBleScan,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _startBleScan,
                  icon: const Icon(Icons.search),
                  label: const Text("Scan BLE"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF85C9FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: devices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return GestureDetector(
                    onTap: () {
                      if (device.name == "Humidifier") {
                        Navigator.pushNamed(context, '/humidifier', arguments: device);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF85C9FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.devices_other,
                                size: 48,
                                color: Colors.white,
                              ),
                              const Spacer(),
                              Text(
                                device.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () => _confirmDelete(index),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 
 