import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/model/user/user_model.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class IProfileRepository extends IBaseRepository {
  Future<Response> profile();

  Future<UserModel?> getUserById(String userId);

  Future<Response> updateProfile(Map<String, dynamic> params, {PostMedia? avatar});

  Future<bool> logOut();
}
