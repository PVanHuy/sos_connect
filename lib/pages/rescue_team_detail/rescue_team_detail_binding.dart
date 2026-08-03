import 'package:get/get.dart';
import 'package:sos_connect/pages/rescue_team_detail/rescue_team_detail_controller.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class RescueTeamDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => RescueTeamDetailController(
        teamRepository: Get.find<ITeamRepository>(),
        parameter: Get.arguments,
      ),
    );
  }
}
