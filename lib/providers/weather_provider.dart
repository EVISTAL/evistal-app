import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Hava Durumu Verisi Modeli
class WeatherData {
  final double temperature;
  final String condition;
  final String emoji;
  final int humidity;
  final double windSpeed;
  final int aqi;
  final DateTime lastUpdated;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.emoji,
    required this.humidity,
    required this.windSpeed,
    required this.aqi,
    required this.lastUpdated,
  });
}

/// Hava Durumu Provider
/// OpenMeteo API kullanarak gerçek zamanlı hava durumu verilerini yönetir
class WeatherProvider with ChangeNotifier {
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  Timer? _updateTimer;

  // Getters
  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  WeatherProvider() {
    // İlk yüklemede hava durumunu al
    fetchWeather();
    
    // Her 15 dakikada bir otomatik güncelle
    _updateTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      fetchWeather();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  /// Hava durumunu getir
  Future<void> fetchWeather() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. Konum izni kontrol et ve al
      final position = await _getCurrentLocation();
      
      if (position == null) {
        // Konum alınamazsa varsayılan konum kullan (İstanbul)
        await _fetchWeatherData(41.0082, 28.9784);
        return;
      }

      // 2. Gerçek konum ile hava durumu verilerini çek
      await _fetchWeatherData(position.latitude, position.longitude);
    } catch (e) {
      _error = 'Hava durumu yüklenemedi: $e';
      debugPrint('Weather fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mevcut konumu al
  Future<Position?> _getCurrentLocation() async {
    try {
      // Konum servislerinin açık olup olmadığını kontrol et
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Konum servisleri kapalı');
        return null;
      }

      // Konum iznini kontrol et
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Konum izni reddedildi');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Konum izni kalıcı olarak reddedildi');
        return null;
      }

      // Konumu al
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
    } catch (e) {
      debugPrint('Konum alma hatası: $e');
      return null;
    }
  }

  /// OpenMeteo API'sinden hava durumu verilerini çek
  Future<void> _fetchWeatherData(double lat, double lon) async {
    try {
      // OpenMeteo API endpoint'i
      final weatherUrl = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?'
        'latitude=$lat&longitude=$lon'
        '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m'
        '&timezone=auto',
      );

      // Hava kalitesi endpoint'i (European AQI)
      final airQualityUrl = Uri.parse(
        'https://air-quality-api.open-meteo.com/v1/air-quality?'
        'latitude=$lat&longitude=$lon'
        '&current=european_aqi'
        '&timezone=auto',
      );

      // API çağrılarını paralel yap
      final responses = await Future.wait([
        http.get(weatherUrl),
        http.get(airQualityUrl),
      ]);

      final weatherResponse = responses[0];
      final airQualityResponse = responses[1];

      if (weatherResponse.statusCode == 200 && airQualityResponse.statusCode == 200) {
        final weatherJson = json.decode(weatherResponse.body);
        final airQualityJson = json.decode(airQualityResponse.body);

        final current = weatherJson['current'];
        final currentAir = airQualityJson['current'];

        // Weather code'dan durum ve emoji belirle
        final weatherCode = current['weather_code'] as int;
        final weatherInfo = _getWeatherInfo(weatherCode);

        _weatherData = WeatherData(
          temperature: (current['temperature_2m'] as num).toDouble(),
          condition: weatherInfo['condition'] as String,
          emoji: weatherInfo['emoji'] as String,
          humidity: (current['relative_humidity_2m'] as num).toInt(),
          windSpeed: (current['wind_speed_10m'] as num).toDouble(),
          aqi: (currentAir['european_aqi'] as num?)?.toInt() ?? 50, // Varsayılan 50
          lastUpdated: DateTime.now(),
        );
      } else {
        throw Exception('API yanıt hatası: ${weatherResponse.statusCode}');
      }
    } catch (e) {
      debugPrint('Hava durumu API hatası: $e');
      // Hata durumunda varsayılan veri kullan
      _weatherData = WeatherData(
        temperature: 28.0,
        condition: 'Cloudy',
        emoji: '☁️',
        humidity: 55,
        windSpeed: 8.0,
        aqi: 37,
        lastUpdated: DateTime.now(),
      );
      rethrow;
    }
  }

  /// Weather code'dan durum ve emoji döndür
  /// WMO Weather interpretation codes
  Map<String, dynamic> _getWeatherInfo(int code) {
    switch (code) {
      case 0:
        return {'condition': 'Clear', 'emoji': _isNightTime() ? '🌙' : '☀️'};
      case 1:
      case 2:
        return {'condition': 'Partly Cloudy', 'emoji': '⛅'};
      case 3:
        return {'condition': 'Cloudy', 'emoji': '☁️'};
      case 45:
      case 48:
        return {'condition': 'Foggy', 'emoji': '🌫️'};
      case 51:
      case 53:
      case 55:
        return {'condition': 'Drizzle', 'emoji': '🌦️'};
      case 61:
      case 63:
      case 65:
        return {'condition': 'Rainy', 'emoji': '🌧️'};
      case 71:
      case 73:
      case 75:
        return {'condition': 'Snowy', 'emoji': '❄️'};
      case 77:
        return {'condition': 'Snow Grains', 'emoji': '🌨️'};
      case 80:
      case 81:
      case 82:
        return {'condition': 'Rain Showers', 'emoji': '🌧️'};
      case 85:
      case 86:
        return {'condition': 'Snow Showers', 'emoji': '🌨️'};
      case 95:
        return {'condition': 'Thunderstorm', 'emoji': '⛈️'};
      case 96:
      case 99:
        return {'condition': 'Thunderstorm', 'emoji': '⛈️'};
      default:
        return {'condition': 'Unknown', 'emoji': '🌈'};
    }
  }

  /// Gece mi gündüz mü kontrolü (basit versiyon)
  bool _isNightTime() {
    final hour = DateTime.now().hour;
    return hour < 6 || hour > 20;
  }

  /// Manuel yenileme
  Future<void> refresh() async {
    await fetchWeather();
  }
}

