import 'package:get/get.dart';
import 'package:sos_connect/pages/sign_in/sign_in_controller.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController(authRepository: Get.find<IAuthRepository>()), fenix: true);
  }
}
