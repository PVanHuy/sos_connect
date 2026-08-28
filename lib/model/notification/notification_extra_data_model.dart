import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/model/notification/notification_user_data_model.dart';

part 'notification_extra_data_model.g.dart';

@JsonSerializable()
class NotificationExtraData {
  NotificationUserData? user;
  @JsonKey(name: 'team_id')
  String? teamId;
  @JsonKey(name: 'team_name')
  String? teamName;
  String? province;
  @JsonKey(name: 'leader_name')
  String? leaderName;
  @JsonKey(name: 'leader_phone')
  String? leaderPhone;
  @JsonKey(name: 'sent_at')
  String? sentAt;
  String? reason;
  @JsonKey(name: 'sos_id')
  String? sosId;
  @JsonKey(name: 'appeal_id')
  String? appealId;
  @JsonKey(name: 'target_type')
  String? targetType;
  @JsonKey(name: 'target_id')
  String? targetId;
  @JsonKey(name: 'response_message')
  String? responseMessage;

  NotificationExtraData({
    this.user,
    this.teamId,
    this.teamName,
    this.province,
    this.leaderName,
    this.leaderPhone,
    this.sentAt,
    this.reason,
    this.sosId,
    this.appealId,
    this.targetType,
    this.targetId,
    this.responseMessage,
  });

  factory NotificationExtraData.fromJson(Map<String, dynamic> json) => _$NotificationExtraDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationExtraDataToJson(this);
}
