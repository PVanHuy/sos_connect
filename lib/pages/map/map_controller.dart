import 'dart:async';

import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos_connect/model/map/events_viewport_model.dart';
import 'package:sos_connect/model/map/map_cluster_model.dart';
import 'package:sos_connect/model/map/map_sos_item_model.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/location_util.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/utils/sos_status_utils.dart';
import 'package:sos_connect/utils/weather_util.dart';
import 'package:sos_connect/widget/dialog/show_alert_dialog.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';
import 'package:sos_connect/widget/dialog/show_map_sos_detail_dialog.dart';

class MapController extends GetxController {
  MapController({required this.sosRepository, required this.teamRepository});

  final ISosRepository sosRepository;
  final ITeamRepository teamRepository;
  final fmap.MapController mapController = fmap.MapController();

  final selectedId = RxnString();
  final currentPosition = Rxn<LatLng>();
  final weather = Rxn<WeatherInfo>();
  final isLocating = false.obs;
  final isWeatherLoading = false.obs;
  final isViewportLoading = false.obs;
  final mapZoom = initialZoom.obs;
  final viewportType = EventsViewportType.markers.obs;
  final items = <MapSosItemModel>[].obs;
  final clusters = <MapClusterModel>[].obs;
  final acceptingId = RxnString();
  final hasActiveSupport = false.obs;

  static const LatLng initialCenter = LatLng(10.7769, 106.7009);
  static const double initialZoom = 12;
  static const double myLocationZoom = 16;
  static const Duration _viewportDebounce = Duration(milliseconds: 350);

  Timer? _viewportDebounceTimer;
  bool _mapReady = false;
  int _viewportRequestId = 0;
  int _weatherRequestId = 0;

  bool get isClusterMode => viewportType.value == EventsViewportType.clusters;

  bool get _isLeader {
    if (!Get.isRegistered<DashboardController>()) return false;
    final user = Get.find<DashboardController>().userModel.value;
    if (user == null) return false;
    return (user.roles ?? '').toLowerCase() == UserRoleUtils.leader;
  }

  bool get canAcceptSos => _isLeader && !hasActiveSupport.value;

  MapSosItemModel? get selectedItem {
    final id = selectedId.value;
    if (id == null) return null;
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([
      goToMyLocation(showError: false, moveCamera: false, fetchWeather: false),
      fetchActiveSupportStatus(),
    ]);
    if (isClosed) return;

    final pos = currentPosition.value ?? initialCenter;
    await loadWeather(pos);
    if (_mapReady) {
      await loadViewport();
    }
  }

  Future<void> fetchActiveSupportStatus() async {
    if (!_isLeader) {
      hasActiveSupport.value = false;
      return;
    }

    try {
      final result = await teamRepository.getAllSupport(status: SosStatusUtils.inProgress);
      if (isClosed) return;
      hasActiveSupport.value = result.models.isNotEmpty;
    } catch (e) {
      loggerHelper.error('Fetch active support status (map) error: $e');
    }
  }

  void onMapReady() {
    _mapReady = true;
    loadViewport();
  }

  void onMapPositionChanged(fmap.MapCamera camera, bool hasGesture) {
    updateMapZoom(camera.zoom);
    scheduleViewportReload();
  }

  void scheduleViewportReload() {
    _viewportDebounceTimer?.cancel();
    _viewportDebounceTimer = Timer(_viewportDebounce, () {
      loadViewport();
    });
  }

  Future<void> loadViewport() async {
    if (!_mapReady || isClosed) return;

    final requestId = ++_viewportRequestId;
    isViewportLoading.value = true;

    try {
      final camera = mapController.camera;
      final bounds = camera.visibleBounds;
      final result = await sosRepository.getEventsViewport(
        north: bounds.north,
        south: bounds.south,
        east: bounds.east,
        west: bounds.west,
        zoom: camera.zoom.round().clamp(1, 22),
        status: SosStatusUtils.pending,
      );

      if (isClosed || requestId != _viewportRequestId) return;

      viewportType.value = result.type;
      if (result.isClusters) {
        clusters.assignAll(result.clusters);
        items.clear();
        clearSelection();
      } else {
        final mapped = <MapSosItemModel>[];
        for (final event in result.markers) {
          if ((event.id?.trim() ?? '').isEmpty) continue;
          if (event.lat == null || event.lon == null) continue;
          mapped.add(MapSosItemModel.fromSosEvent(event));
        }
        items.assignAll(mapped);
        clusters.clear();
        final selected = selectedId.value;
        if (selected != null && mapped.every((item) => item.id != selected)) {
          clearSelection();
        }
      }
    } catch (e) {
      loggerHelper.error('Load map viewport error: $e');
    } finally {
      if (requestId == _viewportRequestId) {
        isViewportLoading.value = false;
      }
    }
  }

