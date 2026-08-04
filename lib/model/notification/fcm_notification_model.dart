import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/model/notification/notification_model.dart';

part 'fcm_notification_model.g.dart';

Map<String, dynamic>? parseFcmPayload(dynamic value) {
  if (value == null) return null;
  if (value is Map) return Map<String, dynamic>.from(value);
  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  return null;
}

@JsonSerializable()
class FcmNotificationModel {
  @JsonKey(name: 'notification_id')
  String? notificationId;
  String? title;
  String? content;
  @JsonKey(name: 'image_url')
  String? imageUrl;
  String? type;
  String? action;
  @JsonKey(name: 'request_id')
  String? requestId;
  @JsonKey(name: 'reason_kicked')
  String? reasonKicked;
  String? time;
  @JsonKey(fromJson: parseFcmPayload)
  Map<String, dynamic>? payload;

  FcmNotificationModel({
    this.notificationId,
    this.title,
    this.content,
    this.imageUrl,
    this.type,
    this.action,
    this.requestId,
    this.reasonKicked,
    this.time,
    this.payload,
  });

  factory FcmNotificationModel.fromJson(Map<String, dynamic> json) => _$FcmNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$FcmNotificationModelToJson(this);

  String? get teamId => payload?['team_id']?.toString();

  String? get resolvedReasonKicked {
    final direct = reasonKicked?.trim() ?? '';
    if (direct.isNotEmpty) return direct;
    final fromPayload = payload?['reason_kicked']?.toString().trim() ?? '';
    return fromPayload.isNotEmpty ? fromPayload : null;
  }

  NotificationModel toNotificationModel() {
    return NotificationModel(
      id: notificationId,
      title: title,
      content: content,
      imageUrl: imageUrl,
      type: type,
      action: action,
      requestId: requestId,
      isRead: false,
      createdAt: time,
    );
  }
}
