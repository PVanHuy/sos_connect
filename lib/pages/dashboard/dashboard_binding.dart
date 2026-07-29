import 'package:get/get.dart';
import 'package:sos_connect/pages/account/account_controller.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/pages/survival/survival_controller.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController(profileRepository: Get.find<IProfileRepository>()));
    Get.lazyPut(() => MapController());
    Get.lazyPut(() => SurvivalController());
    Get.lazyPut(() => SupportController());
    Get.lazyPut(() => NotiController());
    Get.lazyPut(() => AccountController());
  }
}
