import 'package:json_annotation/json_annotation.dart';

part 'sos_chat_other_party_model.g.dart';

@JsonSerializable()
class SosChatOtherPartyModel {
  @JsonKey(name: 'userId')
  String? userId;
  String? name;
  String? avatar;

  SosChatOtherPartyModel({
    this.userId,
    this.name,
    this.avatar,
  });

  factory SosChatOtherPartyModel.fromJson(Map<String, dynamic> json) =>
      _$SosChatOtherPartyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SosChatOtherPartyModelToJson(this);
}
