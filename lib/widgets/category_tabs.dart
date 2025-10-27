import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/device_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

/// Kategori Sekmeleri Widget
/// Cihazları kategorilere göre filtrelemek için
class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();
    final selectedCategory = deviceProvider.selectedCategory;

    return SizedBox(
      height: AppConstants.categoryTabHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.deviceCategories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppConstants.spacingSm),
        itemBuilder: (context, index) {
          final category = AppConstants.deviceCategories[index];
          final isSelected = category == selectedCategory;

          return _CategoryTab(
            label: category,
            isSelected: isSelected,
            index: index,
            onTap: () {
              deviceProvider.selectCategory(category);
            },
          );
        },
      ),
    );
  }
}

/// Tek bir kategori sekmesi
class _CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppConstants.durationThemeSwitch),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
          vertical: AppConstants.spacingSm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          color: isSelected
              ? (isDarkMode ? Colors.white : colors.gray400)
              : colors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? (isDarkMode
                      ? Colors.white.withOpacity(AppConstants.shadowOpacityDark)
                      : colors.gray400.withOpacity(AppConstants.shadowOpacityMedium))
                  : (isDarkMode
                      ? Colors.transparent
                      : colors.gray200.withOpacity(AppConstants.shadowOpacityLight)),
              blurRadius: isSelected ? AppConstants.shadowBlurSmall : 6,
              offset: isSelected ? const Offset(0, 3) : const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSubheadline,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDarkMode
                      ? colors.cardBackgroundAlt
                      : Colors.white)
                  : colors.textSecondary,
              height: 1.2,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    )
        .animate()
        .slideX(
          duration: AppConstants.durationNormal.ms,
          delay: (index * AppConstants.durationStagger).ms,
          begin: 0.15,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(duration: AppConstants.durationNormal.ms, delay: (index * AppConstants.durationStagger).ms);
  }
}
