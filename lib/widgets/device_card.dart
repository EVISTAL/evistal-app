import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/device_model.dart';
import '../providers/device_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

/// Cihaz Kartı Widget
/// Cihaz listesinde her bir cihazı gösterir
class DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback? onTap;
  final int index;

  const DeviceCard({
    super.key,
    required this.device,
    this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; // Temadan renkleri al
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final deviceProvider = context.watch<DeviceProvider>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          gradient: device.isActive ? colors.activeGradient : null,
          color: device.isActive ? null : colors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: device.isActive
                  ? (isDarkMode
                      ? Colors.white.withOpacity(AppConstants.shadowOpacityDark)
                      : colors.gray500.withOpacity(AppConstants.shadowOpacityMedium))
                  : (isDarkMode
                      ? colors.cardBackgroundAlt.withOpacity(AppConstants.shadowOpacityDark)
                      : colors.gray300.withOpacity(AppConstants.shadowOpacityLight)),
              blurRadius: device.isActive
                  ? AppConstants.shadowBlurMedium
                  : AppConstants.shadowBlurSmall,
              offset: Offset(0, device.isActive ? 6 : 3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Glow overlay for active device
            if (device.isActive)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white.withOpacity(isDarkMode ? 0.3 : 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .fadeIn(
                      duration: AppConstants.durationBreathing.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .fadeOut(
                      duration: AppConstants.durationBreathing.ms,
                      curve: Curves.easeInOut,
                    ),
              ),

            // İçerik
            Padding(
              padding: const EdgeInsets.all(AppConstants.radiusXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon Container
                  Container(
                    width: AppConstants.iconSizeXXL,
                    height: AppConstants.iconSizeXXL,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                      color: device.isActive
                          ? (isDarkMode
                                  ? colors.cardBackground
                                  : Colors.white)
                              .withOpacity(0.3)
                          : (isDarkMode
                              ? colors.gray700.withOpacity(0.8)
                              : colors.gray100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      device.icon,
                      color: device.isActive
                          ? (isDarkMode
                              ? colors.cardBackgroundAlt
                              : Colors.white)
                          : colors.textSecondary,
                      size: AppConstants.iconSizeMedium,
                    ),
                  ),

                  const SizedBox(height: AppConstants.radiusMd),

                  // Device name
                  Text(
                    device.name,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      color: device.isActive
                          ? (isDarkMode
                              ? colors.cardBackgroundAlt
                              : Colors.white)
                          : colors.textPrimary,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppConstants.spacingSm),

                  // Toggle Switch - Sadece EVISTAL's Humidifier için
                  if (device.id == '1')
                    _ToggleSwitch(
                      isActive: device.isActive,
                      isAnimated: device.isActive,
                      onTap: () {
                        deviceProvider.toggleDevice(device.id);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .scale(
          duration: AppConstants.durationNormal.ms,
          delay: (index * AppConstants.durationStagger).ms,
          begin: const Offset(0.92, 0.92),
          curve: Curves.easeOutCubic,
        )
        .fadeIn(duration: AppConstants.durationNormal.ms, delay: (index * AppConstants.durationStagger).ms);
  }
}

/// Toggle Switch Widget
class _ToggleSwitch extends StatelessWidget {
  final bool isActive;
  final bool isAnimated;
  final VoidCallback onTap;

  const _ToggleSwitch({
    required this.isActive,
    required this.isAnimated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; // Temadan renkleri al
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          color: isActive
              ? (isDarkMode
                      ? colors.cardBackground
                      : Colors.white)
                  .withOpacity(isDarkMode ? 0.5 : 0.9)
              : (isDarkMode
                  ? colors.gray700
                  : colors.gray200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
              spreadRadius: 0,
              blurStyle: BlurStyle.inner,
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: AnimatedAlign(
          duration: Duration(milliseconds: AppConstants.durationNormal),
          curve: Curves.easeInOut,
          alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? (isDarkMode
                      ? colors.cardBackgroundAlt
                      : colors.gray500)
                  : colors.gray500,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
