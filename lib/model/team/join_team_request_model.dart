import 'package:json_annotation/json_annotation.dart';

part 'join_team_request_model.g.dart';

@JsonSerializable()
class JoinTeamRequestUserModel {
  String? id;
  String? username;
  String? phone;
  String? avatar;

  JoinTeamRequestUserModel({this.id, this.username, this.phone, this.avatar});

  factory JoinTeamRequestUserModel.fromJson(Map<String, dynamic> json) => _$JoinTeamRequestUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$JoinTeamRequestUserModelToJson(this);
}

@JsonSerializable()
class JoinTeamRequestModel {
  String? id;
  @JsonKey(name: 'team_id')
  String? teamId;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'request_message')
  String? requestMessage;
  @JsonKey(name: 'response_message')
  String? responseMessage;
  String? status;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'users')
  JoinTeamRequestUserModel? user;

  JoinTeamRequestModel({
    this.id,
    this.teamId,
    this.userId,
    this.requestMessage,
    this.responseMessage,
    this.status,
    this.createdAt,
    this.user,
  });

  factory JoinTeamRequestModel.fromJson(Map<String, dynamic> json) => _$JoinTeamRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$JoinTeamRequestModelToJson(this);
}
