import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

/// Alt Navigasyon Çubuğu Widget
/// Sabit alt menü
class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: AppConstants.bottomNavHeight,
          decoration: BoxDecoration(
            color: (isDarkMode
                    ? AppColors.darkCardBackgroundAlt
                    : AppColors.lightCardBackground)
                .withOpacity(0.95),
            border: Border(
              top: BorderSide(
                color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: LucideIcons.house,
                  isActive: currentIndex == 0,
                  isDarkMode: isDarkMode,
                  onTap: () {},
                ),
                _NavItem(
                  icon: LucideIcons.tv,
                  isActive: currentIndex == 1,
                  isDarkMode: isDarkMode,
                  onTap: () {},
                ),
                _NavItem(
                  icon: LucideIcons.lightbulb,
                  isActive: currentIndex == 2,
                  isDarkMode: isDarkMode,
                  onTap: () {},
                ),
                _NavItem(
                  icon: LucideIcons.speaker,
                  isActive: currentIndex == 3,
                  isDarkMode: isDarkMode,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .slideY(
          duration: AppConstants.durationSlow.ms,
          delay: 200.ms,
          begin: 2.0,
          curve: Curves.easeOut,
        );
  }
}

/// Navigasyon öğesi
class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(AppConstants.spacingSm),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Icon
            Icon(
              icon,
              size: AppConstants.iconSizeMedium,
              color: isActive
                  ? (isDarkMode
                      ? AppColors.darkIconActive
                      : AppColors.lightIconActive)
                  : (isDarkMode
                      ? AppColors.lightTextSecondary
                      : AppColors.lightIconInactive),
            ),

            // Active Indicator
            if (isActive)
              Positioned(
                bottom: -4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? AppColors.darkIconActive
                        : AppColors.lightIconActive,
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .scale(
                      duration: AppConstants.durationBreathing.ms,
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.5, 1.5),
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .scale(
                      duration: AppConstants.durationBreathing.ms,
                      begin: const Offset(1.5, 1.5),
                      end: const Offset(1.0, 1.0),
                      curve: Curves.easeInOut,
                    ),
              ),
          ],
        ),
      ),
    )
        .animate(
          target: isActive ? 0 : 1,
        )
        .scaleXY(
          duration: AppConstants.durationFast.ms,
          begin: 1.0,
          end: 0.9,
        );
  }
}