  void handleNewSosEvent(SosEventModel event) {
    scheduleViewportReload();
  }

  void handleMapUpdated({String? id, required double lat, required double lon}) {
    scheduleViewportReload();
  }

  void removeSos(String sosId) {
    final id = sosId.trim();
    if (id.isEmpty) return;
    items.removeWhere((item) => item.id == id);
    if (selectedId.value == id) clearSelection();
    scheduleViewportReload();
  }

  void selectItem(MapSosItemModel item) {
    selectedId.value = item.id;
    mapController.move(item.point, 15);
    showMapSosDetailDialog(
      item: item,
      showAcceptButton: canAcceptSos,
      onAccept: () => onAcceptSos(item),
    ).then((_) => clearSelection());
  }

  void onAcceptSos(MapSosItemModel item) {
    final sosId = item.id.trim();
    if (sosId.isEmpty || acceptingId.value != null) return;

    if (!_isLeader) return;

    if (hasActiveSupport.value) {
      showAlertDialog(title: 'accept_rescue'.tr, content: 'accept_rescue_limit_content'.tr);
      return;
    }

    showConfirmDialog(
      title: 'accept_rescue_confirm_title'.tr,
      content: 'accept_rescue_confirm_content'.tr,
      titleBtn: item.acceptButtonTextKey.tr,
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
        removeSos(sosId);
        if (Get.isRegistered<SupportController>()) {
          final supportController = Get.find<SupportController>();
          supportController.hasActiveSupport.value = true;
          supportController.sosListController.removeWhere((item) => item.id == sosId);
        }
      } else {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showErrorDialog(message ?? '');
        await fetchActiveSupportStatus();
      }
    } catch (e) {
      loggerHelper.error('Accept SOS from map error: $e');
    } finally {
      acceptingId.value = null;
    }
  }

  void onClusterTap(MapClusterModel cluster) {
    final nextZoom = (mapZoom.value + 2).clamp(initialZoom, 18.0);
    mapController.move(cluster.point, nextZoom);
    scheduleViewportReload();
  }

  void clearSelection() {
    selectedId.value = null;
  }

  void updateMapZoom(double zoom) {
    if ((mapZoom.value - zoom).abs() < 0.05) return;
    mapZoom.value = zoom;
  }

  Future<void> goToMyLocation({
    bool showError = true,
    bool moveCamera = true,
    bool fetchWeather = true,
  }) async {
    if (isLocating.value) return;
    isLocating.value = true;

    try {
      final result = await LocationUtil.getCurrentLatLng();
      if (!result.isSuccess) {
        if (showError && result.errorKey != null) {
          DialogUtils.showErrorDialog(result.errorKey!.tr);
        }
        return;
      }

      currentPosition.value = result.position;
      if (moveCamera) {
        mapController.move(result.position!, myLocationZoom);
        scheduleViewportReload();
      }
      if (fetchWeather) {
        await loadWeather(result.position!);
      }
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> loadWeather(LatLng point) async {
    final requestId = ++_weatherRequestId;
    isWeatherLoading.value = true;
    try {
      final result = await WeatherUtil.fetchCurrentWeather(
        latitude: point.latitude,
        longitude: point.longitude,
      );
      if (isClosed || requestId != _weatherRequestId) return;
      weather.value = result;
    } finally {
      if (requestId == _weatherRequestId) {
        isWeatherLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    _viewportDebounceTimer?.cancel();
    mapController.dispose();
    super.onClose();
  }
}
