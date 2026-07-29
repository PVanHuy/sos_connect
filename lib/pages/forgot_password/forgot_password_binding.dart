import 'package:get/get.dart';
import 'package:sos_connect/pages/forgot_password/forgot_password_controller.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController(authRepository: Get.find<IAuthRepository>()));
  }
}
