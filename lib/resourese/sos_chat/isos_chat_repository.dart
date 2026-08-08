import 'package:sos_connect/model/chat/sos_chat_history_model.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class ISosChatRepository extends IBaseRepository {
  Future<SosChatHistoryModel> getChatHistory(String sosId, {int page = 1});
}
