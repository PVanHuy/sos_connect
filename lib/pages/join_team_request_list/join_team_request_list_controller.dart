import 'package:get/get.dart';
import 'package:sos_connect/model/team/current_join_team_request_model.dart';
import 'package:sos_connect/model/team/join_team_request_model.dart';
import 'package:sos_connect/model/team/rescue_team_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/join_team_request_status_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/widget/dialog/show_respond_join_request_dialog.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';

class JoinTeamRequestListController extends GetxController {
  JoinTeamRequestListController({required this.teamRepository});

  final ITeamRepository teamRepository;

  late final LazyListController<JoinTeamRequestModel> requestListController;
  late final LazyListController<CurrentJoinTeamRequestModel> myRequestListController;
  final acceptingId = RxnString();
  final rejectingId = RxnString();
  final appliedTeams = <String, RescueTeamModel>{}.obs;

  bool get isLeader {
    final roles = Get.find<DashboardController>().userModel.value?.roles ?? '';
    return roles.toLowerCase() == UserRoleUtils.leader;
  }

  bool get isResponding => acceptingId.value != null || rejectingId.value != null;

  RescueTeamModel? teamOf(CurrentJoinTeamRequestModel request) {
    final teamId = request.teamId?.trim() ?? '';
    if (teamId.isEmpty) return null;
    return appliedTeams[teamId];
  }

  @override
  void onInit() {
    super.onInit();
    requestListController = LazyListController<JoinTeamRequestModel>(
      onLoad: (page) => teamRepository.getPendingJoinRequests(page: page),
    );
    myRequestListController = LazyListController<CurrentJoinTeamRequestModel>(
      onLoad: (page) async {
        final result = await teamRepository.getCurrentJoinRequests(page: page);
        await _cacheTeams(result.models);
        return result;
      },
    );
  }

  Future<void> _cacheTeams(List<CurrentJoinTeamRequestModel> requests) async {
    final teamIds = requests.map((e) => e.teamId?.trim() ?? '').where((id) => id.isNotEmpty).toSet();

    for (final teamId in teamIds) {
      if (isClosed) return;
      if (appliedTeams.containsKey(teamId)) continue;

      final team = await teamRepository.getTeamDetail(teamId);
      if (isClosed) return;
      if (team != null) appliedTeams[teamId] = team;
    }
  }

  void updateMyRequestStatus({required String requestId, required String status}) {
    final id = requestId.trim();
    if (id.isEmpty) return;

    final index = myRequestListController.list.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final oldItem = myRequestListController.list[index];
    myRequestListController.updateNewData(
      index,
      oldItem.copyWith(status: status, respondedAt: DateTime.now().toUtc().toIso8601String()),
    );
  }

  Future<void> onRespond(JoinTeamRequestModel request, {required String status}) async {
    final requestId = request.id?.trim() ?? '';
    if (requestId.isEmpty || isResponding) return;

    final isAccept = status == JoinTeamRequestStatusUtils.accepted;
    final message = await showRespondJoinRequestDialog(
      title: isAccept ? 'accept_join_request'.tr : 'reject_join_request'.tr,
      description: isAccept ? 'accept_join_request_desc'.tr : 'reject_join_request_desc'.tr,
      confirmText: isAccept ? 'accept'.tr : 'reject'.tr,
      isReject: !isAccept,
    );
    if (message == null || message.trim().isEmpty) return;

    try {
      if (isAccept) {
        acceptingId.value = requestId;
      } else {
        rejectingId.value = requestId;
      }

      final response = await teamRepository.respondJoinRequest(
        requestId: requestId,
        status: status,
        responseMessage: message.trim(),
      );

      if (isClosed) return;

      if (response.isOk) {
        DialogUtils.showSuccessDialog(
          response.body['message'] ?? (isAccept ? 'accept_join_request_success'.tr : 'reject_join_request_success'.tr),
        );
        requestListController.removeWhere((e) => e.id == requestId);
      } else {
        DialogUtils.showErrorDialog(response.body['message'] ?? '');
      }
    } catch (e) {
      loggerHelper.error('Error responding join request: $e');
    } finally {
      if (!isClosed) {
        acceptingId.value = null;
        rejectingId.value = null;
      }
    }
  }

  @override
  void onClose() {
    requestListController.dispose();
    myRequestListController.dispose();
    super.onClose();
  }
}
