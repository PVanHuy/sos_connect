import 'package:sos_connect/model/chat/sos_chat_history_model.dart';
import 'package:sos_connect/resourese/sos_chat/isos_chat_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/logger_helper.dart';

class SosChatRepository extends ISosChatRepository {
  @override
  Future<SosChatHistoryModel> getChatHistory(String sosId, {int page = 1}) async {
    try {
      final query = <String, String>{'page': page.toString(), 'limit': AppConstants.LIMIT.toString()};
      final response = await clientGetData(
        '${AppConstants.chatHistoryUri(sosId)}?${Uri(queryParameters: query).query}',
      );
      if (!response.isOk || response.body is! Map) return SosChatHistoryModel();

      return SosChatHistoryModel.fromJson(Map<String, dynamic>.from(response.body as Map));
    } catch (e) {
      loggerHelper.error('getChatHistory error: $e');
      handleError(e);
      rethrow;
    }
  }
}
