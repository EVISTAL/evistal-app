import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

/// Hava Durumu Kartı Widget
/// Ana ekranda hava durumu bilgilerini gösterir
class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return GestureDetector(
      onTap: () {
        // Tıklama animasyonu için
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          gradient: isDarkMode ? AppColors.darkActiveGradient : AppColors.lightActiveGradient,
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.2)
                  : AppColors.lightGray500.withOpacity(0.3),
              blurRadius: AppConstants.radiusXl,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Glow Overlay - Breathing Animation
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
                children: [
                  // Üst satır - Durum ve Sıcaklık
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sol taraf - Durum ve Sıcaklık
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cloudy',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeTitle,
                              color: (isDarkMode
                                      ? AppColors.darkCardBackgroundAlt
                                      : Colors.white)
                                  .withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingXs),
                          Text(
                            '28°',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeExtraLarge,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode
                                  ? AppColors.darkCardBackgroundAlt
                                  : Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),

                      // Sağ taraf - Emoji
                      const Text(
                        '☁️',
                        style: TextStyle(fontSize: AppConstants.fontSizeExtraLarge),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.spacingLg),

                  // Alt satır - AQI, Nem, Rüzgar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _WeatherStat(
                        label: 'AQI',
                        value: '37',
                        isDarkMode: isDarkMode,
                      ),
                      _WeatherStat(
                        label: 'Humidity',
                        value: '55%',
                        isDarkMode: isDarkMode,
                      ),
                      _WeatherStat(
                        label: 'Wind',
                        value: '8 km/h',
                        isDarkMode: isDarkMode,
                      ),
                    ],
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
          begin: const Offset(0.95, 0.95),
          curve: Curves.easeOut,
        )
        .fadeIn(duration: AppConstants.durationNormal.ms);
  }
}

/// Hava durumu istatistik bilgisi
class _WeatherStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDarkMode;

  const _WeatherStat({
    required this.label,
    required this.value,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.fontSizeSubheadline,
            color: (isDarkMode ? AppColors.darkCardBackgroundAlt : Colors.white)
                .withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: AppConstants.fontSizeSubheadline,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppColors.darkCardBackgroundAlt : Colors.white,
          ),
        ),
      ],
    );
  }
}


