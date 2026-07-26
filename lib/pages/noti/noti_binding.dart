import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:get/get.dart';

class NotiBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotiController());
  }
}
