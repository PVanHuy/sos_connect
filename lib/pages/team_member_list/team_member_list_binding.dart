import 'package:get/get.dart';
import 'package:sos_connect/pages/team_member_list/team_member_list_controller.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class TeamMemberListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => TeamMemberListController(teamRepository: Get.find<ITeamRepository>()),
    );
  }
}
