import 'package:get/get.dart';
import 'package:sos_connect/model/team/current_join_team_request_model.dart';
import 'package:sos_connect/model/team/rescue_team_model.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/join_team_request_status_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/vietnam_address_utils.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';

class RescueTeamListController extends GetxController {
  final ITeamRepository teamRepository;

  RescueTeamListController({required this.teamRepository});

  late final LazyListController<RescueTeamModel> teamListController;

  var totalCount = 0.obs;
  var searchName = ''.obs;
  var selectedProvince = RxnString();
  var isSearching = false.obs;
  final currentJoinRequests = <CurrentJoinTeamRequestModel>[].obs;

  bool get hasPendingJoinRequest => currentJoinRequests.any((e) => e.status.isJoinRequestPending);

  @override
  void onInit() {
    super.onInit();
    teamListController = LazyListController<RescueTeamModel>(
      onLoad: (page) async {
        final result = await teamRepository.getTeams(
          page: page,
          name: searchName.value.trim().isEmpty ? null : searchName.value.trim(),
          province: selectedProvince.value,
        );
        totalCount.value = result.total ?? 0;
        return result;
      },
    );
    fetchCurrentJoinRequests();
  }

  Future<void> fetchCurrentJoinRequests() async {
    try {
      final result = await teamRepository.getCurrentJoinRequests(page: 1);
      currentJoinRequests.assignAll(result.models);
    } catch (e) {
      loggerHelper.error('Error fetching current join requests: $e');
    }
  }

  void onSearch(String value) {
    if (value == searchName.value) return;
    searchName.value = value;
    teamListController.onRefresh();
  }

  void onUpdateSearchStatus(bool isLoading) {
    isSearching.value = isLoading;
  }

  Future<void> onFilterProvince() async {
    final selected = await VietnamAddressUtils.pickProvince();
    if (selected == null) return;

    selectedProvince.value = selected.name;
    await teamListController.onRefresh();
  }

  Future<void> clearProvinceFilter() async {
    if (selectedProvince.value == null) return;
    selectedProvince.value = null;
    await teamListController.onRefresh();
  }

  @override
  void onClose() {
    teamListController.dispose();
    super.onClose();
  }
}
