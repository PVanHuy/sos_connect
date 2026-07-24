import 'package:sos_connect/pages/otp/otp_controller.dart';
import 'package:get/get.dart';

class OtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController(parameter: Get.arguments));
  }
}
