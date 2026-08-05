import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';

class AuthRepository extends IAuthRepository {
  @override
  Future<Response> signIn(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.loginUri, params);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> signUp(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.signUpUri, params);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> sendOtp(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.otpUri, params);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> verifyOtp(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.verifyOtpUri, params);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> forgotPassword(Map<String, String> params) async {
    try {
      final result = await clientPatchData(AppConstants.forgotPasswordUri, params);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      return await clientPostData(AppConstants.changePasswordUri, {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword,
      });
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
