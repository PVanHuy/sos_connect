import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class IAuthRepository extends IBaseRepository {
  Future<Response> signIn(Map<String, String> params);

  Future<Response> signUp(Map<String, String> params);

  Future<Response> sendOtp(Map<String, String> params);

  Future<Response> verifyOtp(Map<String, String> params);

  Future<Response> forgotPassword(Map<String, String> params);

  Future<Response> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
}
