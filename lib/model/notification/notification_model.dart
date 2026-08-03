import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/utils/json_utils.dart';

part 'notification_model.g.dart';

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

@JsonSerializable()
class NotificationModel {
  String? id;
  @JsonKey(name: 'user_id')
  String? userId;
  String? title;
  String? content;
  @JsonKey(name: 'image_url')
  String? imageUrl;
  String? type;
  String? action;
  @JsonKey(name: 'request_id')
  String? requestId;
  NotificationExtraData? data;
  @JsonKey(name: 'is_read', fromJson: parseToBool)
  bool isRead;
  @JsonKey(name: 'created_at')
  String? createdAt;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.content,
    this.imageUrl,
    this.type,
    this.action,
    this.requestId,
    this.data,
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? imageUrl,
    String? type,
    String? action,
    String? requestId,
    NotificationExtraData? data,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      action: action ?? this.action,
      requestId: requestId ?? this.requestId,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
