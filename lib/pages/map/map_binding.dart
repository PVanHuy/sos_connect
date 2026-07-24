import 'package:get/get.dart';
import 'package:sos_connect/pages/map/map_controller.dart';

class MapBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapController());
  }
}
