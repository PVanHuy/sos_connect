import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/model/user/user_model.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/dialog_utils.dart';

class ProfileRepository extends IProfileRepository {
  @override
  Future<Response> profile() async {
    try {
      final result = await clientGetData(AppConstants.userProfileUri);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      final id = userId.trim();
      if (id.isEmpty) return null;

      final result = await clientGetData(AppConstants.userDetailUri(id));
      if (!result.isOk) return null;

      final body = result.body;
      final raw = body is Map && body['data'] != null
          ? body['data']
          : body is Map && body['user'] != null
          ? body['user']
          : body;
      if (raw is! Map) return null;
      return UserModel.fromJson(Map<String, dynamic>.from(raw));
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> updateProfile(Map<String, dynamic> params, {PostMedia? avatar}) async {
    try {
      if (avatar != null && avatar.file != null) {
        final multipartBody = [MultipartBody('avatar', avatar.file)];
        final fields = params.map((key, value) => MapEntry(key, value?.toString() ?? ''));
        final result = await clientPatchMultipartData(AppConstants.userProfileUri, fields, multipartBody);
        return result;
      } else {
        final result = await clientPatchData(AppConstants.userProfileUri, params);
        return result;
      }
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String? deviceId;

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      }

      final response = await clientPostData(AppConstants.logOutUri, {
        'device_id': deviceId.toString(),
        'platform': Platform.isIOS ? 'ios' : 'android',
      });

      if (response.isOk) {
        return true;
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
        return false;
      }
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
