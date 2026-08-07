import 'package:sos_connect/model/map/map_cluster_model.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/utils/json_utils.dart';

enum EventsViewportType { markers, clusters }

class EventsViewportModel {
  const EventsViewportModel({
    required this.type,
    this.total = 0,
    this.markers = const [],
    this.clusters = const [],
  });

  final EventsViewportType type;
  final int total;
  final List<SosEventModel> markers;
  final List<MapClusterModel> clusters;

  bool get isClusters => type == EventsViewportType.clusters;

  factory EventsViewportModel.fromJson(Map<String, dynamic> json) {
    final typeRaw = (json['type']?.toString() ?? '').trim().toLowerCase();
    final type = typeRaw == 'clusters' ? EventsViewportType.clusters : EventsViewportType.markers;
    final rawList = json['data'] is List ? json['data'] as List : const [];

    if (type == EventsViewportType.clusters) {
      final clusters = rawList
          .whereType<Map>()
          .map((e) => MapClusterModel.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.count > 0)
          .toList();
      return EventsViewportModel(
        type: type,
        total: parseToInt(json['total']) ?? clusters.length,
        clusters: clusters,
      );
    }

    final markers = rawList
        .whereType<Map>()
        .map((e) => SosEventModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return EventsViewportModel(
      type: type,
      total: parseToInt(json['total']) ?? markers.length,
      markers: markers,
    );
  }
}
