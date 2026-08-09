import 'package:get/get.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/rescue_support_type_utils.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/utils/sos_status_utils.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';

class ActivityController extends GetxController {
  ActivityController({required this.teamRepository, required this.sosRepository});

  final ITeamRepository teamRepository;
  final ISosRepository sosRepository;

  final selectedTab = RescueListType.yourRequests.obs;
  final markingSafeId = RxnString();

  late final LazyListController<SosEventModel> receivingListController;
  late final LazyListController<SosEventModel> yourRequestsListController;

  Worker? _userWorker;
  bool _didApplyRoleDefault = false;

  LazyListController<SosEventModel> listControllerOf(RescueListType tab) {
    return tab == RescueListType.receiving ? receivingListController : yourRequestsListController;
  }

  LazyListController<SosEventModel> get currentListController => listControllerOf(selectedTab.value);

  bool get hasTeamRole {
    if (!Get.isRegistered<DashboardController>()) return false;
    final user = Get.find<DashboardController>().userModel.value;
    if (user == null) return false;

    final role = (user.roles ?? '').toLowerCase();
    if (role == UserRoleUtils.leader) return true;

    final teamId = user.teamId?.trim() ?? '';
    return role == UserRoleUtils.volunteer && teamId.isNotEmpty;
  }

  bool get canSwitch => hasTeamRole;

  String get title => selectedTab.value.title;

  @override
  void onInit() {
    super.onInit();
    receivingListController = LazyListController<SosEventModel>(
      onLoad: (page) async {
        if (page > 1) return PaginationModel<SosEventModel>();
        return teamRepository.getAllSupport(status: SosStatusUtils.inProgress);
      },
    );
    yourRequestsListController = LazyListController<SosEventModel>(
      onLoad: (page) => sosRepository.getMySosRequests(page: page),
    );

    selectedTab.value = hasTeamRole ? RescueListType.receiving : RescueListType.yourRequests;

    if (Get.isRegistered<DashboardController>()) {
      _userWorker = ever(Get.find<DashboardController>().userModel, (_) => _syncRoleDefault());
      _syncRoleDefault();
    }
  }

  void _syncRoleDefault() {
    if (!hasTeamRole) {
      if (selectedTab.value == RescueListType.receiving) {
        selectedTab.value = RescueListType.yourRequests;
      }
      return;
    }

    if (!_didApplyRoleDefault) {
      _didApplyRoleDefault = true;
      selectedTab.value = RescueListType.receiving;
    }
  }

  void selectTab(RescueListType tab) {
    if (selectedTab.value == tab) return;
    if (tab == RescueListType.receiving && !hasTeamRole) return;
    selectedTab.value = tab;
  }

  bool hasSosRequest(String sosId) {
    final id = sosId.trim();
    if (id.isEmpty) return false;
    return yourRequestsListController.list.any((e) => (e.id?.trim() ?? '') == id);
  }

  Future<void> openYourRequests({bool forceRefresh = true}) async {
    selectedTab.value = RescueListType.yourRequests;
    if (!forceRefresh && yourRequestsListController.list.isNotEmpty) return;
    await refreshYourRequests();
  }

  Future<void> refreshYourRequests() async {
    if (yourRequestsListController.list.isEmpty) {
      yourRequestsListController.updateLoading(true);
    }
    await yourRequestsListController.onRefresh();
  }

  void toggleTab() {
    if (!canSwitch) return;
    selectTab(selectedTab.value == RescueListType.receiving ? RescueListType.yourRequests : RescueListType.receiving);
  }

  Future<void> refreshList() async {
    final listController = currentListController;
    if (listController.list.isEmpty) {
      listController.updateLoading(true);
    }
    await listController.onRefresh();
  }

  void markAsSafe(SosEventModel item) {
    final sosId = item.id?.trim() ?? '';
    if (sosId.isEmpty || markingSafeId.value != null) return;

    showConfirmDialog(
      title: 'mark_as_safe'.tr,
      content: 'mark_as_safe_confirm'.tr,
      titleBtn: 'confirm'.tr,
      onConfirm: () => _cancelMySos(sosId),
    );
  }

  Future<void> _cancelMySos(String sosId) async {
    if (markingSafeId.value != null) return;

    try {
      markingSafeId.value = sosId;
      final response = await sosRepository.cancelMySosRequest(sosId);
      if (response.isOk) {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showSuccessDialog(message ?? 'mark_as_safe_success'.tr);
        yourRequestsListController.removeWhere((item) => item.id == sosId);
      } else {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showErrorDialog(message ?? '');
      }
    } catch (e) {
      loggerHelper.error('Cancel my SOS error: $e');
    } finally {
      markingSafeId.value = null;
    }
  }

  @override
  void onClose() {
    _userWorker?.dispose();
    receivingListController.dispose();
    yourRequestsListController.dispose();
    super.onClose();
  }
}
