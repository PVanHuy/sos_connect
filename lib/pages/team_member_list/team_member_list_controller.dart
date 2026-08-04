import 'package:get/get.dart';
import 'package:sos_connect/model/team/rescue_team_model.dart';
import 'package:sos_connect/model/team/team_member_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/personal_information/personal_information_parameter.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_controller.dart';
import 'package:sos_connect/pages/user_detail/user_detail_parameter.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/widget/dialog/show_kick_member_dialog.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';

class TeamMemberListController extends GetxController {
  TeamMemberListController({required this.teamRepository});

  final ITeamRepository teamRepository;

  late final LazyListController<TeamMemberModel> memberListController;
  final kickingId = RxnString();
  final countMember = 0.obs;
  final sizeMember = ''.obs;

  bool get isLeader {
    final roles = Get.find<DashboardController>().userModel.value?.roles ?? '';
    return roles.toLowerCase() == UserRoleUtils.leader;
  }

  String get currentUserId => Get.find<DashboardController>().userModel.value?.id?.trim() ?? '';

  bool get isKicking => kickingId.value != null;

  String get memberCountText {
    final current = countMember.value;
    final size = sizeMember.value.trim();
    if (size.isEmpty) return '$current';
    return '$current/$size';
  }

  @override
  void onInit() {
    super.onInit();
    _initSizeMember();
    memberListController = LazyListController<TeamMemberModel>(
      onLoad: (page) async {
        final result = await teamRepository.getTeamMembers(page: page);
        if (page == 1 && result.countMember != null) {
          countMember.value = result.countMember!;
        }
        return result;
      },
    );
  }

  void _initSizeMember() {
    if (Get.isRegistered<RegisterRescueTeamController>()) {
      final team = Get.find<RegisterRescueTeamController>().teamModel.value;
      final size = team?.sizeMember?.trim() ?? '';
      if (size.isNotEmpty) {
        sizeMember.value = size;
        return;
      }
    }
    _fetchSizeMember();
  }

  Future<void> _fetchSizeMember() async {
    try {
      final response = await teamRepository.getMyTeam();
      if (isClosed || !response.isOk) return;

      final body = response.body;
      final raw = body is Map && body['data'] != null ? body['data'] : body;
      if (raw is! Map) return;

      final team = RescueTeamModel.fromJson(Map<String, dynamic>.from(raw));
      sizeMember.value = team.sizeMember?.trim() ?? '';
    } catch (e) {
      loggerHelper.error('Error fetching team size member: $e');
    }
  }

  bool canKick(TeamMemberModel member) {
    if (!isLeader) return false;

    final userId = member.user?.id?.trim() ?? '';
    if (userId.isEmpty) return false;
    if (userId == currentUserId) return false;

    final role = (member.user?.roles ?? '').toLowerCase();
    if (role == UserRoleUtils.leader) return false;

    return true;
  }

  void onTapMember(TeamMemberModel member) {
    final userId = member.user?.id?.trim() ?? '';
    if (userId.isEmpty) return;

    if (userId == currentUserId) {
      Get.toNamed(
        Routes.PERSONAL_INFORMATION,
        arguments: PersonalInformationParameter(userModel: Get.find<DashboardController>().userModel.value),
      );
      return;
    }

    Get.toNamed(Routes.USER_DETAIL, arguments: UserDetailParameter(userId: userId));
  }

  Future<void> onKick(TeamMemberModel member) async {
    final userId = member.user?.id?.trim() ?? '';
    if (userId.isEmpty || isKicking || !canKick(member)) return;

    final username = member.user?.username?.trim().isNotEmpty == true ? member.user!.username! : 'no_data'.tr;

    final reason = await showKickMemberDialog(username: username);
    if (reason == null || reason.trim().isEmpty) return;

    await _kickMember(userId, reason.trim());
  }

  Future<void> _kickMember(String userId, String reasonKicked) async {
    try {
      kickingId.value = userId;
      final response = await teamRepository.kickTeamMember(memberId: userId, reasonKicked: reasonKicked);
      if (isClosed) return;

      if (response.isOk) {
        DialogUtils.showSuccessDialog(response.body['message'] ?? 'kick_team_member_success'.tr);
        memberListController.removeWhere((e) => e.user?.id == userId);
        if (countMember.value > 0) countMember.value -= 1;
      } else {
        DialogUtils.showErrorDialog(response.body['message'] ?? '');
      }
    } catch (e) {
      loggerHelper.error('Error kicking team member: $e');
    } finally {
      if (!isClosed) kickingId.value = null;
    }
  }

  @override
  void onClose() {
    memberListController.dispose();
    super.onClose();
  }
}
