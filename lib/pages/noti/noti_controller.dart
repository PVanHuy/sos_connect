import 'package:get/get.dart';
import 'package:sos_connect/model/notification/notification_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';
import 'package:sos_connect/resourese/service/notification/notification_service.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/noti_tab_type_utils.dart';
import 'package:sos_connect/utils/noti_type_utils.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';

class NotiController extends GetxController {
  NotiController({required this.notificationRepository});

  final INotificationRepository notificationRepository;

  final selectedTab = NotiTabType.system.obs;

  late final LazyListController<NotificationModel> systemListController;
  late final LazyListController<NotificationModel> appListController;

  LazyListController<NotificationModel> listControllerOf(NotiTabType tab) {
    return tab == NotiTabType.system ? systemListController : appListController;
  }

  LazyListController<NotificationModel> get currentListController => listControllerOf(selectedTab.value);

  @override
  void onInit() {
    super.onInit();
    systemListController = _createListController(NotiTabType.system);
    appListController = _createListController(NotiTabType.app);
    syncUnreadCount();
  }

  LazyListController<NotificationModel> _createListController(NotiTabType tab) {
    return LazyListController<NotificationModel>(
      onLoad: (page) async {
        return notificationRepository.getNotifications(page: page, type: tab.apiType, excludeType: tab.apiExcludeType);
      },
    );
  }

  void selectTab(NotiTabType tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
    final listController = listControllerOf(tab);
    if (!listController.hasRefresh) {
      listController.updateLoading(true);
      listController.onRefresh();
    }
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
    final tab = NotiTabTypeExtension.fromNotificationType(model.type);
    final listController = listControllerOf(tab);

    if (!listController.hasRefresh) {
      if (!(model.isRead)) _increaseUnreadCount();
      return;
    }

    if (id.isNotEmpty && listController.list.any((item) => item.id == id)) return;

    listController.addNewData(0, model);
    if (!(model.isRead)) _increaseUnreadCount();
  }

  void updateNotificationAsReadLocally(String notificationId) {
    final updated =
        _markLocalAsRead(systemListController, notificationId) || _markLocalAsRead(appListController, notificationId);
    if (updated) {
      _decreaseUnreadCount();
    }
  }

  bool _markLocalAsRead(LazyListController<NotificationModel> listController, String notificationId) {
    final index = listController.list.indexWhere((item) => item.id == notificationId);
    if (index == -1) return false;

    final oldItem = listController.list[index];
    if (oldItem.isRead) return false;

    listController.updateNewData(index, oldItem.copyWith(isRead: true));
    return true;
  }

  void handleNotificationTap(NotificationModel notification) {
    final notificationId = notification.id?.trim() ?? '';
    final sosId = notification.requestId?.trim() ?? '';

    if (notification.type == NotiTypeUtils.chat) {
      if (notificationId.isNotEmpty) markNotificationAsRead(notificationId);
      if (!Get.isRegistered<NotificationService>()) return;
      Get.find<NotificationService>().navigateByNotification(
        type: notification.type,
        action: notification.action,
        notificationId: notificationId.isNotEmpty ? notificationId : null,
        requestId: sosId,
        sosId: sosId,
      );
      return;
    }

    if (notificationId.isEmpty) return;

    if ((notification.type == NotiTypeUtils.joinRequest &&
            (notification.action == NotiActionUtils.created || notification.action == null)) ||
        notification.type == NotiTypeUtils.sosRequest) {
      markNotificationAsRead(notificationId);
    }

    if (!Get.isRegistered<NotificationService>()) return;
    Get.find<NotificationService>().navigateByNotification(
      type: notification.type,
      action: notification.action,
      notificationId: notificationId,
      teamId: notification.data?.teamId,
      requestId: notification.requestId,
      sosId: notification.requestId,
    );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final id = notificationId.trim();
      if (id.isEmpty) return;

      final listController = _listControllerContaining(id);
      if (listController == null) return;

      final index = listController.list.indexWhere((item) => item.id == id);
      if (index == -1) return;

      final oldItem = listController.list[index];
      if (oldItem.isRead) return;

      final response = await notificationRepository.markNotificationAsRead(id: id);
      if (!response.isOk) return;

      listController.updateNewData(index, oldItem.copyWith(isRead: true));
      _decreaseUnreadCount();
    } catch (e) {
      loggerHelper.error('Error updating notification as read: $e');
    }
  }

  LazyListController<NotificationModel>? _listControllerContaining(String notificationId) {
    if (systemListController.list.any((item) => item.id == notificationId)) {
      return systemListController;
    }
    if (appListController.list.any((item) => item.id == notificationId)) {
      return appListController;
    }
    return null;
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
    systemListController.dispose();
    appListController.dispose();
    super.onClose();
  }
}
