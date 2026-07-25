import 'package:get/get.dart';
import 'package:sos_connect/pages/survival_guide_detail/survival_guide_detail_controller.dart';

class SurvivalGuideDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SurvivalGuideDetailController());
  }
}
