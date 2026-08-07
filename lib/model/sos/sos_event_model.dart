import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/model/team/rescue_team_model.dart';
import 'package:sos_connect/utils/json_utils.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/utils/sos_status_utils.dart';

part 'sos_event_model.g.dart';

@JsonSerializable()
class SosEventModel {
  String? id;
  @JsonKey(name: 'userid')
  String? userId;
  String? type;
  String? description;
  @JsonKey(fromJson: parseToDouble)
  double? lat;
  @JsonKey(fromJson: parseToDouble)
  double? lon;
  @JsonKey(name: 'address_text')
  String? addressText;
  String? phone;
  String? image;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  String? teamId;
  String? status;
  @JsonKey(name: 'decided_by')
  String? decidedBy;
  @JsonKey(name: 'is_ai_edited', fromJson: parseToBoolNullable)
  bool? isAiEdited;
  String? location;
  @JsonKey(name: 'llm_score', fromJson: parseToDouble)
  double? llmScore;
  String? geom;
  String? province;
  @JsonKey(name: 'team_rescue')
  RescueTeamModel? teamRescue;

  SosEventModel({
    this.id,
    this.userId,
    this.type,
    this.description,
    this.lat,
    this.lon,
    this.addressText,
    this.phone,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.teamId,
    this.status,
    this.decidedBy,
    this.isAiEdited,
    this.location,
    this.llmScore,
    this.geom,
    this.province,
    this.teamRescue,
  });

  factory SosEventModel.fromJson(Map<String, dynamic> json) => _$SosEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$SosEventModelToJson(this);

  SosEmergencyType get emergencyType => SosEmergencyTypeExtension.fromApi(type);

  String get urgencyScoreText {
    final score = llmScore;
    if (score == null) return '--';
    final value = (score * 10).round().clamp(0, 10);
    return '$value/10';
  }

  bool get canMarkAsSafe {
    final value = status?.trim().toUpperCase() ?? '';
    return value.isEmpty ||
        value == SosStatusUtils.pending ||
        value == SosStatusUtils.inProgress ||
        value == SosStatusUtils.requested;
  }
}

bool? parseToBoolNullable(dynamic json) {
  if (json == null) return null;
  if (json is bool) return json;
  if (json is int) return json == 1;
  if (json is String) {
    final value = json.trim().toLowerCase();
    if (value == 'true' || value == '1') return true;
    if (value == 'false' || value == '0') return false;
  }
  return null;
}
