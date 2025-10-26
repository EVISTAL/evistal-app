import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../providers/device_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/device_card.dart';
import '../widgets/category_tabs.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'purifier_control_screen.dart';
import 'ble_scan_screen.dart';

/// Cihaz Seçim Ekranı
/// Ana ekran - Cihazları listeler
class DeviceSelectionScreen extends StatelessWidget {
  const DeviceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final deviceProvider = context.watch<DeviceProvider>();
    final themeProvider = context.read<ThemeProvider>();

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
                child: CustomScrollView(
                  slivers: [
                    // Header Section
                    SliverToArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.spacingLg,
                          AppConstants.radiusXl,
                          AppConstants.spacingLg,
                          0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sol taraf - Selamlama
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hey, EVISTAL\'s USER',
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeBody,
                                    color: isDarkMode
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: AppConstants.durationNormal.ms)
                                    .slideX(begin: -0.2, duration: AppConstants.durationNormal.ms),
                                const SizedBox(height: AppConstants.spacingXs),
                                Text(
                                  'Welcome back at home',
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeSubheadline,
                                    color: isDarkMode
                                        ? AppColors.darkTextTertiary
                                        : AppColors.lightIconInactive,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(
                                      duration: AppConstants.durationNormal.ms,
                                      delay: 100.ms,
                                    )
                                    .slideX(begin: -0.2, duration: AppConstants.durationNormal.ms),
                              ],
                            ),

                            // Sağ taraf - Tema değiştirme butonu
                            GestureDetector(
                              onTap: () {
                                themeProvider.toggleTheme();
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: AppConstants.durationThemeSwitch),
                                curve: Curves.easeInOut,
                                width: AppConstants.iconSizeXXL,
                                height: AppConstants.iconSizeXXL,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                                  color: isDarkMode
                                      ? AppColors.darkCardBackground
                                      : AppColors.lightCardBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDarkMode
                                          ? AppColors.darkCardBackgroundAlt.withOpacity(0.5)
                                          : AppColors.lightGray300.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(AppConstants.radiusMd),
                                child: AnimatedRotation(
                                  duration: Duration(milliseconds: AppConstants.durationThemeSwitch),
                                  turns: isDarkMode ? 0 : 0.5,
                                  child: Icon(
                                    isDarkMode ? LucideIcons.sun : LucideIcons.moon,
                                    color: isDarkMode
                                        ? AppColors.themeIconSun
                                        : AppColors.darkCardBackground,
                                    size: AppConstants.iconSizeSmall,
                                  ),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: AppConstants.durationNormal.ms)
                                .scale(begin: const Offset(0.8, 0.8), duration: AppConstants.durationNormal.ms),
                          ],
                        ),
                      ),
                    ),

                    // Weather Card
                    SliverToArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.spacingLg,
                          AppConstants.radiusXl,
                          AppConstants.spacingLg,
                          0,
                        ),
                        child: const WeatherCard(),
                      ),
                    ),

                    // Category Tabs
                    SliverToArea(
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppConstants.spacingLg,
                          AppConstants.radiusXl,
                          AppConstants.spacingLg,
                          0,
                        ),
                        child: CategoryTabs(),
                      ),
                    ),

                    // Devices Grid
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppConstants.spacingLg,
                        AppConstants.radiusXl,
                        AppConstants.spacingLg,
                        AppConstants.bottomNavHeight + AppConstants.spacing2Xl,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppConstants.spacingLg,
                          mainAxisSpacing: AppConstants.spacingLg,
                          childAspectRatio: 0.95,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final device = deviceProvider.filteredDevices[index];
                            return DeviceCard(
                              device: device,
                              index: index,
                              onTap: () async {
                                // Eğer EVISTAL's Humidifier'a tıklanırsa BLE tarama ekranını aç
                                if (device.id == '1') {
                                  // BLE Tarama ekranını aç
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          const BLEScanScreen(),
                                      transitionsBuilder:
                                          (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation = animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          ),
                                        );
                                      },
                                      transitionDuration:
                                          Duration(milliseconds: AppConstants.durationNormal),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          childCount: deviceProvider.filteredDevices.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

/// SliverToArea - Sliver içinde normal widget kullanmak için
class SliverToArea extends StatelessWidget {
  final Widget child;

  const SliverToArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: child);
  }
}


