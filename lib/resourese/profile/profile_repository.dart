import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';

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
}
