import 'package:get/get.dart';
import 'package:sos_connect/resourese/auth/auth_repository.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';
import 'package:sos_connect/resourese/dashboard/dashboard_repository.dart';
import 'package:sos_connect/resourese/dashboard/idashboard_repository.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';
import 'package:sos_connect/resourese/notification/notification_repository.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/resourese/profile/profile_repository.dart';
import 'package:sos_connect/resourese/service/notification/notification_service.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/sos/sos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/resourese/team/team_repository.dart';

class AppService {
  static Future<void> initAppService() async {
    Get.put<IAuthRepository>(AuthRepository());
    Get.put<IProfileRepository>(ProfileRepository());
    Get.put<ITeamRepository>(TeamRepository());
    Get.put<ISosRepository>(SosRepository());
    Get.put<IDashboardRepository>(DashboardRepository());
    Get.put<INotificationRepository>(NotificationRepository());
    Get.put(NotificationService());
  }
}
