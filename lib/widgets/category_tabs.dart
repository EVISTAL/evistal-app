import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import '../providers/device_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

/// Kategori Sekmeleri Widget
/// Cihazları kategorilere göre filtrelemek için
class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final deviceProvider = context.watch<DeviceProvider>();
    final selectedCategory = deviceProvider.selectedCategory;

    return SizedBox(
      height: 40,
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
            isDarkMode: isDarkMode,
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
  final bool isDarkMode;
  final int index;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.isDarkMode,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              ? (isDarkMode ? Colors.white : AppColors.lightGray400)
              : (isDarkMode
                  ? AppColors.darkCardBackground
                  : AppColors.lightCardBackground),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? (isDarkMode
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.lightGray400.withOpacity(0.4))
                  : (isDarkMode
                      ? Colors.transparent
                      : AppColors.lightGray200.withOpacity(0.5)),
              blurRadius: isSelected ? 10 : 8,
              offset: isSelected ? const Offset(0, 4) : const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSubheadline,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? (isDarkMode
                      ? AppColors.darkCardBackgroundAlt
                      : Colors.white)
                  : (isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    )
        .animate()
        .slideX(
          duration: AppConstants.durationNormal.ms,
          delay: (index * 100).ms,
          begin: 0.2,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: AppConstants.durationNormal.ms, delay: (index * 100).ms);
  }
}


