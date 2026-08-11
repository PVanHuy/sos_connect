import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/weather_util.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class MapWeatherBarWidget extends StatelessWidget {
  const MapWeatherBarWidget({super.key, required this.weather, required this.isLoading});

  final WeatherInfo? weather;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackColor.withSafeOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isLoading && weather == null
          ? Row(
              children: [
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(strokeWidth: 2, color: appTheme.appColor),
                ),
                SizedBox(width: 10.w),
                Text('loading_weather'.tr, style: StyleThemeData.size14Weight400(color: appTheme.gray83Color)),
              ],
            )
          : weather == null
          ? Text('weather_unavailable'.tr, style: StyleThemeData.size14Weight400(color: appTheme.gray83Color))
          : Row(
              children: [
                Icon(_weatherIcon(weather!.weatherCode), size: 28.w, color: appTheme.appColor),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weatherTitle(weather!),
                        style: StyleThemeData.size14Weight700(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'weather_today_range'.trParams({'range': weather!.todayRangeLabel}),
                        style: StyleThemeData.size12Weight400(color: appTheme.gray83Color),
                      ),
                    ],
                  ),
                ),
                Text(weather!.temperatureLabel, style: StyleThemeData.size20Weight700(color: appTheme.appColor)),
              ],
            ),
    );
  }

  IconData _weatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code == 1 || code == 2) return Icons.wb_cloudy_rounded;
    if (code == 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.blur_on_rounded;
    if (code >= 51 && code <= 67) return Icons.umbrella_rounded;
    if (code >= 71 && code <= 77) return Icons.ac_unit_rounded;
    if (code >= 80 && code <= 82) return Icons.grain_rounded;
    if (code >= 85 && code <= 86) return Icons.ac_unit_rounded;
    if (code >= 95) return Icons.thunderstorm_rounded;
    return Icons.cloud_rounded;
  }

  String _weatherTitle(WeatherInfo weather) {
    final description = WeatherUtil.weatherDescriptionKey(weather.weatherCode).tr;
    final location = weather.locationName?.trim() ?? '';
    if (location.isEmpty) return description;
    return '$location - $description';
  }
}
