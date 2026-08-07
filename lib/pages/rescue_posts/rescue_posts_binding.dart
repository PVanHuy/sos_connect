import 'package:get/get.dart';
import 'package:sos_connect/pages/rescue_posts/rescue_posts_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class RescuePostsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => RescuePostsController(
        teamRepository: Get.find<ITeamRepository>(),
        sosRepository: Get.find<ISosRepository>(),
      ),
    );
  }
}
