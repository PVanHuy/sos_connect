import 'package:latlong2/latlong.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
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

  factory MapSosItemModel.fromSosEvent(SosEventModel event) {
    final type = event.emergencyType;
    return MapSosItemModel(
      id: event.id?.trim() ?? '',
      type: type,
      urgencyScore: event.urgencyScoreText,
      time: event.createdAt.toRelativeTime,
      description: event.description?.trim() ?? '',
      address: event.addressText?.trim() ?? '',
      acceptButtonTextKey: type == SosEmergencyType.needRescue ? 'accept_mission' : 'accept_rescue',
      point: LatLng(event.lat ?? 0, event.lon ?? 0),
      imageUrl: event.image?.trim() ?? '',
    );
  }

  MapSosItemModel copyWith({
    String? id,
    SosEmergencyType? type,
    String? urgencyScore,
    String? time,
    String? description,
    String? address,
    String? acceptButtonTextKey,
    LatLng? point,
    String? imageUrl,
  }) {
    return MapSosItemModel(
      id: id ?? this.id,
      type: type ?? this.type,
      urgencyScore: urgencyScore ?? this.urgencyScore,
      time: time ?? this.time,
      description: description ?? this.description,
      address: address ?? this.address,
      acceptButtonTextKey: acceptButtonTextKey ?? this.acceptButtonTextKey,
      point: point ?? this.point,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
