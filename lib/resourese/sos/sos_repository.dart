import 'package:get/get_connect/http/src/response/response.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos_connect/model/map/events_viewport_model.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';
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

  @override
  Future<Response> createSosRequest({
    required String type,
    String? description,
    double? lat,
    double? lon,
    String? addressText,
    String? phone,
    PostMedia? image,
  }) async {
    try {
      final params = <String, String>{
        'type': type,
        if (description != null && description.isNotEmpty) 'description': description,
        if (lat != null) 'lat': lat.toString(),
        if (lon != null) 'lon': lon.toString(),
        if (addressText != null && addressText.isNotEmpty) 'address_text': addressText,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      };

      final multipartBody = <MultipartBody>[if (image?.file != null) MultipartBody('image', image!.file)];

      return await clientPostMultipartData(AppConstants.sosRequestUri, params, multipartBody);
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<PaginationModel<SosEventModel>> getEvents({
    int page = 1,
    String? status,
    String? type,
    String? userId,
    String? teamId,
    String? timeWindow,
    String? search,
    String? province,
    int? radius,
    double? centerLat,
    double? centerLon,
  }) async {
    try {
      final query = <String, String>{
        'page': page.toString(),
        'limit': AppConstants.LIMIT.toString(),
        if (status != null && status.isNotEmpty) 'status': status,
        if (type != null && type.isNotEmpty) 'type': type,
        if (userId != null && userId.isNotEmpty) 'userid': userId,
        if (teamId != null && teamId.isNotEmpty) 'teamId': teamId,
        if (timeWindow != null && timeWindow.isNotEmpty) 'time_window': timeWindow,
        if (search != null && search.isNotEmpty) 'search': search,
        if (province != null && province.isNotEmpty) 'province': province,
        if (radius != null) 'radius_meters': radius.toString(),
        if (centerLat != null) 'center_lat': centerLat.toString(),
        if (centerLon != null) 'center_lon': centerLon.toString(),
      };

      final response = await clientGetData('${AppConstants.eventsUri}?${Uri(queryParameters: query).query}');

      if (response.isOk) {
        return PaginationModel.fromApi(response.body, SosEventModel.fromJson);
      }

      return PaginationModel();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<EventsViewportModel> getEventsViewport({
    required double north,
    required double south,
    required double east,
    required double west,
    required num zoom,
    String? status,
    String? timeWindow,
  }) async {
    try {
      final query = <String, String>{
        'north': north.toString(),
        'south': south.toString(),
        'east': east.toString(),
        'west': west.toString(),
        'zoom': zoom.toString(),
        if (status != null && status.isNotEmpty) 'status': status,
        if (timeWindow != null && timeWindow.isNotEmpty) 'time_window': timeWindow,
      };

      final response = await clientGetData('${AppConstants.eventsViewportUri}?${Uri(queryParameters: query).query}');

      if (!response.isOk || response.body is! Map) {
        return const EventsViewportModel(type: EventsViewportType.markers);
      }

      return EventsViewportModel.fromJson(Map<String, dynamic>.from(response.body as Map));
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<PaginationModel<SosEventModel>> getMySosRequests({int page = 1}) async {
    try {
      final query = <String, String>{'page': page.toString(), 'limit': AppConstants.LIMIT.toString()};
      final response = await clientGetData('${AppConstants.userProfileSosUri}?${Uri(queryParameters: query).query}');

      if (!response.isOk) return PaginationModel();

      final body = response.body;
      if (body is List) {
        final models = body.whereType<Map>().map((e) => SosEventModel.fromJson(Map<String, dynamic>.from(e))).toList();
        return PaginationModel.fromJsonListToMeta(models.length, models);
      }

      return PaginationModel.fromApi(body, SosEventModel.fromJson);
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> cancelMySosRequest(String sosId) async {
    try {
      return await clientPostData(AppConstants.userProfileSosCancelUri(sosId), {});
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
