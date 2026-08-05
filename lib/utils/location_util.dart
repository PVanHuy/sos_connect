import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos_connect/utils/logger_helper.dart';

class LocationResult {
  const LocationResult._({this.position, this.errorKey});

  const LocationResult.success(LatLng position) : this._(position: position);

  const LocationResult.failure(String errorKey) : this._(errorKey: errorKey);

  final LatLng? position;
  final String? errorKey;

  bool get isSuccess => position != null;
}

class LocationUtil {
  LocationUtil._();

  /// Lấy vị trí hiện tại (LatLng). Tự kiểm tra GPS + xin quyền nếu cần.
  static Future<LocationResult> getCurrentLatLng({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeLimit = const Duration(seconds: 15),
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationResult.failure('location_service_disabled');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const LocationResult.failure('location_permission_denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationResult.failure('location_permission_denied_forever');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: accuracy, timeLimit: timeLimit),
      );

      return LocationResult.success(LatLng(position.latitude, position.longitude));
    } catch (e) {
      loggerHelper.error('getCurrentLatLng error: $e');
      return const LocationResult.failure('location_get_failed');
    }
  }

  static String latLngFallback(LatLng point) => '${point.latitude}, ${point.longitude}';
}
