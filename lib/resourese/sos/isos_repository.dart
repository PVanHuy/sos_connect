import 'package:get/get_connect/http/src/response/response.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos_connect/model/map/events_viewport_model.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class ISosRepository extends IBaseRepository {
  Future<String?> convertLocation(LatLng point);

  Future<Response> createSosRequest({
    required String type,
    String? description,
    double? lat,
    double? lon,
    String? addressText,
    String? phone,
    PostMedia? image,
  });

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
  });

  Future<EventsViewportModel> getEventsViewport({
    required double north,
    required double south,
    required double east,
    required double west,
    required num zoom,
    String? status,
    String? timeWindow,
  });

  Future<PaginationModel<SosEventModel>> getMySosRequests({int page = 1});

  Future<Response> cancelMySosRequest(String sosId);

  Future<Response> completeMySosRequest(String sosId);
}
