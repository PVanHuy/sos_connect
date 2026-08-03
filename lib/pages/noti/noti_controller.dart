import 'package:get/get.dart';
import 'package:sos_connect/model/notification/notification_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';
import 'package:sos_connect/resourese/service/notification/notification_service.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/noti_type_utils.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';

class NotiController extends GetxController {
  NotiController({required this.notificationRepository});

  final INotificationRepository notificationRepository;

  late final LazyListController<NotificationModel> notificationListController;

  @override
  void onInit() {
    super.onInit();
    notificationListController = LazyListController<NotificationModel>(
      onLoad: (page) async {
        final result = await notificationRepository.getNotifications(page: page);
        if (page == 1 && result.unreadCount != null) {
          _setUnreadCount(result.unreadCount!);
        }
        return result;
      },
    );
    syncUnreadCount();
  }

  Future<void> syncUnreadCount() async {
    try {
      final result = await notificationRepository.getNotifications(page: 1);
      if (result.unreadCount != null) {
        _setUnreadCount(result.unreadCount!);
      }
    } catch (e) {
      loggerHelper.error('Error syncing unread notification count: $e');
    }
  }

  void addNotification(NotificationModel model) {
    final id = model.id?.trim() ?? '';
    if (id.isNotEmpty && notificationListController.list.any((item) => item.id == id)) return;

    notificationListController.addNewData(0, model);

    if (!(model.isRead)) {
      _increaseUnreadCount();
    }
  }

  void updateNotificationAsReadLocally(String notificationId) {
    final index = notificationListController.list.indexWhere((item) => item.id == notificationId);
    if (index == -1) return;

    final oldItem = notificationListController.list[index];
    if (oldItem.isRead) return;

    notificationListController.updateNewData(index, oldItem.copyWith(isRead: true));
    _decreaseUnreadCount();
  }

  void handleNotificationTap(NotificationModel notification) {
    final notificationId = notification.id?.trim() ?? '';
    if (notificationId.isEmpty) return;

    if (notification.type == NotiTypeUtils.joinRequest &&
        (notification.action == NotiActionUtils.created || notification.action == null)) {
      markNotificationAsRead(notificationId);
    }

    if (!Get.isRegistered<NotificationService>()) return;
    Get.find<NotificationService>().navigateByNotification(
      type: notification.type,
      action: notification.action,
      notificationId: notificationId,
      teamId: notification.data?.teamId,
      requestId: notification.requestId,
    );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final id = notificationId.trim();
      if (id.isEmpty) return;

      final index = notificationListController.list.indexWhere((item) => item.id == id);
      if (index == -1) return;

      final oldItem = notificationListController.list[index];
      if (oldItem.isRead) return;

      final response = await notificationRepository.markNotificationAsRead(id: id);
      if (!response.isOk) return;

      notificationListController.updateNewData(index, oldItem.copyWith(isRead: true));
      _decreaseUnreadCount();
    } catch (e) {
      loggerHelper.error('Error updating notification as read: $e');
    }
  }

  void _setUnreadCount(int count) {
    if (!Get.isRegistered<DashboardController>()) return;
    Get.find<DashboardController>().notificationCount.value = count < 0 ? 0 : count;
  }

  void _increaseUnreadCount() {
    if (!Get.isRegistered<DashboardController>()) return;
    Get.find<DashboardController>().notificationCount.value += 1;
  }

  void _decreaseUnreadCount() {
    if (!Get.isRegistered<DashboardController>()) return;
    final dashboardController = Get.find<DashboardController>();
    if (dashboardController.notificationCount.value > 0) {
      dashboardController.notificationCount.value -= 1;
    }
  }

  @override
  void onClose() {
    notificationListController.dispose();
    super.onClose();
  }
}
