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
      var justGranted = false;
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const LocationResult.failure('location_permission_denied');
        }
        justGranted =
            permission == LocationPermission.whileInUse || permission == LocationPermission.always;
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationResult.failure('location_permission_denied_forever');
      }

      // Ngay sau khi user vừa cấp quyền, GPS thường chưa sẵn sàng → ưu tiên last known + retry.
      if (justGranted) {
        final lastKnown = await _lastKnownLatLng();
        if (lastKnown != null) return LocationResult.success(lastKnown);
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }

      return await _getPositionWithRetry(accuracy: accuracy, timeLimit: timeLimit);
    } catch (e) {
      loggerHelper.error('getCurrentLatLng error: $e');
      return const LocationResult.failure('location_get_failed');
    }
  }

  static Future<LocationResult> _getPositionWithRetry({
    required LocationAccuracy accuracy,
    required Duration timeLimit,
  }) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: accuracy, timeLimit: timeLimit),
      );
      return LocationResult.success(LatLng(position.latitude, position.longitude));
    } catch (e) {
      loggerHelper.error('getCurrentPosition first attempt error: $e');

      final lastKnown = await _lastKnownLatLng();
      if (lastKnown != null) return LocationResult.success(lastKnown);

      try {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        final position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: timeLimit,
          ),
        );
        return LocationResult.success(LatLng(position.latitude, position.longitude));
      } catch (retryError) {
        loggerHelper.error('getCurrentPosition retry error: $retryError');
        return const LocationResult.failure('location_get_failed');
      }
    }
  }

  static Future<LatLng?> _lastKnownLatLng() async {
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last == null) return null;
      return LatLng(last.latitude, last.longitude);
    } catch (e) {
      loggerHelper.error('getLastKnownPosition error: $e');
      return null;
    }
  }

  static String latLngFallback(LatLng point) => '${point.latitude}, ${point.longitude}';
}
