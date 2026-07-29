import 'package:get/get.dart';
import 'package:sos_connect/pages/create_new_password/create_new_password_controller.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';

class CreateNewPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateNewPasswordController(authRepository: Get.find<IAuthRepository>()));
  }
}
