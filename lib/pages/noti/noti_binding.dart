import 'package:get/get.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';

class NotiBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => NotiController(notificationRepository: Get.find<INotificationRepository>()),
    );
  }
}
