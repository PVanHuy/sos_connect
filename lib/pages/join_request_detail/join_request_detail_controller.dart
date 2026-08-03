import 'package:get/get.dart';
import 'package:sos_connect/model/team/current_join_team_request_model.dart';
import 'package:sos_connect/model/team/rescue_team_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/join_request_detail/join_request_detail_parameter.dart';
import 'package:sos_connect/pages/join_team_request_list/join_team_request_list_controller.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/join_team_request_status_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/noti_type_utils.dart';

class JoinRequestDetailUi {
  JoinRequestDetailUi({
    this.teamName = '',
    this.contactPerson = '',
    this.phone = '',
    this.createdAt = '',
    this.reason = '',
    this.responseMessage = '',
    this.status,
  });

  final String teamName;
  final String contactPerson;
  final String phone;
  final String createdAt;
  final String reason;
  final String responseMessage;
  final String? status;
}

class JoinRequestDetailController extends GetxController {
  JoinRequestDetailController({
    required this.teamRepository,
    required this.notificationRepository,
    required this.parameter,
  });

  final ITeamRepository teamRepository;
  final INotificationRepository notificationRepository;
  final JoinRequestDetailParameter parameter;

  final isLoading = false.obs;
  final detail = Rxn<JoinRequestDetailUi>();

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;

      CurrentJoinTeamRequestModel? request;
      RescueTeamModel? team;
      String? teamName;
      String? contactPerson;
      String? phone;
      String? createdAt;
      String? reason;
      String? responseMessage;
      String? status;

      final requestId = parameter.requestId?.trim() ?? '';

      if (requestId.isNotEmpty && Get.isRegistered<JoinTeamRequestListController>()) {
        final listController = Get.find<JoinTeamRequestListController>();
        request = listController.myRequestListController.list.firstWhereOrNull((e) => e.id == requestId);
        if (request != null) {
          team = listController.teamOf(request);
        }
      }

      if (request == null && requestId.isNotEmpty) {
        final result = await teamRepository.getCurrentJoinRequests(page: 1);
        if (isClosed) return;
        request = result.models.firstWhereOrNull((e) => e.id == requestId);
      }

      if (request != null) {
        status = request.status;
        reason = request.requestMessage;
        responseMessage = request.responseMessage;
        createdAt = request.createdAt;
        final teamId = request.teamId?.trim() ?? '';
        if (team == null && teamId.isNotEmpty) {
          team = await teamRepository.getTeamDetail(teamId);
          if (isClosed) return;
        }
      }

      final notificationId = parameter.notificationId?.trim() ?? '';
      if (notificationId.isNotEmpty) {
        final notification = await notificationRepository.getNotificationDetail(notificationId);
        if (isClosed) return;

        if (notification != null) {
          if (!notification.isRead) {
            await _markNotificationAsRead(notificationId);
          }

          final data = notification.data;
          teamName = data?.teamName ?? teamName;
          contactPerson = data?.leaderName ?? contactPerson;
          phone = data?.leaderPhone ?? phone;
          createdAt = data?.sentAt ?? createdAt ?? notification.createdAt;
          reason = data?.user?.reason ?? reason;
          status ??= _statusFromAction(notification.action);

          final resolvedRequestId = requestId.isNotEmpty ? requestId : (notification.requestId?.trim() ?? '');
          if (request == null && resolvedRequestId.isNotEmpty) {
            final result = await teamRepository.getCurrentJoinRequests(page: 1);
            if (isClosed) return;
            request = result.models.firstWhereOrNull((e) => e.id == resolvedRequestId);
            if (request != null) {
              status = request.status ?? status;
              reason = request.requestMessage ?? reason;
              responseMessage = request.responseMessage ?? responseMessage;
              createdAt = request.createdAt ?? createdAt;
            }
          }

          final teamId = data?.teamId?.trim() ?? request?.teamId?.trim() ?? '';
          if (team == null && teamId.isNotEmpty) {
            team = await teamRepository.getTeamDetail(teamId);
            if (isClosed) return;
          }
        }
      }

      detail.value = JoinRequestDetailUi(
        teamName: (teamName ?? team?.name ?? '').trim(),
        contactPerson: (contactPerson ?? team?.leader ?? '').trim(),
        phone: (phone ?? team?.phone ?? '').trim(),
        createdAt: (createdAt ?? '').trim(),
        reason: (reason ?? '').trim(),
        responseMessage: (responseMessage ?? '').trim(),
        status: status,
      );
    } catch (e) {
      loggerHelper.error('Error fetching join request detail: $e');
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  String? _statusFromAction(String? action) {
    switch (action) {
      case NotiActionUtils.accepted:
        return JoinTeamRequestStatusUtils.accepted;
      case NotiActionUtils.rejected:
        return JoinTeamRequestStatusUtils.rejected;
      case NotiActionUtils.created:
        return JoinTeamRequestStatusUtils.pending;
      default:
        return null;
    }
  }

  Future<void> _markNotificationAsRead(String notificationId) async {
    try {
      final response = await notificationRepository.markNotificationAsRead(id: notificationId);
      if (!response.isOk) return;

      if (Get.isRegistered<NotiController>()) {
        Get.find<NotiController>().updateNotificationAsReadLocally(notificationId);
        return;
      }

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
