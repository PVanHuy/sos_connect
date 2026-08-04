import 'package:json_annotation/json_annotation.dart';

part 'team_member_model.g.dart';

@JsonSerializable()
class TeamMemberUserModel {
  String? id;
  String? phone;
  String? roles;
  String? avatar;
  String? username;

  TeamMemberUserModel({
    this.id,
    this.phone,
    this.roles,
    this.avatar,
    this.username,
  });

  factory TeamMemberUserModel.fromJson(Map<String, dynamic> json) => _$TeamMemberUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMemberUserModelToJson(this);
}

@JsonSerializable()
class TeamMemberModel {
  String? id;
  String? status;
  @JsonKey(name: 'joined_at')
  String? joinedAt;
  @JsonKey(name: 'users')
  TeamMemberUserModel? user;

  TeamMemberModel({
    this.id,
    this.status,
    this.joinedAt,
    this.user,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) => _$TeamMemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMemberModelToJson(this);
}
