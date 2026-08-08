import 'package:json_annotation/json_annotation.dart';

part 'notification_user_data_model.g.dart';

@JsonSerializable()
class NotificationUserData {
  String? id;
  String? time;
  String? phone;
  String? reason;
  String? username;

  NotificationUserData({this.id, this.time, this.phone, this.reason, this.username});

  factory NotificationUserData.fromJson(Map<String, dynamic> json) => _$NotificationUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationUserDataToJson(this);
}
