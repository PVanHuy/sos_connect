import 'package:get/get.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_controller.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class RegisterRescueTeamBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterRescueTeamController(teamRepository: Get.find<ITeamRepository>()));
  }
}
