import 'package:get/get.dart';
import 'package:sos_connect/pages/sos_chat/sos_chat_controller.dart';
import 'package:sos_connect/pages/sos_chat/sos_chat_parameter.dart';
import 'package:sos_connect/resourese/service/socket/sos_chat_socket_service.dart';
import 'package:sos_connect/resourese/sos_chat/isos_chat_repository.dart';

class SosChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SosChatController(
        sosChatRepository: Get.find<ISosChatRepository>(),
        chatSocketService: Get.find<SosChatSocketService>(),
        parameter: Get.arguments as SosChatParameter,
      ),
    );
  }
}
