import 'package:get/get.dart';
import 'package:sos_connect/pages/change_password/change_password_controller.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';

class ChangePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePasswordController(authRepository: Get.find<IAuthRepository>()));
  }
}
