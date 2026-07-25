import 'package:sos_connect/resourese/chat/ichat_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ChatRepository extends IChatRepository {
  @override
  Future<Response> sendChatMessage({
    required String message,
  }) async {
    try {
      final body = {
        'message': message,
      };
      final result = await clientPostData(AppConstants.chatbotChatUri, body);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
