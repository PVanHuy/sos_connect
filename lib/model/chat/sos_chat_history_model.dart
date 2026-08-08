import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/model/chat/sos_chat_message_model.dart';
import 'package:sos_connect/model/chat/sos_chat_other_party_model.dart';
import 'package:sos_connect/utils/json_utils.dart';

part 'sos_chat_history_model.g.dart';

@JsonSerializable()
class SosChatPaginationModel {
  @JsonKey(fromJson: parseToInt)
  int? total;
  @JsonKey(fromJson: parseToInt)
  int? page;
  @JsonKey(fromJson: parseToInt)
  int? limit;
  @JsonKey(name: 'totalPages', fromJson: parseToInt)
  int? totalPages;

  SosChatPaginationModel({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  bool get hasNext => (page ?? 1) < (totalPages ?? 1);

  factory SosChatPaginationModel.fromJson(Map<String, dynamic> json) => _$SosChatPaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$SosChatPaginationModelToJson(this);
}

@JsonSerializable()
class SosChatHistoryModel {
  List<SosChatMessageModel>? data;
  @JsonKey(name: 'other_party')
  SosChatOtherPartyModel? otherParty;
  SosChatPaginationModel? pagination;

  SosChatHistoryModel({
    this.data,
    this.otherParty,
    this.pagination,
  });

  List<SosChatMessageModel> get models => data ?? const [];

  factory SosChatHistoryModel.fromJson(Map<String, dynamic> json) => _$SosChatHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SosChatHistoryModelToJson(this);
}
