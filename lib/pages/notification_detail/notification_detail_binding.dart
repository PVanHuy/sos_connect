import 'package:get/get.dart';
import 'package:sos_connect/pages/notification_detail/notification_detail_controller.dart';
import 'package:sos_connect/pages/notification_detail/notification_detail_parameter.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';

class NotificationDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => NotificationDetailController(
        notificationRepository: Get.find<INotificationRepository>(),
        parameter: Get.arguments as NotificationDetailParameter,
      ),
    );
  }
}
