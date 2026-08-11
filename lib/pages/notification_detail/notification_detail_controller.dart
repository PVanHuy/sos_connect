import 'package:get/get.dart';
import 'package:sos_connect/model/notification/notification_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/notification_detail/notification_detail_parameter.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';
import 'package:sos_connect/utils/easyloading_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';

class NotificationDetailController extends GetxController {
  NotificationDetailController({required this.notificationRepository, required this.parameter});

  final INotificationRepository notificationRepository;
  final NotificationDetailParameter parameter;

  final notificationDetail = Rxn<NotificationModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotificationDetail();
  }

  Future<void> fetchNotificationDetail() async {
    try {
      isLoading.value = true;
      showEasyLoading();

      final detail = await notificationRepository.getNotificationDetail(parameter.notificationId);
      if (isClosed) return;

      if (detail != null) {
        notificationDetail.value = detail;
        if (!detail.isRead) {
          await _markNotificationAsRead(parameter.notificationId);
        }
      }
    } catch (error) {
      loggerHelper.error(error.toString());
    } finally {
      if (!isClosed) isLoading.value = false;
      dismissEasyLoading();
    }
  }

  Future<void> _markNotificationAsRead(String notificationId) async {
    try {
      if (Get.isRegistered<NotiController>()) {
        await Get.find<NotiController>().markNotificationAsRead(notificationId);
        notificationDetail.value = notificationDetail.value?.copyWith(isRead: true);
        return;
      }

      final response = await notificationRepository.markNotificationAsRead(id: notificationId);
      if (!response.isOk) return;

      notificationDetail.value = notificationDetail.value?.copyWith(isRead: true);
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        if (dashboardController.notificationCount.value > 0) {
          dashboardController.notificationCount.value -= 1;
        }
      }
    } catch (e) {
      loggerHelper.error('Error marking notification as read: $e');
    }
  }
}
