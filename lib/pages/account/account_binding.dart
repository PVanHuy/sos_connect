import 'package:get/get.dart';
import 'package:sos_connect/pages/account/account_controller.dart';

class AccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController());
  }
}
