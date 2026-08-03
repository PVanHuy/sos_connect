import 'package:get/get.dart';
import 'package:sos_connect/pages/join_request_detail/join_request_detail_controller.dart';
import 'package:sos_connect/pages/join_request_detail/join_request_detail_parameter.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';

class JoinRequestDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => JoinRequestDetailController(
        teamRepository: Get.find<ITeamRepository>(),
        notificationRepository: Get.find<INotificationRepository>(),
        parameter: Get.arguments as JoinRequestDetailParameter,
      ),
    );
  }
}
