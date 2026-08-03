import 'package:get/get.dart';
import 'package:sos_connect/pages/account/account_controller.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';

class AccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController(profileRepository: Get.find<IProfileRepository>()));
  }
}
