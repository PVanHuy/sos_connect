import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/model/user/user_model.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  bool? success;
  String? message;
  @JsonKey(name: 'access_token')
  String? accessToken;
  UserModel? user;

  AuthModel({this.success, this.message, this.accessToken, this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}
