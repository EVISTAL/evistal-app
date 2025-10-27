import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/device_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'purifier_control_screen.dart';

/// BLE Cihaz Tarama Ekranı
/// Mock BLE cihazlarını gösterir ve bağlantı sağlar
class BLEScanScreen extends StatefulWidget {
  const BLEScanScreen({super.key});

  @override
  State<BLEScanScreen> createState() => _BLEScanScreenState();
}

class _BLEScanScreenState extends State<BLEScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  List<BleMockDevice> _devices = [];
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Mock cihazları 1 saniye sonra göster
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _devices = _generateMockDevices();
        });
      }
    });

    // 3 saniye sonra taramayı durdur
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  List<BleMockDevice> _generateMockDevices() {
    final random = Random();
    return List.generate(5, (index) {
      final hexId = (random.nextInt(0xFFFF)).toRadixString(16).toUpperCase().padLeft(4, '0');
      final rssi = -45 - (random.nextInt(40)); // -45 to -85 dBm
      return BleMockDevice(
        name: 'EVISTAL-$hexId',
        address: '${random.nextInt(256).toRadixString(16).toUpperCase().padLeft(2, '0')}:'
            '${random.nextInt(256).toRadixString(16).toUpperCase().padLeft(2, '0')}:'
            '${random.nextInt(256).toRadixString(16).toUpperCase().padLeft(2, '0')}:'
            '${random.nextInt(256).toRadixString(16).toUpperCase().padLeft(2, '0')}:'
            '${random.nextInt(256).toRadixString(16).toUpperCase().padLeft(2, '0')}:'
            '${random.nextInt(256).toRadixString(16).toUpperCase().padLeft(2, '0')}',
        rssi: rssi,
      );
    });
  }

  void _rescan() {
    setState(() {
      _isScanning = true;
      _devices = [];
    });

    _scanController.repeat();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _devices = _generateMockDevices();
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  void _connectToDevice(BleMockDevice device) {
    final deviceProvider = context.read<DeviceProvider>();
    
    // Cihazı açık duruma getir
    if (!deviceProvider.purifierState.isOn) {
      deviceProvider.togglePurifierPower();
    }

    // Bağlantı animasyonu göster
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _ConnectingDialog(),
    );

    // 2 saniye sonra kontrol ekranına git
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Dialog'u kapat
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const PurifierControlScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; // Temadan renkleri al

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.maxWidth,
            ),
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Tarama Görseli
                _buildScanningVisual(),

                const SizedBox(height: AppConstants.spacing2Xl),

                // Cihaz Listesi
                Expanded(
                  child: _buildDeviceList(),
                ),

                // Rescan Butonu
                _buildRescanButton(),

                const SizedBox(height: AppConstants.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colors = context.colors;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.radiusXl),
      child: Row(
        children: [
          // Geri Butonu
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cardBackgroundAlt,
              ),
              child: Icon(
                LucideIcons.chevronLeft,
                size: AppConstants.iconSizeMedium,
                color: colors.textPrimary,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: AppConstants.durationNormal.ms)
              .scale(begin: const Offset(0.8, 0.8)),

          const SizedBox(width: AppConstants.spacingLg),

          // Başlık
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BLE Device Scan',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                )
                    .animate()
                    .fadeIn(duration: AppConstants.durationNormal.ms)
                    .slideX(begin: -0.2, duration: AppConstants.durationNormal.ms),
                const SizedBox(height: 4),
                Text(
                  _isScanning
                      ? 'Searching for EVISTAL devices...'
                      : 'Found ${_devices.length} device${_devices.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSubheadline,
                    color: colors.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(duration: AppConstants.durationNormal.ms, delay: 100.ms)
                    .slideX(begin: -0.2, duration: AppConstants.durationNormal.ms),
              ],
            ),
          ),

          // Bluetooth İkon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: colors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              LucideIcons.bluetooth,
              size: AppConstants.iconSizeMedium,
              color: isDarkMode ? colors.textPrimary : Colors.white,
            ),
          )
              .animate()
              .fadeIn(duration: AppConstants.durationNormal.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  Widget _buildScanningVisual() {
    final colors = context.colors;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      height: 200,
      child: AnimatedBuilder(
        animation: _scanController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Dış Dalga (En büyük)
              if (_isScanning)
                Container(
                  width: 200 + (_scanController.value * 80),
                  height: 200 + (_scanController.value * 80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.textPrimary
                          .withOpacity(0.3 - (_scanController.value * 0.3)),
                      width: 2,
                    ),
                  ),
                ),

              // Orta Dalga
              if (_isScanning)
                Container(
                  width: 160 + (_scanController.value * 60),
                  height: 160 + (_scanController.value * 60),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.textPrimary
                          .withOpacity(0.5 - (_scanController.value * 0.5)),
                      width: 2,
                    ),
                  ),
                ),

              // İç Dalga
              if (_isScanning)
                Container(
                  width: 120 + (_scanController.value * 40),
                  height: 120 + (_scanController.value * 40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.textPrimary
                          .withOpacity(0.7 - (_scanController.value * 0.7)),
                      width: 2,
                    ),
                  ),
                ),

              // Merkez - Radar Görseli
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.textPrimary.withOpacity(0.3),
                      colors.textPrimary.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.textPrimary.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _isScanning ? LucideIcons.radio : LucideIcons.check,
                    size: 48,
                    color: isDarkMode ? Colors.white : colors.primary,
                  ),
                ),
              )
                  .animate(onPlay: (controller) => _isScanning ? controller.repeat() : null)
                  .scale(
                    duration: 2000.ms,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.1, 1.1),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    duration: 2000.ms,
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeInOut,
                  ),
            ],
          );
        },
      ),
    )
        .animate()
        .fadeIn(duration: AppConstants.durationNormal.ms, delay: 200.ms)
        .scale(begin: const Offset(0.8, 0.8), delay: 200.ms);
  }

  Widget _buildDeviceList() {
    final colors = context.colors;
    
    if (_devices.isEmpty && _isScanning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              'Scanning...',
              style: TextStyle(
                fontSize: AppConstants.fontSizeBody,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_devices.isEmpty && !_isScanning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.searchX,
              size: 64,
              color: colors.textSecondary,
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              'No devices found',
              style: TextStyle(
                fontSize: AppConstants.fontSizeBody,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Try rescanning',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSubheadline,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.radiusXl),
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        final device = _devices[index];
        return _buildDeviceCard(device, index);
      },
    );
  }

  Widget _buildDeviceCard(BleMockDevice device, int index) {
    final colors = context.colors;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final signalStrength = _getSignalStrength(device.rssi);
    final signalColor = _getSignalColor(device.rssi);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingLg),
      padding: const EdgeInsets.all(AppConstants.radiusXl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        color: colors.cardBackgroundAlt,
        border: Border.all(
          color: colors.textPrimary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // BLE İkon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary.withOpacity(0.8),
                  colors.primaryAccent.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              LucideIcons.bluetooth,
              color: isDarkMode ? colors.textPrimary : Colors.white,
              size: 28,
            ),
          )
              .animate(onPlay: (controller) => _isScanning ? controller.repeat() : null)
              .scale(
                duration: 1500.ms,
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.1, 1.1),
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                duration: 1500.ms,
                begin: const Offset(1.1, 1.1),
                end: const Offset(1.0, 1.0),
                curve: Curves.easeInOut,
              ),

          const SizedBox(width: AppConstants.spacingLg),

          // Cihaz Bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeBody,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  device.address,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeCaption,
                    color: colors.textSecondary,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                // Sinyal Gücü
                Row(
                  children: [
                    ...List.generate(5, (i) {
                      return Container(
                        width: 6,
                        height: 16 - (i * 2.0),
                        margin: const EdgeInsets.only(right: 3),
                        decoration: BoxDecoration(
                          color: i < signalStrength
                              ? signalColor
                              : (isDarkMode
                                  ? colors.cardBackground
                                  : colors.gray300),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                    const SizedBox(width: AppConstants.spacingSm),
                    Text(
                      '${device.rssi} dBm',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeCaption,
                        color: signalColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Connect Butonu
          GestureDetector(
            onTap: () => _connectToDevice(device),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.radiusMd,
                vertical: AppConstants.spacingSm,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                gradient: colors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Connect',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSubheadline,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? colors.textPrimary : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppConstants.durationNormal.ms, delay: (100 * index).ms)
        .slideX(
          begin: 0.3,
          duration: AppConstants.durationNormal.ms,
          delay: (100 * index).ms,
        );
  }

  Widget _buildRescanButton() {
    final colors = context.colors;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.radiusXl),
      child: GestureDetector(
        onTap: _isScanning ? null : _rescan,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppConstants.radiusMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
            color: _isScanning ? colors.cardBackground : colors.cardBackgroundAlt,
            border: Border.all(
              color: colors.textPrimary.withOpacity(_isScanning ? 0.1 : 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.refreshCw,
                size: AppConstants.iconSizeMedium,
                color: _isScanning ? colors.textSecondary : colors.textPrimary,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                _isScanning ? 'Scanning...' : 'Rescan Devices',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeBody,
                  fontWeight: FontWeight.w600,
                  color: _isScanning ? colors.textSecondary : colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getSignalStrength(int rssi) {
    if (rssi >= -50) return 5;
    if (rssi >= -60) return 4;
    if (rssi >= -70) return 3;
    if (rssi >= -80) return 2;
    return 1;
  }

  Color _getSignalColor(int rssi) {
    final colors = context.colors;
    
    // Monochrome theme - using opacity to show signal strength
    // Strong signal = full opacity, weak signal = lower opacity
    if (rssi >= -60) return colors.textPrimary; // Strong - Full brightness
    if (rssi >= -70) return colors.textPrimary.withOpacity(0.8); // Good
    if (rssi >= -80) return colors.textPrimary.withOpacity(0.6); // Medium
    return colors.textPrimary.withOpacity(0.4); // Weak
  }
}

/// Bağlantı Dialog'u
class _ConnectingDialog extends StatelessWidget {
  const _ConnectingDialog();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacing2Xl),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          color: colors.cardBackgroundAlt,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: colors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                LucideIcons.bluetooth,
                color: isDarkMode ? colors.textPrimary : Colors.white,
                size: 40,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  duration: 1500.ms,
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.2, 1.2),
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  duration: 1500.ms,
                  begin: const Offset(1.2, 1.2),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: AppConstants.spacing2Xl),
            Text(
              'Connecting...',
              style: TextStyle(
                fontSize: AppConstants.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Please wait',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSubheadline,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mock BLE Cihaz Modeli
class BleMockDevice {
  final String name;
  final String address;
  final int rssi;

  BleMockDevice({
    required this.name,
    required this.address,
    required this.rssi,
  });
}
