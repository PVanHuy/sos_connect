import 'package:sos_connect/pages/chat/chat_controller.dart';
import 'package:sos_connect/resourese/chat/chat_repository.dart';
import 'package:sos_connect/resourese/chat/ichat_repository.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IChatRepository>(() => ChatRepository());
    Get.lazyPut(() => ChatController(chatRepository: Get.find<IChatRepository>()));
  }
}
