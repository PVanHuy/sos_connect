import 'package:get/get.dart';
import 'package:sos_connect/pages/sign_in/sign_in_controller.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }
}
