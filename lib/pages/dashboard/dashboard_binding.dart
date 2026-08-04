import 'package:get/get.dart';
import 'package:sos_connect/pages/account/account_controller.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/pages/survival/survival_controller.dart';
import 'package:sos_connect/resourese/dashboard/idashboard_repository.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/resourese/service/notification/notification_service.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => DashboardController(
        profileRepository: Get.find<IProfileRepository>(),
        dashboardRepository: Get.find<IDashboardRepository>(),
        teamRepository: Get.find<ITeamRepository>(),
        notificationService: Get.find<NotificationService>(),
      ),
    );
    Get.lazyPut(() => MapController(), fenix: true);
    Get.lazyPut(() => SurvivalController(), fenix: true);
    Get.lazyPut(() => SupportController(), fenix: true);
    Get.lazyPut(() => NotiController(notificationRepository: Get.find<INotificationRepository>()), fenix: true);
    Get.lazyPut(() => AccountController(profileRepository: Get.find<IProfileRepository>()), fenix: true);
  }
}
