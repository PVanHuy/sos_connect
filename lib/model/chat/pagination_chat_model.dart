import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/utils/json_utils.dart';

part 'pagination_chat_model.g.dart';

@JsonSerializable()
class PaginationChatModel {
  @JsonKey(fromJson: parseToInt)
  int? total;
  @JsonKey(fromJson: parseToInt)
  int? page;
  @JsonKey(fromJson: parseToInt)
  int? limit;
  @JsonKey(name: 'totalPages', fromJson: parseToInt)
  int? totalPages;

  PaginationChatModel({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  bool get hasNext => (page ?? 1) < (totalPages ?? 1);

  factory PaginationChatModel.fromJson(Map<String, dynamic> json) => _$PaginationChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationChatModelToJson(this);
}
