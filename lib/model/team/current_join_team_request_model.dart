import 'package:json_annotation/json_annotation.dart';

part 'current_join_team_request_model.g.dart';

@JsonSerializable()
class CurrentJoinTeamRequestModel {
  String? id;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'team_id')
  String? teamId;
  String? status;
  @JsonKey(name: 'request_message')
  String? requestMessage;
  @JsonKey(name: 'response_message')
  String? responseMessage;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'responded_at')
  String? respondedAt;
  @JsonKey(name: 'responded_by')
  String? respondedBy;

  CurrentJoinTeamRequestModel({
    this.id,
    this.userId,
    this.teamId,
    this.status,
    this.requestMessage,
    this.responseMessage,
    this.createdAt,
    this.respondedAt,
    this.respondedBy,
  });

  factory CurrentJoinTeamRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentJoinTeamRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentJoinTeamRequestModelToJson(this);

  CurrentJoinTeamRequestModel copyWith({
    String? id,
    String? userId,
    String? teamId,
    String? status,
    String? requestMessage,
    String? responseMessage,
    String? createdAt,
    String? respondedAt,
    String? respondedBy,
  }) {
    return CurrentJoinTeamRequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      teamId: teamId ?? this.teamId,
      status: status ?? this.status,
      requestMessage: requestMessage ?? this.requestMessage,
      responseMessage: responseMessage ?? this.responseMessage,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
      respondedBy: respondedBy ?? this.respondedBy,
    );
  }
}
