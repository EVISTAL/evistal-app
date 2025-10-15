// lib/screens/humidifier_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/humidifier_controller.dart';
import '../device_model.dart';

class HumidifierScreen extends StatelessWidget {
  final Device device;
  const HumidifierScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HumidifierController(),
      child: _HumidifierScreenBody(device: device),
    );
  }
}

class _HumidifierScreenBody extends StatelessWidget {
  final Device device;
  const _HumidifierScreenBody({required this.device});

  // 🎨 Palet (lacivert tema)
  static const kBg       = Color(0xFFF2F8FF);
  static const kPrimary  = Color(0xFF1D4ED8); // İSTENEN TON
  static const kDark     = Color(0xFF1E3A8A);
  static const kTextDeep = Color(0xFF002686);
  static const kAccent   = Color(0xFF13007F);

  String _colorModeLabel(int mode) {
    switch (mode) {
      case 1: return 'Rainbow';
      case 2: return 'RGB';
      case 3: return 'Beyaz';
      default: return 'Kapalı';
    }
  }

  String _diffuserModeLabel(int mode) {
    switch (mode) {
      case 1: return 'Kapalı';
      case 2: return 'Mod 1';
      default: return 'Mod 2';
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortest   = MediaQuery.of(context).size.shortestSide;
    final outer      = (shortest * 0.56).clamp(220.0, 320.0);
    final inner      = outer * 0.74;

    final colorMode    = context.watch<HumidifierController>().colorMode;
    final diffuserMode = context.watch<HumidifierController>().diffuserMode;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Nemlendirici'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              // 🔵 Gradient halka + animasyonlu bilgi
              SizedBox(
                width: outer,
                height: outer,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dış gradient halka
                    Container(
                      width: outer,
                      height: outer,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [kPrimary, kDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // İç beyaz daire (kabartma)
                    Container(
                      width: inner,
                      height: inner,
                      decoration: BoxDecoration(
                        // hafif radial parlama
                        gradient: RadialGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0.96)],
                          radius: 0.9,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                    // Mod metni + ikon (animasyonlu)
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: Column(
                          key: ValueKey(_diffuserModeLabel(diffuserMode)),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _diffuserModeLabel(diffuserMode),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: kTextDeep,
                                  letterSpacing: 0.35,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Icon(Icons.eco, color: kTextDeep, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 🎨 Renk modu chip (daha belirgin)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.palette_outlined, size: 18, color: kAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Renk: ${_colorModeLabel(colorMode)}',
                      style: const TextStyle(
                        color: kAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 Dropdown (kapsül – lacivert)
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimary.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(canvasColor: kPrimary),
                      child: DropdownButton<String>(
                        value: device.name,
                        iconEnabledColor: Colors.white,
                        dropdownColor: kPrimary,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        style: const TextStyle(color: Colors.white),
                        items: <String>[device.name].map((name) {
                          return DropdownMenuItem(
                            value: name,
                            child: Row(
                              children: [
                                const Icon(Icons.device_hub,
                                    color: Colors.white70, size: 18),
                                const SizedBox(width: 8),
                                Text(name, style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {}, // ileride çoklu cihaz için
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // 🔘 Difüzör & Renk butonları
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _roundAction(
                    label: 'Difüzör',
                    onTap: () =>
                        context.read<HumidifierController>().nextDiffuserMode(),
                  ),
                  _roundAction(
                    label: 'Renk',
                    onTap: () =>
                        context.read<HumidifierController>().nextColorMode(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ortak yuvarlak aksiyon butonu
  Widget _roundAction({required String label, required VoidCallback onTap}) {
    return Material(
      color: kPrimary,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.14),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 116,
          height: 116,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
