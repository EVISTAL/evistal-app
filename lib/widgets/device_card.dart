import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/device_model.dart';
import '../providers/theme_provider.dart';
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
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final deviceProvider = context.watch<DeviceProvider>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          gradient: device.isActive
              ? (isDarkMode
                  ? AppColors.darkActiveGradient
                  : AppColors.lightActiveGradient)
              : null,
          color: device.isActive
              ? null
              : (isDarkMode
                  ? AppColors.darkCardBackground
                  : AppColors.lightCardBackground),
          boxShadow: [
            BoxShadow(
              color: device.isActive
                  ? (isDarkMode
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.lightGray500.withOpacity(0.4))
                  : (isDarkMode
                      ? AppColors.darkCardBackgroundAlt.withOpacity(0.5)
                      : AppColors.lightGray300.withOpacity(0.3)),
              blurRadius: device.isActive
                  ? AppConstants.radiusXl
                  : AppConstants.radiusMd,
              offset: Offset(0, device.isActive ? 8 : 4),
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
                                  ? AppColors.darkCardBackground
                                  : Colors.white)
                              .withOpacity(0.3)
                          : (isDarkMode
                              ? AppColors.darkGray700.withOpacity(0.8)
                              : AppColors.lightGray100),
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
                              ? AppColors.darkCardBackgroundAlt
                              : Colors.white)
                          : (isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
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
                              ? AppColors.darkCardBackgroundAlt
                              : Colors.white)
                          : (isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppConstants.spacingSm),

                  // Toggle Switch - Sadece EVISTAL's Humidifier için
                  if (device.id == '1')
                    _ToggleSwitch(
                      isActive: device.isActive,
                      isDarkMode: isDarkMode,
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
          delay: (index * 100).ms,
          begin: const Offset(0.9, 0.9),
          curve: Curves.easeOut,
        )
        .fadeIn(duration: AppConstants.durationNormal.ms, delay: (index * 100).ms);
  }
}

/// Toggle Switch Widget
class _ToggleSwitch extends StatelessWidget {
  final bool isActive;
  final bool isDarkMode;
  final bool isAnimated;
  final VoidCallback onTap;

  const _ToggleSwitch({
    required this.isActive,
    required this.isDarkMode,
    required this.isAnimated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          color: isActive
              ? (isDarkMode
                      ? AppColors.darkCardBackground
                      : Colors.white)
                  .withOpacity(isDarkMode ? 0.5 : 0.9)
              : (isDarkMode
                  ? AppColors.darkGray700
                  : AppColors.lightGray200),
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
                      ? AppColors.darkCardBackgroundAlt
                      : AppColors.lightGray500)
                  : AppColors.lightGray500,
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


