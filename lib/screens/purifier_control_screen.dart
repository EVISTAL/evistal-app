import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../providers/device_provider.dart';
import '../widgets/control_card.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

/// Hava Temizleyici Kontrol Ekranı
/// My Purifier cihazının detaylı kontrol ekranı
class PurifierControlScreen extends StatefulWidget {
  const PurifierControlScreen({super.key});

  @override
  State<PurifierControlScreen> createState() => _PurifierControlScreenState();
}

class _PurifierControlScreenState extends State<PurifierControlScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final deviceProvider = context.watch<DeviceProvider>();
    final purifierState = deviceProvider.purifierState;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.maxWidth,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(
                AppConstants.radiusXl,
                AppConstants.radiusXl,
                AppConstants.radiusXl,
                AppConstants.spacing2Xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header Bar
                  _HeaderBar(isDarkMode: isDarkMode),

                  const SizedBox(height: AppConstants.spacing2Xl),

                  // Status Info Bar
                  _StatusInfoBar(isDarkMode: isDarkMode),

                  const SizedBox(height: AppConstants.spacing2Xl),

                  // Purifier Device Visualization (Parallax ile)
                  _PurifierVisualization(
                    isDarkMode: isDarkMode,
                    rgbMode: purifierState.rgbMode,
                    isOn: purifierState.isOn,
                    fanSpeed: purifierState.fanSpeed,
                    scrollOffset: _scrollOffset,
                  ),

                  const SizedBox(height: AppConstants.spacing2Xl),

                  // Control Buttons Grid (Primary Controls)
                  Row(
                    children: [
                      // Speed Control
                      Expanded(
                        child: ControlCard(
                          onTap: () => deviceProvider.cycleFanSpeed(),
                          child: ControlCardContent(
                            icon: LucideIcons.fan,
                            value: purifierState.fanSpeed.toString(),
                            label: 'Speed',
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingLg),

                      // Oscillation Control
                      Expanded(
                        child: ControlCard(
                          onTap: () => deviceProvider.toggleOscillation(),
                          child: ControlCardContent(
                            customIcon: _OscillationIcon(
                              isActive: purifierState.oscillation,
                              isDarkMode: isDarkMode,
                            ),
                            value: purifierState.oscillation ? 'ON' : 'OFF',
                            label: 'Oscillation',
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingLg),

                      // Timer Control
                      Expanded(
                        child: ControlCard(
                          onTap: () {},
                          child: ControlCardContent(
                            icon: LucideIcons.clock,
                            value: purifierState.timer,
                            label: 'Timer',
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.radiusXl),

                  // Mode Buttons Grid (Secondary Controls)
                  Row(
                    children: [
                      // Auto Mode
                      Expanded(
                        child: ControlCard(
                          onTap: () => deviceProvider.toggleAutoMode(),
                          isActive: purifierState.autoMode,
                          activeBackgroundColor: isDarkMode
                              ? AppColors.autoModeBgDark
                              : AppColors.autoModeBgLight,
                          activeShadowColor: AppColors.rgbMode1Light,
                          child: ControlCardContent(
                            value: 'AUTO',
                            label: 'Auto mode',
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingLg),

                      // Night Mode
                      Expanded(
                        child: ControlCard(
                          onTap: () => deviceProvider.toggleNightMode(),
                          isActive: purifierState.nightMode,
                          activeBackgroundColor: isDarkMode
                              ? AppColors.nightModeBgDark
                              : AppColors.nightModeBgLight,
                          activeShadowColor: const Color(0xFF6366F1),
                          child: ControlCardContent(
                            icon: LucideIcons.moon,
                            label: 'Night mode',
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingLg),

                      // Air Flow
                      Expanded(
                        child: ControlCard(
                          onTap: () => deviceProvider.toggleAirFlow(),
                          isActive: purifierState.airFlow,
                          activeBackgroundColor: isDarkMode
                              ? AppColors.airFlowBgDark
                              : AppColors.airFlowBgLight,
                          activeShadowColor: const Color(0xFF3B82F6),
                          child: ControlCardContent(
                            icon: LucideIcons.wind,
                            label: 'Air flow',
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Header Bar - Üst kısım
class _HeaderBar extends StatelessWidget {
  final bool isDarkMode;

  const _HeaderBar({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();
    final rgbMode = deviceProvider.purifierState.rgbMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Close Button
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            LucideIcons.x,
            size: AppConstants.iconSizeMedium,
            color: isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        )
            .animate()
            .fadeIn(duration: AppConstants.durationNormal.ms)
            .scale(begin: const Offset(0.8, 0.8)),

        // Title
        Text(
          'My Purifier',
          style: TextStyle(
            fontSize: AppConstants.fontSizeTitle,
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        )
            .animate()
            .fadeIn(duration: AppConstants.durationNormal.ms)
            .slideY(begin: -0.3, duration: AppConstants.durationNormal.ms),

        // RGB Mode Button
        GestureDetector(
          onTap: () => deviceProvider.cycleRgbMode(),
          child: AnimatedContainer(
            duration: Duration(milliseconds: AppConstants.durationNormal),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.getRgbGradient(rgbMode),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getRgbLightColor(rgbMode).withOpacity(
                    rgbMode == 0 ? 0.5 : 0.7,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                rgbMode.toString(),
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeCaption,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
                  .animate(
                    key: ValueKey(rgbMode),
                  )
                  .scale(
                    duration: AppConstants.durationNormal.ms,
                    begin: const Offset(0, 0),
                    curve: Curves.elasticOut,
                  ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: AppConstants.durationNormal.ms)
            .scale(begin: const Offset(0.8, 0.8)),
      ],
    );
  }
}

/// Status Info Bar - Sıcaklık, Nem, Hava Kalitesi
class _StatusInfoBar extends StatelessWidget {
  final bool isDarkMode;

  const _StatusInfoBar({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🌡️', style: TextStyle(fontSize: AppConstants.iconSizeLarge)),
        const SizedBox(width: AppConstants.spacingXs),
        Text(
          '23°',
          style: TextStyle(
            fontSize: AppConstants.iconSizeLarge,
            color: isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(width: AppConstants.radiusXl),
        const Text('💧', style: TextStyle(fontSize: AppConstants.iconSizeLarge)),
        const SizedBox(width: AppConstants.spacingXs),
        Text(
          '50%',
          style: TextStyle(
            fontSize: AppConstants.iconSizeLarge,
            color: isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(width: AppConstants.radiusXl),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingSm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            color: isDarkMode
                ? AppColors.darkCardBackground
                : AppColors.lightGray100,
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? AppColors.darkCardBackgroundAlt.withOpacity(0.5)
                    : AppColors.lightGray300.withOpacity(0.3),
                blurRadius: isDarkMode ? 10 : 8,
                offset: Offset(0, isDarkMode ? 4 : 2),
              ),
            ],
          ),
          child: Text(
            'GOOD',
            style: TextStyle(
              fontSize: AppConstants.fontSizeSubheadline,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: AppConstants.durationNormal.ms, delay: 200.ms);
  }
}

/// Purifier Görselleştirme
class _PurifierVisualization extends StatelessWidget {
  final bool isDarkMode;
  final int rgbMode;
  final bool isOn;
  final int fanSpeed;
  final double scrollOffset;

  const _PurifierVisualization({
    required this.isDarkMode,
    required this.rgbMode,
    required this.isOn,
    required this.fanSpeed,
    required this.scrollOffset,
  });

  /// Duman/Buhar efektleri oluştur - Serbest yayılan duman
  List<Widget> _buildSmokeEffects(int rgbMode) {
    final smokeColor = AppColors.getRgbLightColor(rgbMode);
    
    return [
      // Duman Bulutu 1 (Sola yayılan)
      Positioned(
        top: 60,
        left: 40,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                smokeColor.withOpacity(0.25),
                smokeColor.withOpacity(0.15),
                smokeColor.withOpacity(0.08),
                smokeColor.withOpacity(0.03),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(
              duration: 4500.ms,
              begin: 0,
              end: -140,
              curve: Curves.easeOut,
            )
            .moveX(
              duration: 4500.ms,
              begin: 0,
              end: -80,
              curve: Curves.easeInOut,
            )
            .fadeOut(
              duration: 4500.ms,
              curve: Curves.easeOut,
            )
            .scale(
              duration: 4500.ms,
              begin: const Offset(0.5, 0.5),
              end: const Offset(3.0, 3.5),
              curve: Curves.easeOut,
            ),
      ),

      // Duman Bulutu 2 (Sağa yayılan)
      Positioned(
        top: 60,
        right: 40,
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                smokeColor.withOpacity(0.22),
                smokeColor.withOpacity(0.13),
                smokeColor.withOpacity(0.07),
                smokeColor.withOpacity(0.02),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(
              duration: 5000.ms,
              begin: 0,
              end: -150,
              curve: Curves.easeOut,
              delay: 1000.ms,
            )
            .moveX(
              duration: 5000.ms,
              begin: 0,
              end: 90,
              curve: Curves.easeInOut,
              delay: 1000.ms,
            )
            .fadeOut(
              duration: 5000.ms,
              curve: Curves.easeOut,
              delay: 1000.ms,
            )
            .scale(
              duration: 5000.ms,
              begin: const Offset(0.5, 0.5),
              end: const Offset(3.2, 3.8),
              curve: Curves.easeOut,
              delay: 1000.ms,
            ),
      ),

      // Duman Bulutu 3 (Merkez - Yukarı)
      Positioned(
        top: 30,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                smokeColor.withOpacity(0.28),
                smokeColor.withOpacity(0.16),
                smokeColor.withOpacity(0.09),
                smokeColor.withOpacity(0.04),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(
              duration: 5500.ms,
              begin: 0,
              end: -180,
              curve: Curves.easeOut,
              delay: 2000.ms,
            )
            .moveX(
              duration: 5500.ms,
              begin: 0,
              end: 15,
              curve: Curves.easeInOut,
              delay: 2000.ms,
            )
            .fadeOut(
              duration: 5500.ms,
              curve: Curves.easeOut,
              delay: 2000.ms,
            )
            .scale(
              duration: 5500.ms,
              begin: const Offset(0.6, 0.6),
              end: const Offset(3.5, 4.0),
              curve: Curves.easeOut,
              delay: 2000.ms,
            ),
      ),

      // Duman Bulutu 4 (Sol üst diyagonal)
      Positioned(
        top: 80,
        left: 30,
        child: Container(
          width: 95,
          height: 95,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                smokeColor.withOpacity(0.2),
                smokeColor.withOpacity(0.12),
                smokeColor.withOpacity(0.06),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(
              duration: 4000.ms,
              begin: 0,
              end: -120,
              curve: Curves.easeOut,
              delay: 500.ms,
            )
            .moveX(
              duration: 4000.ms,
              begin: 0,
              end: -60,
              curve: Curves.easeInOut,
              delay: 500.ms,
            )
            .fadeOut(
              duration: 4000.ms,
              curve: Curves.easeOut,
              delay: 500.ms,
            )
            .scale(
              duration: 4000.ms,
              begin: const Offset(0.5, 0.5),
              end: const Offset(2.5, 2.8),
              curve: Curves.easeOut,
              delay: 500.ms,
            ),
      ),

      // Duman Bulutu 5 (Sağ üst diyagonal)
      Positioned(
        top: 80,
        right: 30,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                smokeColor.withOpacity(0.19),
                smokeColor.withOpacity(0.11),
                smokeColor.withOpacity(0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(
              duration: 4500.ms,
              begin: 0,
              end: -130,
              curve: Curves.easeOut,
              delay: 1500.ms,
            )
            .moveX(
              duration: 4500.ms,
              begin: 0,
              end: 70,
              curve: Curves.easeInOut,
              delay: 1500.ms,
            )
            .fadeOut(
              duration: 4500.ms,
              curve: Curves.easeOut,
              delay: 1500.ms,
            )
            .scale(
              duration: 4500.ms,
              begin: const Offset(0.5, 0.5),
              end: const Offset(2.7, 3.0),
              curve: Curves.easeOut,
              delay: 1500.ms,
            ),
      ),

      // Duman Bulutu 6 (Merkez-sol alt)
      Positioned(
        top: 110,
        left: 70,
        child: Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                smokeColor.withOpacity(0.18),
                smokeColor.withOpacity(0.10),
                smokeColor.withOpacity(0.04),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(
              duration: 3800.ms,
              begin: 0,
              end: -110,
              curve: Curves.easeOut,
              delay: 800.ms,
            )
            .moveX(
              duration: 3800.ms,
              begin: 0,
              end: -50,
              curve: Curves.easeInOut,
              delay: 800.ms,
            )
            .fadeOut(
              duration: 3800.ms,
              curve: Curves.easeOut,
              delay: 800.ms,
            )
            .scale(
              duration: 3800.ms,
              begin: const Offset(0.5, 0.5),
              end: const Offset(2.3, 2.6),
              curve: Curves.easeOut,
              delay: 800.ms,
            ),
      ),

      // Duman Bulutu 7 (Merkez-sağ alt)
      Positioned(
        top: 110,
        right: 70,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                smokeColor.withOpacity(0.17),
                smokeColor.withOpacity(0.09),
                smokeColor.withOpacity(0.04),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(
              duration: 4100.ms,
              begin: 0,
              end: -115,
              curve: Curves.easeOut,
              delay: 1800.ms,
            )
            .moveX(
              duration: 4100.ms,
              begin: 0,
              end: 55,
              curve: Curves.easeInOut,
              delay: 1800.ms,
            )
            .fadeOut(
              duration: 4100.ms,
              curve: Curves.easeOut,
              delay: 1800.ms,
            )
            .scale(
              duration: 4100.ms,
              begin: const Offset(0.5, 0.5),
              end: const Offset(2.4, 2.7),
              curve: Curves.easeOut,
              delay: 1800.ms,
            ),
      ),
    ];
  }

  /// Çift piramit oluştur (düz yüzeyler - yumuşak köşeler)
  Widget _buildDoublePyramid(bool isDarkMode) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: _DoublePyramidPainter(
        isDarkMode: isDarkMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Stack(
        clipBehavior: Clip.none, // Duman çerçeve dışına çıkabilir
        alignment: Alignment.center,
        children: [
          // RGB Glow Effects - Gerçekçi Yayılan Işık
          if (isOn) ...[
            // Ana Glow (Merkez - daha yoğun)
            Positioned(
              top: 40,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.5),
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.3),
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.15),
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                  ),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .scale(
                    duration: AppConstants.durationGlow.ms,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.15, 1.15),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    duration: AppConstants.durationGlow.ms,
                    begin: const Offset(1.15, 1.15),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeInOut,
                  )
                  .custom(
                    duration: AppConstants.durationBreathing.ms,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: 0.7 + (value * 0.3),
                        child: child,
                      );
                    },
                  )
                  .then()
                  .custom(
                    duration: AppConstants.durationBreathing.ms,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: 1.0 - (value * 0.3),
                        child: child,
                      );
                    },
                  ),
            ),

            // Dış Glow (Daha geniş, daha hafif)
            Positioned(
              top: -20,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.08),
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .scale(
                    duration: (AppConstants.durationGlow * 1.5).ms,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.2, 1.2),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    duration: (AppConstants.durationGlow * 1.5).ms,
                    begin: const Offset(1.2, 1.2),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeInOut,
                  ),
            ),

            // Alt Yansıma Glow
            Positioned(
              bottom: -30,
              child: Container(
                width: 240,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.3),
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.15),
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .scale(
                    duration: (AppConstants.durationGlow * 1.2).ms,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.12, 1.12),
                    curve: Curves.easeInOut,
                  )
                  .then(delay: 400.ms)
                  .scale(
                    duration: (AppConstants.durationGlow * 1.2).ms,
                    begin: const Offset(1.12, 1.12),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeInOut,
                  ),
            ),

            // Duman/Buhar Efekti (Üstten yükselen)
            ..._buildSmokeEffects(rgbMode),
          ],

          // Device Structure - Double Pyramid Humidifier (Floating)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Çift Piramit - Floating Animasyonlu (yukarı/aşağı)
                    _buildDoublePyramid(isDarkMode)
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .moveY(
                          duration: 3000.ms,
                          begin: -8,
                          end: 8,
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .moveY(
                          duration: 3000.ms,
                          begin: 8,
                          end: -8,
                          curve: Curves.easeInOut,
                        ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Base
              Container(
                width: 180,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDarkMode
                        ? [AppColors.darkCardBackground, AppColors.darkCardBackgroundAlt]
                        : [AppColors.lightGray400, AppColors.lightGray500],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.5)
                          : AppColors.lightGray500.withOpacity(0.3),
                      blurRadius: isDarkMode ? 24 : 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
            ],
          )
              .animate()
              .slideY(
                duration: AppConstants.durationNormal.ms,
                delay: 300.ms,
                begin: 0.3,
                curve: Curves.easeOut,
              )
              .fadeIn(duration: AppConstants.durationNormal.ms, delay: 300.ms),
        ],
      ),
    );
  }
}

/// Oscillation Icon - Animasyonlu salınım ikonu
class _OscillationIcon extends StatelessWidget {
  final bool isActive;
  final bool isDarkMode;

  const _OscillationIcon({
    required this.isActive,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          LucideIcons.chevronLeft,
          size: AppConstants.iconSizeSmall,
          color: isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
        const SizedBox(width: AppConstants.spacingXs),
        Icon(
          LucideIcons.chevronRight,
          size: AppConstants.iconSizeSmall,
          color: isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ],
    )
        .animate(
          onPlay: isActive ? (controller) => controller.repeat() : null,
        )
        .slideX(
          duration: AppConstants.durationToggle.ms,
          begin: -0.05,
          end: 0.05,
          curve: Curves.easeInOut,
        )
        .then()
        .slideX(
          duration: AppConstants.durationToggle.ms,
          begin: 0.05,
          end: -0.05,
          curve: Curves.easeInOut,
        );
  }
}

/// Çift Piramit Painter (Kum Saati Şekli) - Estetik 3D Versiyonu
class _DoublePyramidPainter extends CustomPainter {
  final bool isDarkMode;

  _DoublePyramidPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // ============================================================================
    // ÜST PİRAMİT (Ters) - 3D Gradient ile + Yumuşak Köşeler
    // ============================================================================
    
    final topPyramidPath = Path();
    // Sol üst köşe (yuvarlatılmış)
    topPyramidPath.moveTo(centerX - 75, 10);
    topPyramidPath.quadraticBezierTo(centerX - 80, 10, centerX - 80, 15);
    // Sol kenar
    topPyramidPath.lineTo(centerX - 32, centerY - 5);
    // Sol orta köşe (yuvarlatılmış)
    topPyramidPath.quadraticBezierTo(centerX - 30, centerY, centerX - 28, centerY);
    // Alt kenar
    topPyramidPath.lineTo(centerX + 28, centerY);
    // Sağ orta köşe (yuvarlatılmış)
    topPyramidPath.quadraticBezierTo(centerX + 30, centerY, centerX + 32, centerY - 5);
    // Sağ kenar
    topPyramidPath.lineTo(centerX + 80, 15);
    // Sağ üst köşe (yuvarlatılmış)
    topPyramidPath.quadraticBezierTo(centerX + 80, 10, centerX + 75, 10);
    // Üst kenar
    topPyramidPath.lineTo(centerX - 75, 10);
    topPyramidPath.close();

    // 3D Gradient (Sol koyu → Sağ açık)
    final topGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: isDarkMode
            ? [
                AppColors.darkGray700,
                AppColors.darkGray600,
                AppColors.darkCardBackground,
              ]
            : [
                AppColors.lightGray300,
                AppColors.lightGray200,
                const Color(0xFFF5F5F5),
              ],
      ).createShader(Rect.fromLTWH(centerX - 80, 10, 160, centerY - 10));

    canvas.drawPath(topPyramidPath, topGradientPaint);

    // Inner Shadow (iç gölge)
    final topShadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(topPyramidPath, topShadowPaint);

    // Highlight (üstten ışık vurması)
    final topHighlightPath = Path();
    topHighlightPath.moveTo(centerX - 70, 15);
    topHighlightPath.lineTo(centerX + 70, 15);
    topHighlightPath.lineTo(centerX + 25, centerY - 5);
    topHighlightPath.lineTo(centerX - 25, centerY - 5);
    topHighlightPath.close();

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(isDarkMode ? 0.08 : 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(topHighlightPath, highlightPaint);

    // Border (ince ve smooth)
    final topBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = isDarkMode 
          ? AppColors.darkGray700.withOpacity(0.8)
          : AppColors.lightGray400.withOpacity(0.6)
      ..strokeWidth = 1.0;
    canvas.drawPath(topPyramidPath, topBorderPaint);

    // ============================================================================
    // ALT PİRAMİT (Normal) - 3D Gradient ile + Yumuşak Köşeler
    // ============================================================================
    
    final bottomPyramidPath = Path();
    // Sol orta köşe (yuvarlatılmış)
    bottomPyramidPath.moveTo(centerX - 28, centerY);
    bottomPyramidPath.quadraticBezierTo(centerX - 30, centerY, centerX - 32, centerY + 5);
    // Sol kenar
    bottomPyramidPath.lineTo(centerX - 88, size.height - 15);
    // Sol alt köşe (yuvarlatılmış)
    bottomPyramidPath.quadraticBezierTo(centerX - 90, size.height - 10, centerX - 85, size.height - 10);
    // Alt kenar
    bottomPyramidPath.lineTo(centerX + 85, size.height - 10);
    // Sağ alt köşe (yuvarlatılmış)
    bottomPyramidPath.quadraticBezierTo(centerX + 90, size.height - 10, centerX + 88, size.height - 15);
    // Sağ kenar
    bottomPyramidPath.lineTo(centerX + 32, centerY + 5);
    // Sağ orta köşe (yuvarlatılmış)
    bottomPyramidPath.quadraticBezierTo(centerX + 30, centerY, centerX + 28, centerY);
    // Orta kenar
    bottomPyramidPath.lineTo(centerX - 28, centerY);
    bottomPyramidPath.close();

    // 3D Gradient (Sol koyu → Sağ açık)
    final bottomGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: isDarkMode
            ? [
                AppColors.darkGray700,
                AppColors.darkGray600,
                AppColors.darkCardBackground,
              ]
            : [
                AppColors.lightGray400,
                AppColors.lightGray300,
                AppColors.lightGray200,
              ],
      ).createShader(Rect.fromLTWH(
          centerX - 90, centerY, 180, size.height - centerY - 10));

    canvas.drawPath(bottomPyramidPath, bottomGradientPaint);

    // Inner Shadow (iç gölge)
    final bottomShadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black.withOpacity(isDarkMode ? 0.4 : 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(bottomPyramidPath, bottomShadowPaint);

    // Highlight (ortadan ışık vurması)
    final bottomHighlightPath = Path();
    bottomHighlightPath.moveTo(centerX - 25, centerY + 5);
    bottomHighlightPath.lineTo(centerX + 25, centerY + 5);
    bottomHighlightPath.lineTo(centerX + 80, size.height - 15);
    bottomHighlightPath.lineTo(centerX - 80, size.height - 15);
    bottomHighlightPath.close();

    canvas.drawPath(bottomHighlightPath, highlightPaint);

    // Border (ince ve smooth)
    final bottomBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = isDarkMode 
          ? AppColors.darkGray700.withOpacity(0.8)
          : AppColors.lightGray500.withOpacity(0.6)
      ..strokeWidth = 1.0;
    canvas.drawPath(bottomPyramidPath, bottomBorderPaint);

    // ============================================================================
    // ORTA ÇİZGİ (Birleşme noktası - vurgu)
    // ============================================================================
    
    final centerLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = isDarkMode
          ? AppColors.darkGray700.withOpacity(0.5)
          : AppColors.lightGray500.withOpacity(0.4)
      ..strokeWidth = 1.5;
    
    canvas.drawLine(
      Offset(centerX - 30, centerY),
      Offset(centerX + 30, centerY),
      centerLinePaint,
    );

    // Orta highlight çizgisi (metalik görünüm)
    final centerHighlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withOpacity(isDarkMode ? 0.1 : 0.5)
      ..strokeWidth = 0.5;
    
    canvas.drawLine(
      Offset(centerX - 28, centerY - 1),
      Offset(centerX + 28, centerY - 1),
      centerHighlightPaint,
    );

    // ============================================================================
    // KATMAN ÇİZGİLERİ (Yatay çizgilerle katman efekti)
    // ============================================================================
    
    final layerLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = isDarkMode
          ? AppColors.darkGray700.withOpacity(0.6)
          : AppColors.lightGray400.withOpacity(0.5)
      ..strokeWidth = 1.0;

    final layerHighlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withOpacity(isDarkMode ? 0.05 : 0.3)
      ..strokeWidth = 0.5;

    // ÜST PİRAMİT KATMANLARI (8 katman)
    const int topLayers = 8;
    for (int i = 1; i < topLayers; i++) {
      final double y = 10 + (centerY - 10) * (i / topLayers);
      final double widthAtY = 80 - (80 - 30) * (i / topLayers);
      
      // Ana katman çizgisi
      canvas.drawLine(
        Offset(centerX - widthAtY, y),
        Offset(centerX + widthAtY, y),
        layerLinePaint,
      );
      
      // Highlight çizgisi (altında)
      canvas.drawLine(
        Offset(centerX - widthAtY + 2, y + 1),
        Offset(centerX + widthAtY - 2, y + 1),
        layerHighlightPaint,
      );
    }

    // ALT PİRAMİT KATMANLARI (10 katman)
    const int bottomLayers = 10;
    for (int i = 1; i < bottomLayers; i++) {
      final double y = centerY + (size.height - 10 - centerY) * (i / bottomLayers);
      final double widthAtY = 30 + (90 - 30) * (i / bottomLayers);
      
      // Ana katman çizgisi
      canvas.drawLine(
        Offset(centerX - widthAtY, y),
        Offset(centerX + widthAtY, y),
        layerLinePaint,
      );
      
      // Highlight çizgisi (altında)
      canvas.drawLine(
        Offset(centerX - widthAtY + 2, y + 1),
        Offset(centerX + widthAtY - 2, y + 1),
        layerHighlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_DoublePyramidPainter oldDelegate) => false;
}

