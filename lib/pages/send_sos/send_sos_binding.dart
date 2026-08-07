import 'package:get/get.dart';
import 'package:sos_connect/pages/send_sos/send_sos_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';

class SendSosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SendSosController(sosRepository: Get.find<ISosRepository>()));
  }
}
