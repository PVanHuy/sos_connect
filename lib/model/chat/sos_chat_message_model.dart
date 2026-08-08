import 'package:json_annotation/json_annotation.dart';

part 'sos_chat_message_model.g.dart';

@JsonSerializable()
class SosChatMessageModel {
  String? id;
  @JsonKey(name: 'sos_id')
  String? sosId;
  @JsonKey(name: 'sender_id')
  String? senderId;
  String? content;
  @JsonKey(name: 'created_at')
  String? createdAt;

  SosChatMessageModel({
    this.id,
    this.sosId,
    this.senderId,
    this.content,
    this.createdAt,
  });

  factory SosChatMessageModel.fromJson(Map<String, dynamic> json) => _$SosChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$SosChatMessageModelToJson(this);
}
