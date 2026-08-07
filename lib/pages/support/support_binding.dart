import 'package:get/get.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class SupportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SupportController(
        sosRepository: Get.find<ISosRepository>(),
        teamRepository: Get.find<ITeamRepository>(),
      ),
    );
  }
}
