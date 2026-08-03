import 'package:get/get.dart';
import 'package:sos_connect/pages/rescue_team_list/rescue_team_list_controller.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class RescueTeamListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RescueTeamListController(teamRepository: Get.find<ITeamRepository>()));
  }
}
