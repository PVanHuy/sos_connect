import 'package:get/get.dart';
import 'package:sos_connect/pages/survival/survival_controller.dart';

class SurvivalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SurvivalController());
  }
}
