import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class IProfileRepository extends IBaseRepository {
  Future<Response> profile();

  Future<Response> updateProfile(Map<String, dynamic> params, {PostMedia? avatar});

  Future<bool> logOut();
}
