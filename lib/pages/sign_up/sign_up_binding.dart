import 'package:get/get.dart';
import 'package:sos_connect/pages/sign_up/sign_up_controller.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';

class SignUpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController(authRepository: Get.find<IAuthRepository>()));
  }
}
