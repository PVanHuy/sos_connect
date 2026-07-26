import 'package:latlong2/latlong.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';

class MapSosItemModel {
  const MapSosItemModel({
    required this.id,
    required this.type,
    required this.urgencyScore,
    required this.time,
    required this.description,
    required this.address,
    required this.acceptButtonTextKey,
    required this.point,
    this.imageUrl = '',
  });

  final String id;
  final SosEmergencyType type;
  final String urgencyScore;
  final String time;
  final String description;
  final String address;
  final String acceptButtonTextKey;
  final LatLng point;
  final String imageUrl;
}
