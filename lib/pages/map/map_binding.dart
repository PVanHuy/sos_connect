import 'package:get/get.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class MapBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MapController(
        sosRepository: Get.find<ISosRepository>(),
        teamRepository: Get.find<ITeamRepository>(),
      ),
    );
  }
}
