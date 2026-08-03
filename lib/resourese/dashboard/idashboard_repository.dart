import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class IDashboardRepository extends IBaseRepository {
  Future<Response> updateFcmToken(String fcmToken);
}
