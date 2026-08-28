import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/model/notification/notification_extra_data_model.dart';
import 'package:sos_connect/model/notification/notification_model.dart';
import 'package:sos_connect/utils/noti_type_utils.dart';

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
  String? reason;
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
    this.reason,
    this.time,
    this.payload,
  });

  factory FcmNotificationModel.fromJson(Map<String, dynamic> json) {
    final model = _$FcmNotificationModelFromJson(json);
    model.notificationId ??= _readString(json['notification_id']) ?? _readString(json['id']);
    model.type ??= _readString(json['type']);
    model.action ??= _readString(json['action']);
    model.requestId ??= _readString(json['request_id']);
    model.sosId ??= _readString(json['sos_id']);
    model.messageId ??= _readString(json['message_id']);
    model.senderId ??= _readString(json['sender_id']);
    model.reason ??= _readString(json['reason']);
    return model;
  }

  Map<String, dynamic> toJson() => _$FcmNotificationModelToJson(this);

  String? get teamId {
    final fromPayload = payload?['team_id']?.toString().trim() ?? '';
    return fromPayload.isNotEmpty ? fromPayload : null;
  }

  String? get appealId {
    final fromPayload = payload?['appeal_id']?.toString().trim() ?? '';
    if (fromPayload.isNotEmpty) return fromPayload;
    if ((type ?? '').trim() == NotiTypeUtils.appeal) {
      final fromRequest = requestId?.trim() ?? '';
      return fromRequest.isNotEmpty ? fromRequest : null;
    }
    return null;
  }

  String? get targetType {
    final fromPayload = payload?['target_type']?.toString().trim() ?? '';
    return fromPayload.isNotEmpty ? fromPayload : null;
  }

  String? get targetId {
    final fromPayload = payload?['target_id']?.toString().trim() ?? '';
    return fromPayload.isNotEmpty ? fromPayload : null;
  }

  String? get resolvedSosId {
    final direct = sosId?.trim() ?? '';
    if (direct.isNotEmpty) return direct;
    final fromPayload = payload?['sos_id']?.toString().trim() ?? '';
    if (fromPayload.isNotEmpty) return fromPayload;
    final fromRequest = requestId?.trim() ?? '';
    return fromRequest.isNotEmpty ? fromRequest : null;
  }

  /// Id dùng để PATCH /notification/{id}/read — không dùng message_id (chat).
  String? get resolvedNotificationId {
    final direct = notificationId?.trim() ?? '';
    return direct.isNotEmpty ? direct : null;
  }

  String? get resolvedSosEmergencyApiType {
    final fromPayload = payload?['type']?.toString().trim() ?? '';
    if (fromPayload.isEmpty) return null;
    final upper = fromPayload.toUpperCase();
    if (upper == 'SOS_REQUEST' || upper == 'CHAT' || upper == 'JOIN_REQUEST') return null;
    return fromPayload;
  }

  String? get resolvedReason {
    final direct = reason?.trim() ?? '';
    if (direct.isNotEmpty) return direct;
    final kicked = reasonKicked?.trim() ?? '';
    if (kicked.isNotEmpty) return kicked;
    final fromPayload = payload?['reason']?.toString().trim() ?? '';
    if (fromPayload.isNotEmpty) return fromPayload;
    final fromPayloadKicked = payload?['reason_kicked']?.toString().trim() ?? '';
    return fromPayloadKicked.isNotEmpty ? fromPayloadKicked : null;
  }

  String? get resolvedReasonKicked => resolvedReason;

  NotificationModel toNotificationModel() {
    return NotificationModel(
      id: resolvedNotificationId,
      title: title,
      content: content,
      imageUrl: imageUrl,
      type: type,
      action: action,
      requestId: appealId ?? resolvedSosId ?? requestId,
      isRead: false,
      createdAt: time,
      data: NotificationExtraData(
        teamId: teamId,
        reason: resolvedReason,
        sosId: resolvedSosId,
        appealId: appealId,
        targetType: targetType,
        targetId: targetId,
      ),
    );
  }
}
