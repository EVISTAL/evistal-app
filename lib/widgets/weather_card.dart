import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/weather_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

/// Hava Durumu Kartı Widget
/// Ana ekranda hava durumu bilgilerini gösterir
class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; // Temadan renkleri al
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final weatherProvider = context.watch<WeatherProvider>();
    final weatherData = weatherProvider.weatherData;
    final isLoading = weatherProvider.isLoading;
    final error = weatherProvider.error;

    // Hata varsa error state göster
    if (error != null && weatherData == null) {
      return _buildErrorState(context, colors, isDarkMode, weatherProvider, error);
    }

    // Veri yüklenirken veya hata varsa varsayılan değerler göster
    final temperature = weatherData?.temperature.toStringAsFixed(0) ?? '--';
    final condition = weatherData?.condition ?? (isLoading ? 'Loading...' : 'No Data');
    final emoji = weatherData?.emoji ?? (isLoading ? '⏳' : '🌈');
    final humidity = weatherData?.humidity.toString() ?? '--';
    final windSpeed = weatherData?.windSpeed.toStringAsFixed(0) ?? '--';
    final aqi = weatherData?.aqi.toString() ?? '--';

    return GestureDetector(
      onTap: () {
        // Manuel yenileme
        weatherProvider.refresh();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          gradient: colors.activeGradient,
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.2)
                  : colors.gray500.withOpacity(0.3),
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
                            condition,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeTitle,
                              color: (isDarkMode
                                      ? colors.cardBackgroundAlt
                                      : Colors.white)
                                  .withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingXs),
                          Text(
                            '$temperature°',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeExtraLarge,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode
                                  ? colors.cardBackgroundAlt
                                  : Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),

                      // Sağ taraf - Emoji
                      Text(
                        emoji,
                        style: const TextStyle(fontSize: AppConstants.fontSizeExtraLarge),
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
                        value: aqi,
                      ),
                      _WeatherStat(
                        label: 'Humidity',
                        value: '$humidity%',
                      ),
                      _WeatherStat(
                        label: 'Wind',
                        value: '$windSpeed km/h',
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

  /// Hata durumu widget'ı - Retry button ile
  Widget _buildErrorState(
    BuildContext context,
    AppColorScheme colors,
    bool isDarkMode,
    WeatherProvider weatherProvider,
    String errorMessage,
  ) {
    return GestureDetector(
      onTap: () => weatherProvider.refresh(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.radiusXl),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          gradient: colors.activeGradient,
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.2)
                  : colors.gray500.withOpacity(0.3),
              blurRadius: AppConstants.radiusXl,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Icon(
              LucideIcons.cloudOff,
              size: 48,
              color: (isDarkMode ? colors.cardBackgroundAlt : Colors.white)
                  .withOpacity(0.9),
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Error Title
            Text(
              'Weather Unavailable',
              style: TextStyle(
                fontSize: AppConstants.fontSizeTitle,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? colors.cardBackgroundAlt : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingSm),

            // Error Message
            Text(
              'Tap to retry',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSubheadline,
                color: (isDarkMode ? colors.cardBackgroundAlt : Colors.white)
                    .withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Retry Button
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.radiusXl,
                vertical: AppConstants.spacingSm,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                color: (isDarkMode ? colors.cardBackgroundAlt : Colors.white)
                    .withOpacity(0.2),
                border: Border.all(
                  color: (isDarkMode ? colors.cardBackgroundAlt : Colors.white)
                      .withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.refreshCw,
                    size: 16,
                    color: isDarkMode ? colors.cardBackgroundAlt : Colors.white,
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSubheadline,
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode ? colors.cardBackgroundAlt : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate()
          .scale(
            duration: AppConstants.durationNormal.ms,
            begin: const Offset(0.95, 0.95),
            curve: Curves.easeOut,
          )
          .fadeIn(duration: AppConstants.durationNormal.ms),
    );
  }
}

/// Hava durumu istatistik bilgisi
class _WeatherStat extends StatelessWidget {
  final String label;
  final String value;

  const _WeatherStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; // Temadan renkleri al
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.fontSizeSubheadline,
            color: (isDarkMode ? colors.cardBackgroundAlt : Colors.white)
                .withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: AppConstants.fontSizeSubheadline,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? colors.cardBackgroundAlt : Colors.white,
          ),
        ),
      ],
    );
  }
}
