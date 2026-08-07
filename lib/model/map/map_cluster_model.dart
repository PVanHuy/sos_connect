import 'package:latlong2/latlong.dart';
import 'package:sos_connect/utils/json_utils.dart';

class MapClusterModel {
  const MapClusterModel({
    required this.point,
    required this.count,
  });

  final LatLng point;
  final int count;

  factory MapClusterModel.fromJson(Map<String, dynamic> json) {
    return MapClusterModel(
      point: LatLng(
        parseToDouble(json['cluster_lat']) ?? parseToDouble(json['lat']) ?? 0,
        parseToDouble(json['cluster_lon']) ?? parseToDouble(json['lon']) ?? 0,
      ),
      count: parseToInt(json['count']) ?? 0,
    );
  }
}
