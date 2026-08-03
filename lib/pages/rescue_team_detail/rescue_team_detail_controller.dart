import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/model/team/rescue_team_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/rescue_team_detail/rescue_team_detail_parameter.dart';
import 'package:sos_connect/pages/rescue_team_list/rescue_team_list_controller.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/widget/dialog/show_join_team_dialog.dart';

class RescueTeamDetailController extends GetxController {
  RescueTeamDetailController({required this.teamRepository, required this.parameter});

  final ITeamRepository teamRepository;
  final RescueTeamDetailParameter parameter;

  final teamNameController = TextEditingController();
  final provinceController = TextEditingController();
  final wardController = TextEditingController();
  final memberCountController = TextEditingController();
  final organizationController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final contactEmailController = TextEditingController();
  final roleController = TextEditingController();

  final teamModel = Rxn<RescueTeamModel>();
  final isSubmitting = false.obs;
  final isFetching = false.obs;
  final hasPendingJoinRequest = false.obs;

  bool get canJoinTeam {
    final teamId = Get.find<DashboardController>().userModel.value?.teamId?.trim() ?? '';
    return teamId.isEmpty && !hasPendingJoinRequest.value;
  }

  @override
  void onInit() {
    super.onInit();
    hasPendingJoinRequest.value = parameter.hasPendingJoinRequest;
    fetchTeamDetail();
  }

  Future<void> fetchTeamDetail() async {
    if (parameter.teamId.trim().isEmpty) return;

    try {
      isFetching.value = true;
      final team = await teamRepository.getTeamDetail(parameter.teamId);
      if (isClosed) return;
      if (team == null) return;

      teamModel.value = team;
      _fillTeamForm(team);
    } catch (e) {
      loggerHelper.error('Error fetching team detail: $e');
    } finally {
      if (!isClosed) isFetching.value = false;
    }
  }

  void _fillTeamForm(RescueTeamModel team) {
    teamNameController.text = team.name ?? '';
    provinceController.text = team.province ?? '';
    wardController.text = team.commune ?? '';
    memberCountController.text = team.sizeMember ?? '';
    organizationController.text = team.organizational ?? '';
    contactNameController.text = team.leader ?? '';
    contactPhoneController.text = team.phone ?? '';
    contactEmailController.text = team.email ?? '';
    roleController.text = (team.position ?? '').rescueTeamRoleName;
  }

  Future<void> onJoinTeam() async {
    if (!canJoinTeam || isSubmitting.value) return;

    final message = await showJoinTeamRequestDialog();
    if (message == null || message.trim().isEmpty) return;

    try {
      isSubmitting.value = true;
      final response = await teamRepository.joinTeamRequest(teamId: parameter.teamId, requestMessage: message.trim());

      if (isClosed) return;

      if (response.isOk) {
        hasPendingJoinRequest.value = true;
        if (Get.isRegistered<RescueTeamListController>()) {
          await Get.find<RescueTeamListController>().fetchCurrentJoinRequests();
        }
        DialogUtils.showSuccessDialog(response.body['message'] ?? 'join_team_request_success'.tr);
      } else {
        DialogUtils.showErrorDialog(response.body['message'] ?? '');
      }
    } catch (e) {
      loggerHelper.error('Error joining team: $e');
    } finally {
      if (!isClosed) isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    teamNameController.dispose();
    provinceController.dispose();
    wardController.dispose();
    memberCountController.dispose();
    organizationController.dispose();
    contactNameController.dispose();
    contactPhoneController.dispose();
    contactEmailController.dispose();
    roleController.dispose();
    super.onClose();
  }
}
