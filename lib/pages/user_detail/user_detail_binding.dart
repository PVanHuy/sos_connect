import 'package:get/get.dart';
import 'package:sos_connect/pages/user_detail/user_detail_controller.dart';
import 'package:sos_connect/pages/user_detail/user_detail_parameter.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class UserDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => UserDetailController(
        teamRepository: Get.find<ITeamRepository>(),
        parameter: Get.arguments as UserDetailParameter,
      ),
    );
  }
}
