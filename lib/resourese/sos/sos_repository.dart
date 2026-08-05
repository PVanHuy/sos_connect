import 'package:latlong2/latlong.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/location_util.dart';
import 'package:sos_connect/utils/logger_helper.dart';

class SosRepository extends ISosRepository {
  @override
  Future<String?> convertLocation(LatLng point) async {
    try {
      final response = await clientPostData(AppConstants.sosConvertUri, {
        'lat': point.latitude,
        'lon': point.longitude,
      });

      if (!response.isOk) return LocationUtil.latLngFallback(point);

      final body = response.body;
      if (body is! Map) return LocationUtil.latLngFallback(point);

      final locationName = body['location_name']?.toString().trim() ?? '';
      if (locationName.isNotEmpty) return locationName;

      return LocationUtil.latLngFallback(point);
    } catch (e) {
      loggerHelper.error('convertLocation error: $e');
      return LocationUtil.latLngFallback(point);
    }
  }
}
