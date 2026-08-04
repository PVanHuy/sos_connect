import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/utils/json_utils.dart';

part 'pagination_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginationModel<T> {
  @JsonKey(fromJson: parseToInt)
  int? total;

  @JsonKey(name: 'unread_count', fromJson: parseToInt)
  int? unreadCount;

  @JsonKey(name: 'count_member', fromJson: parseToInt)
  int? countMember;

  @JsonKey(name: 'count_request', fromJson: parseToInt)
  int? countRequest;

  List<T> models;

  PaginationModel({this.total, this.unreadCount, this.countMember, this.countRequest, this.models = const []});

  factory PaginationModel.fromJsonList(
    Map<String, dynamic>? json,
    List<T> models, {
    int? unreadCount,
    int? countMember,
    int? countRequest,
  }) {
    return PaginationModel(
      models: models,
      total: parseToInt(json?['total']) ?? models.length,
      unreadCount: unreadCount,
      countMember: countMember,
      countRequest: countRequest,
    );
  }

  factory PaginationModel.fromJsonListToMeta(int? total, List<T> models) {
    return PaginationModel(models: models, total: total ?? 0);
  }

  factory PaginationModel.fromApi(
    dynamic body,
    T Function(Map<String, dynamic> json) fromJson, {
    String listKey = 'data',
    String paginationKey = 'pagination',
  }) {
    final map = body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    final rawList = map[listKey] is List ? map[listKey] as List : const [];
    final models = rawList.whereType<Map>().map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
    final pagination = map[paginationKey] is Map ? Map<String, dynamic>.from(map[paginationKey] as Map) : null;
    return PaginationModel.fromJsonList(
      pagination,
      models,
      unreadCount: parseToInt(map['unread_count']),
      countMember: parseToInt(map['count_member']),
      countRequest: parseToInt(map['count_request']),
    );
  }

  factory PaginationModel.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PaginationModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$PaginationModelToJson(this, toJsonT);
}
