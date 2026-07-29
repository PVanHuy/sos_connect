import 'package:json_annotation/json_annotation.dart';
import 'package:sos_connect/model/user/user_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  bool? success;
  String? message;
  @JsonKey(name: 'access_token')
  String? accessToken;
  UserModel? user;

  LoginResponseModel({
    this.success,
    this.message,
    this.accessToken,
    this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
