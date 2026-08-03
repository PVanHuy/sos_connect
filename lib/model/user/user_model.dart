import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? id;
  String? username;
  String? avatar;
  String? dob;
  String? address;
  String? phone;
  String? roles;
  @JsonKey(name: 'team_id')
  String? teamId;
  String? email;
  String? cccd;
  String? province;

  UserModel({
    this.id,
    this.username,
    this.avatar,
    this.dob,
    this.address,
    this.phone,
    this.roles,
    this.teamId,
    this.email,
    this.cccd,
    this.province,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? username,
    String? avatar,
    String? dob,
    String? address,
    String? phone,
    String? roles,
    String? teamId,
    String? email,
    String? cccd,
    String? province,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      roles: roles ?? this.roles,
      teamId: teamId ?? this.teamId,
      email: email ?? this.email,
      cccd: cccd ?? this.cccd,
      province: province ?? this.province,
    );
  }
}
