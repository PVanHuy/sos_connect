import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/location_util.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/utils/sos_list_filter_utils.dart';
import 'package:sos_connect/utils/sos_status_utils.dart';
import 'package:sos_connect/utils/vietnam_address_utils.dart';
import 'package:sos_connect/widget/dialog/show_alert_dialog.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';
import 'package:sos_connect/widget/dialog/show_sos_list_filter_dialog.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

class SupportController extends GetxController {
  SupportController({required this.sosRepository, required this.teamRepository});

  final ISosRepository sosRepository;
  final ITeamRepository teamRepository;

  final selectedType = SosEmergencyType.needRescue.obs;
  final selectedProvince = Rxn<Province>();
  final currentLatLng = Rxn<LatLng>();
  final selectedRadiusKm = RxnInt();
  final selectedTimeWindow = RxnString();
  final acceptingId = RxnString();
  final hasActiveSupport = false.obs;

  late final LazyListController<SosEventModel> sosListController;

  String get selectedProvinceName => selectedProvince.value?.name ?? 'select_province_city'.tr;

  bool get hasActiveFilter => selectedRadiusKm.value != null || selectedTimeWindow.value != null;

  bool get _hasTeamRole {
    if (!Get.isRegistered<DashboardController>()) return false;
    final user = Get.find<DashboardController>().userModel.value;
    if (user == null) return false;

    final role = (user.roles ?? '').toLowerCase();
    if (role == UserRoleUtils.leader) return true;

    final teamId = user.teamId?.trim() ?? '';
    return role == UserRoleUtils.volunteer && teamId.isNotEmpty;
  }

  bool get canAcceptSos => _hasTeamRole && !hasActiveSupport.value;

  @override
  void onInit() {
    super.onInit();
    sosListController = LazyListController<SosEventModel>(
      onLoad: (page) async {
        final position = currentLatLng.value;
        return sosRepository.getEvents(
          page: page,
          status: SosStatusUtils.pending,
          type: selectedType.value.apiType,
          province: selectedProvince.value?.name,
          timeWindow: selectedTimeWindow.value,
          radius: SosListFilterUtils.toMeters(selectedRadiusKm.value),
          centerLat: position?.latitude,
          centerLon: position?.longitude,
        );
      },
    );
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _prefillLocation();
    if (isClosed) return;
    await fetchActiveSupportStatus();
    if (isClosed) return;
    await sosListController.onRefresh();
  }

  Future<void> refreshList() async {
    await fetchActiveSupportStatus();
    await sosListController.onRefresh();
  }

  Future<void> fetchActiveSupportStatus() async {
    if (!_hasTeamRole) {
      hasActiveSupport.value = false;
      return;
    }

    try {
      final result = await teamRepository.getAllSupport(status: SosStatusUtils.inProgress);
      if (isClosed) return;
      hasActiveSupport.value = result.models.isNotEmpty;
    } catch (e) {
      loggerHelper.error('Fetch active support status error: $e');
    }
  }

  Future<void> _prefillLocation() async {
    try {
      LatLng? position;
      if (Get.isRegistered<MapController>()) {
        position = Get.find<MapController>().currentPosition.value;
      }

      if (position == null) {
        final result = await LocationUtil.getCurrentLatLng();
        if (!result.isSuccess || result.position == null) return;
        position = result.position;
      }

      currentLatLng.value = position;
    } catch (e) {
      loggerHelper.error('Prefill support list location error: $e');
    }
  }

  void selectType(SosEmergencyType type) {
    if (selectedType.value == type) return;
    selectedType.value = type;
    sosListController.onRefresh();
  }

  Future<void> selectProvince() async {
    final selected = await VietnamAddressUtils.pickProvince();
    if (selected == null) return;
    selectedProvince.value = selected;
    await sosListController.onRefresh();
  }

  Future<void> openListFilter() async {
    final result = await showSosListFilterDialog(
      radiusKm: selectedRadiusKm.value,
      timeWindow: selectedTimeWindow.value,
    );
    if (result == null) return;

    selectedRadiusKm.value = result.radiusKm;
    selectedTimeWindow.value = result.timeWindow;
    await sosListController.onRefresh();
  }

  void onAcceptSos(SosEventModel event) {
    final sosId = event.id?.trim() ?? '';
    if (sosId.isEmpty || acceptingId.value != null) return;

    if (hasActiveSupport.value) {
      showAlertDialog(title: 'accept_rescue'.tr, content: 'accept_rescue_limit_content'.tr);
      return;
    }

    showConfirmDialog(
      title: 'accept_rescue_confirm_title'.tr,
      content: 'accept_rescue_confirm_content'.tr,
      titleBtn: 'accept_rescue'.tr,
      onConfirm: () => _acceptSos(sosId),
    );
  }

  Future<void> _acceptSos(String sosId) async {
    if (acceptingId.value != null || hasActiveSupport.value) return;

    try {
      acceptingId.value = sosId;
      final response = await teamRepository.acceptSupport(sosId);
      if (response.isOk) {
        hasActiveSupport.value = true;
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showSuccessDialog(message ?? 'accept_rescue_success'.tr);
        sosListController.removeWhere((item) => item.id == sosId);
        if (Get.isRegistered<MapController>()) {
          Get.find<MapController>().removeSos(sosId);
        }
      } else {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showErrorDialog(message ?? '');
        await fetchActiveSupportStatus();
      }
    } catch (e) {
      loggerHelper.error('Accept SOS error: $e');
    } finally {
      acceptingId.value = null;
    }
  }

  void handleNewSosEvent(SosEventModel event) {
    final id = event.id?.trim() ?? '';
    if (id.isEmpty) return;

    final status = event.status?.trim().toUpperCase() ?? '';
    if (status.isNotEmpty && !status.isSosPending) return;

    if (event.emergencyType != selectedType.value) return;

    final provinceFilter = selectedProvince.value?.name;
    if (provinceFilter != null && provinceFilter.isNotEmpty) {
      final eventProvince = event.province?.trim() ?? '';
      if (eventProvince != provinceFilter) return;
    }

    final radiusKm = selectedRadiusKm.value;
    final center = currentLatLng.value;
    if (radiusKm != null && center != null && event.lat != null && event.lon != null) {
      const distance = Distance();
      final meters = distance.as(LengthUnit.Meter, center, LatLng(event.lat!, event.lon!));
      if (meters > radiusKm * 1000) return;
    }

    if (sosListController.findIndex((item) => item.id == id) >= 0) return;

    sosListController.insert(0, event);
  }

  String formatSosTime(String? createdAt) => createdAt.toRelativeTime;

  @override
  void onClose() {
    sosListController.dispose();
    super.onClose();
  }
}
