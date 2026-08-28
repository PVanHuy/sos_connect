import 'package:get/get.dart';
import 'package:sos_connect/pages/appeal_detail/appeal_detail_controller.dart';
import 'package:sos_connect/pages/appeal_detail/appeal_detail_parameter.dart';
import 'package:sos_connect/resourese/appeal/iappeal_repository.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';

class AppealDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AppealDetailController(
        appealRepository: Get.find<IAppealRepository>(),
        notificationRepository: Get.find<INotificationRepository>(),
        parameter: Get.arguments as AppealDetailParameter,
      ),
    );
  }
}
