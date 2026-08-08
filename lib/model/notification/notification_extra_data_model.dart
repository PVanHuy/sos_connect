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

  NotificationExtraData({
    this.user,
    this.teamId,
    this.teamName,
    this.province,
    this.leaderName,
    this.leaderPhone,
    this.sentAt,
  });

  factory NotificationExtraData.fromJson(Map<String, dynamic> json) => _$NotificationExtraDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationExtraDataToJson(this);
}
