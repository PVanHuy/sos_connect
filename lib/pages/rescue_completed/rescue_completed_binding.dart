import 'package:get/get.dart';
import 'package:sos_connect/pages/rescue_completed/rescue_completed_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class RescueCompletedBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => RescueCompletedController(
        teamRepository: Get.find<ITeamRepository>(),
        sosRepository: Get.find<ISosRepository>(),
      ),
    );
  }
}
