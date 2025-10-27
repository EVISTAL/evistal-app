import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

/// Kontrol Kartı Widget
/// Purifier kontrol ekranındaki butonlar için
class ControlCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isActive;
  final Color? activeBackgroundColor;
  final Color? activeShadowColor;

  const ControlCard({
    super.key,
    required this.child,
    this.onTap,
    this.isActive = false,
    this.activeBackgroundColor,
    this.activeShadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; // Temadan renkleri al
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: Duration(milliseconds: AppConstants.durationFast),
        scale: 1.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: AppConstants.durationThemeSwitch),
          curve: Curves.easeInOut,
          height: 140, // Sabit yükseklik - tüm kartlar eşit
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
            color: isActive && activeBackgroundColor != null
                ? activeBackgroundColor
                : colors.cardBackgroundAlt,
            boxShadow: [
              // Outer shadow
              BoxShadow(
                color: isActive && activeShadowColor != null
                    ? activeShadowColor!.withOpacity(isDarkMode ? 0.2 : 0.4)
                    : (isDarkMode
                        ? Colors.black.withOpacity(0.5)
                        : Colors.black.withOpacity(0.08)),
                blurRadius: isActive ? 20 : (isDarkMode ? 30 : 25),
                offset: Offset(0, isDarkMode ? 10 : 8),
              ),
              // Inner shadow
              BoxShadow(
                color: Colors.white.withOpacity(isDarkMode ? 0.03 : 0.9),
                blurRadius: isDarkMode ? 5 : 3,
                offset: const Offset(0, 1),
                spreadRadius: 0,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppConstants.radiusXl),
          child: child,
        ),
      ),
    );
  }
}

/// Kontrol Kartı İçeriği - Icon ve Label ile
class ControlCardContent extends StatelessWidget {
  final IconData? icon;
  final String? value;
  final String label;
  final Widget? customIcon;

  const ControlCardContent({
    super.key,
    this.icon,
    this.value,
    required this.label,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; // Temadan renkleri al
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon veya custom icon
        if (customIcon != null)
          customIcon!
        else if (icon != null)
          SizedBox(
            width: AppConstants.iconSizeLarge,
            height: AppConstants.iconSizeLarge,
            child: Icon(
              icon,
              size: AppConstants.iconSizeLarge,
              color: colors.textPrimary,
            ),
          ),

        if (icon != null || customIcon != null)
          const SizedBox(height: AppConstants.radiusMd),

        // Value
        if (value != null) ...[
          Text(
            value!,
            style: TextStyle(
              fontSize: AppConstants.fontSizeBody,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
        ],

        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.fontSizeSubheadline,
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
