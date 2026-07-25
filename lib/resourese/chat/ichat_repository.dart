import 'package:sos_connect/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IChatRepository extends IBaseRepository {
  Future<Response> sendChatMessage({
    required String message,
  });
}
