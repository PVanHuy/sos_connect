import 'package:get/get.dart';
import 'package:sos_connect/pages/temp/_controller.dart';

class TStateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TStateController());
  }
}
