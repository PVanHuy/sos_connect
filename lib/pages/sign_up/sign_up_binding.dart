import 'package:get/get.dart';
import 'package:sos_connect/pages/sign_up/sign_up_controller.dart';

class SignUpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
