import 'package:get/get.dart';
import 'package:sos_connect/pages/appeal_list/appeal_list_controller.dart';
import 'package:sos_connect/resourese/appeal/iappeal_repository.dart';

class AppealListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppealListController(appealRepository: Get.find<IAppealRepository>()));
  }
}
