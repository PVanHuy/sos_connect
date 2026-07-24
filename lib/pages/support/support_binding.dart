import 'package:get/get.dart';
import 'package:sos_connect/pages/support/support_controller.dart';

class SupportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupportController());
  }
}
