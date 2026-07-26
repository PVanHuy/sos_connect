import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sos_connect/utils/logger_helper.dart';

class WeatherInfo {
  const WeatherInfo({
    required this.temperature,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
  });

  final double temperature;
  final int weatherCode;
  final double tempMax;
  final double tempMin;

  String get temperatureLabel => '${temperature.round()}°C';

  String get todayRangeLabel => '${tempMin.round()}° / ${tempMax.round()}°';
}

class WeatherUtil {
  WeatherUtil._();

  /// Lấy thời tiết hiện tại + nhiệt độ ngày hôm nay (Open-Meteo, không cần API key).
  static Future<WeatherInfo?> fetchCurrentWeather({required double latitude, required double longitude}) async {
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current=temperature_2m,weather_code'
        '&daily=temperature_2m_max,temperature_2m_min'
        '&timezone=auto'
        '&forecast_days=1',
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) {
        loggerHelper.error('Weather API failed: ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>?;
      final daily = data['daily'] as Map<String, dynamic>?;
      if (current == null || daily == null) return null;

      final maxList = daily['temperature_2m_max'] as List<dynamic>?;
      final minList = daily['temperature_2m_min'] as List<dynamic>?;

      return WeatherInfo(
        temperature: (current['temperature_2m'] as num).toDouble(),
        weatherCode: (current['weather_code'] as num).toInt(),
        tempMax: (maxList?.first as num?)?.toDouble() ?? (current['temperature_2m'] as num).toDouble(),
        tempMin: (minList?.first as num?)?.toDouble() ?? (current['temperature_2m'] as num).toDouble(),
      );
    } catch (e) {
      loggerHelper.error('fetchCurrentWeather error: $e');
      return null;
    }
  }

  /// WMO weather interpretation codes → i18n key.
  static String weatherDescriptionKey(int code) {
    if (code == 0) return 'weather_clear';
    if (code == 1 || code == 2) return 'weather_partly_cloudy';
    if (code == 3) return 'weather_cloudy';
    if (code == 45 || code == 48) return 'weather_fog';
    if (code >= 51 && code <= 67) return 'weather_rain';
    if (code >= 71 && code <= 77) return 'weather_snow';
    if (code >= 80 && code <= 82) return 'weather_rain';
    if (code >= 85 && code <= 86) return 'weather_snow';
    if (code >= 95) return 'weather_thunderstorm';
    return 'weather_cloudy';
  }
}
