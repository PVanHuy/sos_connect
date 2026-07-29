import 'package:get/get.dart';
import 'package:sos_connect/pages/otp/otp_controller.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';

class OtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController(parameter: Get.arguments, authRepository: Get.find<IAuthRepository>()));
  }
}
