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

String? _readString(dynamic value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
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
  @JsonKey(name: 'sos_id')
  String? sosId;
  @JsonKey(name: 'message_id')
  String? messageId;
  @JsonKey(name: 'sender_id')
  String? senderId;
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
    this.sosId,
    this.messageId,
    this.senderId,
    this.reasonKicked,
    this.time,
    this.payload,
  });

  factory FcmNotificationModel.fromJson(Map<String, dynamic> json) {
    final model = _$FcmNotificationModelFromJson(json);
    model.notificationId ??= _readString(json['notification_id']);
    model.type ??= _readString(json['type']);
    model.action ??= _readString(json['action']);
    model.requestId ??= _readString(json['request_id']);
    model.sosId ??= _readString(json['sos_id']);
    model.messageId ??= _readString(json['message_id']);
    model.senderId ??= _readString(json['sender_id']);
    return model;
  }

  Map<String, dynamic> toJson() => _$FcmNotificationModelToJson(this);

  String? get teamId => payload?['team_id']?.toString();

  String? get resolvedSosId {
    final direct = sosId?.trim() ?? '';
    if (direct.isNotEmpty) return direct;
    final fromPayload = payload?['sos_id']?.toString().trim() ?? '';
    if (fromPayload.isNotEmpty) return fromPayload;
    final fromRequest = requestId?.trim() ?? '';
    return fromRequest.isNotEmpty ? fromRequest : null;
  }

  String? get resolvedNotificationId {
    final direct = notificationId?.trim() ?? '';
    if (direct.isNotEmpty) return direct;
    final fromMessage = messageId?.trim() ?? '';
    return fromMessage.isNotEmpty ? fromMessage : null;
  }

  String? get resolvedSosEmergencyApiType {
    final fromPayload = payload?['type']?.toString().trim() ?? '';
    if (fromPayload.isEmpty) return null;
    final upper = fromPayload.toUpperCase();
    if (upper == 'SOS_REQUEST' || upper == 'CHAT' || upper == 'JOIN_REQUEST') return null;
    return fromPayload;
  }

  String? get resolvedReasonKicked {
    final direct = reasonKicked?.trim() ?? '';
    if (direct.isNotEmpty) return direct;
    final fromPayload = payload?['reason_kicked']?.toString().trim() ?? '';
    return fromPayload.isNotEmpty ? fromPayload : null;
  }

  NotificationModel toNotificationModel() {
    return NotificationModel(
      id: resolvedNotificationId,
      title: title,
      content: content,
      imageUrl: imageUrl,
      type: type,
      action: action,
      requestId: resolvedSosId ?? requestId,
      isRead: false,
      createdAt: time,
    );
  }
}
