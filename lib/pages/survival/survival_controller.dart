import 'package:get/get.dart';
import 'package:sos_connect/model/survival/survival_guide_model.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/pages/survival_guide_detail/survival_guide_detail_parameter.dart';

class SurvivalController extends GetxController {
  List<SurvivalGuideModel> guidesByCategory(SurvivalGuideCategory category) {
    return SurvivalGuideData.byCategory(category);
  }

  void openGuide(SurvivalGuideModel guide) {
    Get.toNamed(
      Routes.SURVIVAL_GUIDE_DETAIL,
      arguments: SurvivalGuideDetailParameter(guideId: guide.id),
    );
  }

  void openChat() => Get.toNamed(Routes.CHAT);
}
