import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/utils/json_utils.dart';

part 'rescue_team_model.g.dart';

@JsonSerializable()
class RescueTeamModel {
  String? id;
  String? name;
  String? province;
  String? district;
  String? commune;
  @JsonKey(name: 'size_member')
  String? sizeMember;
  String? organizational;
  String? leader;
  String? phone;
  String? position;
  @JsonKey(name: 'document_url')
  String? documentUrl;
  @JsonKey(name: 'leader_id')
  String? leaderId;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'team_status')
  String? teamStatus;
  String? email;
  @JsonKey(name: 'team_lat', fromJson: parseToDouble)
  double? teamLat;
  @JsonKey(name: 'team_lon', fromJson: parseToDouble)
  double? teamLon;
  @JsonKey(name: 'rejection_reason')
  String? rejectionReason;
  @JsonKey(name: 'delete_reason')
  String? deleteReason;

  RescueTeamModel({
    this.id,
    this.name,
    this.province,
    this.district,
    this.commune,
    this.sizeMember,
    this.organizational,
    this.leader,
    this.phone,
    this.position,
    this.documentUrl,
    this.leaderId,
    this.createdAt,
    this.teamStatus,
    this.email,
    this.teamLat,
    this.teamLon,
    this.rejectionReason,
    this.deleteReason,
  });

  factory RescueTeamModel.fromJson(Map<String, dynamic> json) => _$RescueTeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$RescueTeamModelToJson(this);
}
