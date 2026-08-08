import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/model/chat/pagination_chat_model.dart';
import 'package:sos_connect/model/chat/sos_chat_message_model.dart';
import 'package:sos_connect/model/chat/sos_chat_other_party_model.dart';

part 'sos_chat_history_model.g.dart';

@JsonSerializable()
class SosChatHistoryModel {
  List<SosChatMessageModel>? data;
  @JsonKey(name: 'other_party')
  SosChatOtherPartyModel? otherParty;
  PaginationChatModel? pagination;

  SosChatHistoryModel({
    this.data,
    this.otherParty,
    this.pagination,
  });

  List<SosChatMessageModel> get models => data ?? const [];

  factory SosChatHistoryModel.fromJson(Map<String, dynamic> json) => _$SosChatHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SosChatHistoryModelToJson(this);
}
