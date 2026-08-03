import 'package:get/get.dart';
import 'package:sos_connect/pages/join_team_request_list/join_team_request_list_controller.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class JoinTeamRequestListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JoinTeamRequestListController(teamRepository: Get.find<ITeamRepository>()));
  }
}
