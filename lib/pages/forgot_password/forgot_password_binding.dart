import 'package:get/get.dart';
import 'package:sos_connect/pages/forgot_password/forgot_password_controller.dart';

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController());
  }
}
