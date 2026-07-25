import 'package:get/get.dart';
import 'package:sos_connect/model/survival/survival_guide_model.dart';
import 'package:sos_connect/pages/survival_guide_detail/survival_guide_detail_parameter.dart';

class SurvivalGuideDetailController extends GetxController {
  SurvivalGuideModel? guide;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final guideId = args is SurvivalGuideDetailParameter ? args.guideId : null;
    if (guideId != null) {
      guide = SurvivalGuideData.findById(guideId);
    }
  }
}
