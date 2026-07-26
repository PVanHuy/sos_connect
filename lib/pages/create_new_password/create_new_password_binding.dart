import 'package:get/get.dart';
import 'package:sos_connect/pages/create_new_password/create_new_password_controller.dart';

class CreateNewPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateNewPasswordController());
  }
}
