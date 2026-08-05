import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/model/user/user_model.dart';
import 'package:sos_connect/pages/account/account_page.dart';
import 'package:sos_connect/pages/map/map_page.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/noti/noti_page.dart';
import 'package:sos_connect/pages/support/support_page.dart';
import 'package:sos_connect/pages/survival/survival_page.dart';
import 'package:sos_connect/resourese/dashboard/idashboard_repository.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/resourese/service/notification/notification_service.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/role_user.utils.dart';

class DashboardController extends GetxController {
  final IProfileRepository profileRepository;
  final IDashboardRepository dashboardRepository;
  final ITeamRepository teamRepository;
  final NotificationService notificationService;
  // final SocketIoService socketIoService;

  DashboardController({
    required this.profileRepository,
    required this.dashboardRepository,
    required this.teamRepository,
    required this.notificationService,
    // required this.socketIoService,
  });

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final RxInt notificationCount = 0.obs;
  final RxInt joinRequestCount = 0.obs;

  late final List<Widget> pages = [MapPage(), SurvivalPage(), SupportPage(), NotiPage(), AccountPage()];

  bool get isLeader {
    final roles = userModel.value?.roles ?? '';
    return roles.toLowerCase() == UserRoleUtils.leader;
  }

  @override
  void onInit() {
    super.onInit();
    // Create tab controllers under Dashboard route so GetX doesn't
    // bind/delete them when child routes (e.g. notification deep-link) close.
    Get.find<NotiController>();
    fetchProfile();
    _init();
  }

  Future<void> _init() async {
    try {
      await notificationService.onInit();
      await notificationService.onRequestPermission();

      final fcmToken = await notificationService.getFcmToken();
      if (fcmToken != null) {
        await dashboardRepository.updateFcmToken(fcmToken);
      }
      await notificationService.onHandleInitialMessage();
    } catch (e) {
      loggerHelper.error('Dashboard notification init error: $e');
    }

    // try {
    //   await socketIoService.connect();
    //   socketIoService.onAny((event, data) {
    //     loggerHelper.log('SocketIO Event: $event, Data: $data', name: 'SocketIoService - ANY');
    //   });
    //   _subscribeEvents();
    //   socketIoService.addReconnectedCallback(_subscribeEvents);
    // } catch (e) {
    //   loggerHelper.error('Dashboard socket init error: $e');
    // }
  }

  /// Register socket listeners here when backend events are ready.
  // void _subscribeEvents() {
  // Example:
  // socketIoService.off(SocketEvent.someEvent);
  // socketIoService.on(SocketEvent.someEvent, (data) { ... });
  // }

  Future<void> fetchProfile() async {
    try {
      final response = await profileRepository.profile();
      if (!response.isOk) return;

      userModel.value = UserModel.fromJson(response.body);
      await fetchJoinRequestCount();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchJoinRequestCount() async {
    if (!isLeader) {
      joinRequestCount.value = 0;
      return;
    }

    try {
      final result = await teamRepository.getPendingJoinRequests(page: 1);
      joinRequestCount.value = result.countRequest ?? 0;
    } catch (e) {
      loggerHelper.error('Error fetching join request count: $e');
    }
  }

  void setJoinRequestCount(int count) {
    joinRequestCount.value = count < 0 ? 0 : count;
  }

  void decreaseJoinRequestCount() {
    if (joinRequestCount.value > 0) {
      joinRequestCount.value -= 1;
    }
  }

  void updateUserModel(UserModel updatedModel) {
    userModel.value = updatedModel;
  }

  void goToTab(int index) {
    if (currentPage.value == index) return;
    currentPage.value = index;
    pageController.jumpToPage(index);
  }

  void animateToTab(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    notificationService.onClose();
    super.onClose();
  }
}
