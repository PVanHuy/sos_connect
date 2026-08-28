import 'package:json_annotation/json_annotation.dart';

part 'appeal_model.g.dart';

String? _readString(dynamic value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

@JsonSerializable()
class AppealModel {
  String? id;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'target_type')
  String? targetType;
  @JsonKey(name: 'target_id')
  String? targetId;
  String? reason;
  String? status;
  @JsonKey(name: 'admin_response')
  String? adminResponse;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;

  AppealModel({
    this.id,
    this.userId,
    this.targetType,
    this.targetId,
    this.reason,
    this.status,
    this.adminResponse,
    this.createdAt,
    this.updatedAt,
  });

  factory AppealModel.fromJson(Map<String, dynamic> json) {
    final model = _$AppealModelFromJson(json);
    model.adminResponse ??= _readString(json['response_message']);
    return model;
  }

  Map<String, dynamic> toJson() => _$AppealModelToJson(this);
}
