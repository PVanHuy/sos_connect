import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/model/user/user_model.dart';
import 'package:sos_connect/pages/account/account_page.dart';
import 'package:sos_connect/pages/activity/activity_controller.dart';
import 'package:sos_connect/pages/activity/activity_page.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/pages/map/map_page.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/noti/noti_page.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/pages/support/support_page.dart';
import 'package:sos_connect/resourese/dashboard/idashboard_repository.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/resourese/service/notification/notification_service.dart';
import 'package:sos_connect/resourese/service/socket/socket_event.dart';
import 'package:sos_connect/resourese/service/socket/socket_io_service.dart';
import 'package:sos_connect/resourese/service/socket/team_live_mode_service.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';

class DashboardController extends GetxController {
  final IProfileRepository profileRepository;
  final IDashboardRepository dashboardRepository;
  final ITeamRepository teamRepository;
  final NotificationService notificationService;
  final SocketIoService socketIoService;

  DashboardController({
    required this.profileRepository,
    required this.dashboardRepository,
    required this.teamRepository,
    required this.notificationService,
    required this.socketIoService,
  });

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final RxInt notificationCount = 0.obs;
  final RxInt joinRequestCount = 0.obs;

  late final List<Widget> pages = [MapPage(), ActivityPage(), SupportPage(), NotiPage(), AccountPage()];

  bool _didPromptLiveMode = false;

  bool get isLeader {
    final roles = userModel.value?.roles ?? '';
    return roles.toLowerCase() == UserRoleUtils.leader;
  }

  bool get hasTeam {
    final teamId = userModel.value?.teamId?.trim() ?? '';
    return teamId.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    _init();
  }

  @override
  void onReady() {
    super.onReady();
    Get.find<NotiController>();
    Get.find<SupportController>();
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

    try {
      socketIoService.on(SocketEvent.sosNewRequest, _onSosNewRequest);
      socketIoService.on(SocketEvent.sosMapUpdated, _onSosMapUpdated);
      socketIoService.addReconnectedCallback(_subscribeChannels);
      await socketIoService.connect();
    } catch (e) {
      loggerHelper.error('Dashboard socket init error: $e');
    }
  }

  void _subscribeChannels() {
    socketIoService.subscribe(SocketEvent.channelSosFeed);
    socketIoService.subscribe(SocketEvent.channelSosMap);
  }

  Map<String, dynamic>? _asSocketMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  void _onSosNewRequest(dynamic data) {
    final map = _asSocketMap(data);
    if (map == null) return;

    try {
      final event = SosEventModel.fromJson(map);
      if (Get.isRegistered<SupportController>()) {
        Get.find<SupportController>().handleNewSosEvent(event);
      }
      if (Get.isRegistered<MapController>()) {
        Get.find<MapController>().handleNewSosEvent(event);
      }
    } catch (e) {
      loggerHelper.error('Handle sos:new_request error: $e');
    }
  }

  void _onSosMapUpdated(dynamic data) {
    final map = _asSocketMap(data);
    if (map == null) return;

    final lat = (map['lat'] as num?)?.toDouble();
    final lon = (map['lon'] as num?)?.toDouble();
    if (lat == null || lon == null) return;

    if (!Get.isRegistered<MapController>()) return;
    Get.find<MapController>().handleMapUpdated(id: map['id']?.toString(), lat: lat, lon: lon);
  }

  Future<void> fetchProfile() async {
    try {
      final response = await profileRepository.profile();
      if (!response.isOk) return;

      userModel.value = UserModel.fromJson(response.body);
      await fetchJoinRequestCount();
      _maybePromptLiveMode();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _maybePromptLiveMode() {
    if (_didPromptLiveMode || isClosed) return;
    if (!isLeader || !hasTeam) return;
    if (!Get.isRegistered<TeamLiveModeService>()) return;

    final liveService = Get.find<TeamLiveModeService>();
    if (liveService.isLive.value) return;

    _didPromptLiveMode = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;
      if (Get.isDialogOpen == true) return;
      if (liveService.isLive.value) return;

      showConfirmDialog(
        title: 'team_live_mode_prompt_title'.tr,
        content: 'team_live_mode_prompt_content'.tr,
        titleBtn: 'yes'.tr,
        cancelBtnTitle: 'cancel'.tr,
        onConfirm: () {
          if (!Get.isRegistered<TeamLiveModeService>()) return;
          Get.find<TeamLiveModeService>().toggleLiveMode(active: true);
        },
      );
    });
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
    if (currentPage.value == index) {
      _refreshTab(index);
      return;
    }
    currentPage.value = index;
    pageController.jumpToPage(index);
    _refreshTab(index);
    _notifyMapTabVisibility(index);
  }

  void _refreshTab(int index) {
    if (index == 1 && Get.isRegistered<ActivityController>()) {
      Get.find<ActivityController>().refreshList();
    }
    if (index == 2 && Get.isRegistered<SupportController>()) {
      Get.find<SupportController>().refreshList();
    }
  }

  void animateToTab(int index) {
    currentPage.value = index;
    _notifyMapTabVisibility(index);
  }

  void _notifyMapTabVisibility(int index) {
    if (!Get.isRegistered<MapController>()) return;
    Get.find<MapController>().onMapTabVisible(index == 0);
  }

  @override
  void onClose() {
    socketIoService.off(SocketEvent.sosNewRequest, _onSosNewRequest);
    socketIoService.off(SocketEvent.sosMapUpdated, _onSosMapUpdated);
    socketIoService.clearReconnectedCallbacks();
    socketIoService.disconnect();
    pageController.dispose();
    notificationService.onClose();
    super.onClose();
  }
}
