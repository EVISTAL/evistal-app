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
class PurifierControlScreen extends StatelessWidget {
  const PurifierControlScreen({super.key});

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

                  // Purifier Device Visualization
                  _PurifierVisualization(
                    isDarkMode: isDarkMode,
                    rgbMode: purifierState.rgbMode,
                    isOn: purifierState.isOn,
                    fanSpeed: purifierState.fanSpeed,
                  ),

                  const SizedBox(height: AppConstants.spacing2Xl),

                  // Power Button
                  _PowerButton(
                    isDarkMode: isDarkMode,
                    isOn: purifierState.isOn,
                    onTap: () => deviceProvider.togglePurifierPower(),
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

  const _PurifierVisualization({
    required this.isDarkMode,
    required this.rgbMode,
    required this.isOn,
    required this.fanSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // RGB Glow Effects
          if (isOn) ...[
            // Top Glow
            Positioned(
              top: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: AppConstants.durationSlow),
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                  child: Container(),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .scale(
                    duration: AppConstants.durationGlow.ms,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.2, 1.2),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    duration: AppConstants.durationGlow.ms,
                    begin: const Offset(1.2, 1.2),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeInOut,
                  ),
            ),

            // Bottom Glow (Reflection)
            Positioned(
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: AppConstants.durationSlow),
                width: 192,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.getRgbLightColor(rgbMode).withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                  child: Container(),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .scale(
                    duration: AppConstants.durationGlow.ms,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.1, 1.1),
                    curve: Curves.easeInOut,
                  )
                  .then(delay: 500.ms)
                  .scale(
                    duration: AppConstants.durationGlow.ms,
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeInOut,
                  ),
            ),
          ],

          // Device Structure
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Cylinder
              Container(
                width: 128,
                height: 192,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [AppColors.darkCardBackground, AppColors.darkCardBackgroundAlt]
                        : [AppColors.lightGray200, AppColors.lightGray300],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.15),
                      blurRadius: AppConstants.shadowBlurXL,
                      offset: const Offset(0, 20),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(isDarkMode ? 0.1 : 0.8),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Inner Grille
                      Container(
                        width: 112,
                        height: 176,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDarkMode
                                ? [
                                    AppColors.darkGray700,
                                    AppColors.darkGray600,
                                    AppColors.darkGray700,
                                  ]
                                : [
                                    AppColors.lightGray300,
                                    AppColors.lightGray200,
                                    AppColors.lightGray300,
                                  ],
                          ),
                        ),
                      ),

                      // RGB Light Strip
                      if (isOn)
                        Positioned(
                          top: 16,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: AppConstants.durationSlow),
                            width: 112,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.getRgbLightColor(rgbMode).withOpacity(0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.getRgbLightColor(rgbMode).withOpacity(0.8),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .custom(
                                duration: AppConstants.durationBreathing.ms,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: 0.6 + (value * 0.4), // 0.6 to 1.0
                                    child: child,
                                  );
                                },
                              )
                              .then()
                              .custom(
                                duration: AppConstants.durationBreathing.ms,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: 1.0 - (value * 0.4), // 1.0 to 0.6
                                    child: child,
                                  );
                                },
                              ),
                        ),

                      // Fan Icon (when device is ON)
                      if (isOn)
                        Positioned(
                          top: 128,
                          child: Icon(
                            LucideIcons.fan,
                            size: AppConstants.iconSizeXXL,
                            color: isDarkMode
                                ? AppColors.lightGray500
                                : AppColors.lightIconInactive,
                          )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .rotate(
                                duration: fanSpeed == 0
                                    ? 0.ms
                                    : (fanSpeed == 1 ? 2000.ms : 1000.ms),
                                curve: Curves.linear,
                              ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Base Top Section
              Container(
                width: 160,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.radiusXl),
                    topRight: Radius.circular(AppConstants.radiusXl),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDarkMode
                        ? [AppColors.darkGray700, AppColors.darkCardBackground]
                        : [AppColors.lightGray300, AppColors.lightGray400],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(isDarkMode ? 0.1 : 0.8),
                      blurRadius: 5,
                      offset: const Offset(0, 1),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
              ),

              // Base Bottom Section
              Container(
                width: 176,
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

/// Power Button
class _PowerButton extends StatelessWidget {
  final bool isDarkMode;
  final bool isOn;
  final VoidCallback onTap;

  const _PowerButton({
    required this.isDarkMode,
    required this.isOn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: AppConstants.durationSlow),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode
                  ? AppColors.darkCardBackgroundAlt
                  : AppColors.lightGray100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.6 : 0.15),
                  blurRadius: isOn
                      ? AppConstants.shadowBlurLarge
                      : AppConstants.shadowBlurSmall * 2,
                  offset: Offset(0, isOn ? 10 : 5),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(isDarkMode ? 0.05 : 0.9),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            child: Icon(
              LucideIcons.power,
              size: AppConstants.iconSizeExtraLarge,
              color: isDarkMode
                  ? AppColors.darkTextSecondary.withOpacity(isOn ? 1.0 : 0.5)
                  : AppColors.lightTextSecondary.withOpacity(isOn ? 1.0 : 0.5),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        Text(
          isOn ? 'On/Off' : 'Off',
          style: TextStyle(
            fontSize: AppConstants.fontSizeSubheadline,
            color: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
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

