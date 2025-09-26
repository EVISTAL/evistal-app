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

  static const _bg = Color(0xFFF2F8FF);
  static const _card = Color(0xFF85C9FF);
  static const _deepBlue = Color(0xFF002686);
  static const _accent = Color(0xFF13007F);

  String _colorModeLabel(int mode) {
    switch (mode) {
      case 1:
        return 'Rainbow';
      case 2:
        return 'RGB';
      case 3:
        return 'Beyaz';
      default:
        return 'Kapalı';
    }
  }

  String _diffuserModeLabel(int mode) {
    switch (mode) {
      case 1:
        return 'Kapalı';
      case 2:
        return 'Mod 1';
      default:
        return 'Mod 2';
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    final outer = (shortest * 0.55).clamp(220.0, 300.0);
    final ring = outer;
    final inner = outer * 0.77;
    final colorMode = context.watch<HumidifierController>().colorMode;
    final diffuserMode = context.watch<HumidifierController>().diffuserMode;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Nemlendirici'),
        backgroundColor: _card,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: const [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              SizedBox(
                width: ring,
                height: ring,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: ring,
                      height: ring,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [_card, Color.fromARGB(255, 8, 38, 114)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Container(
                      width: inner,
                      height: inner,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: _deepBlue,
                                  letterSpacing: 0.35,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Icon(Icons.eco, color: _deepBlue, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.palette_outlined, size: 18, color: _accent),
                    const SizedBox(width: 8),
                    Text(
                      'Renk: ${_colorModeLabel(colorMode)}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 27, 8, 135),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: _card,
                      ),
                      child: DropdownButton<String>(
                        value: device.name,
                        iconEnabledColor: Colors.white,
                        dropdownColor: _card,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        style: const TextStyle(color: Colors.white),
                        items: <String>[device.name].map((name) {
                          return DropdownMenuItem(
                            value: name,
                            child: Row(
                              children: [
                                const Icon(Icons.device_hub, color: Colors.white70, size: 18),
                                const SizedBox(width: 8),
                                Text(name, style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _roundAction(
                    label: 'Difüzör',
                    onTap: () => context.read<HumidifierController>().nextDiffuserMode(),
                  ),
                  _roundAction(
                    label: 'Renk',
                    onTap: () => context.read<HumidifierController>().nextColorMode(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundAction({required String label, required VoidCallback onTap}) {
    return Material(
      color: _card,
      shape: const CircleBorder(),
      elevation: 2,
      // ignore: deprecated_member_use
      shadowColor: Colors.black.withOpacity(0.12),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 112,
          height: 112,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
