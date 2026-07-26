import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos_connect/model/map/map_sos_item_model.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/location_util.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/utils/weather_util.dart';
import 'package:sos_connect/widget/dialog/show_map_sos_detail_dialog.dart';

class MapController extends GetxController {
  final fmap.MapController mapController = fmap.MapController();

  final selectedId = RxnString();
  final currentPosition = Rxn<LatLng>();
  final weather = Rxn<WeatherInfo>();
  final isLocating = false.obs;
  final isWeatherLoading = false.obs;
  final mapZoom = initialZoom.obs;

  final List<MapSosItemModel> items = const [
    MapSosItemModel(
      id: 'medical_binh_thanh',
      type: SosEmergencyType.medical,
      urgencyScore: '9/10',
      time: '5 phút trước',
      description: 'Người già bị ngất, cần hỗ trợ y tế khẩn cấp và đưa đến bệnh viện gần nhất.',
      address: 'Bình Thạnh, TP.HCM',
      acceptButtonTextKey: 'accept_rescue',
      point: LatLng(10.8106, 106.7091),
      imageUrl: 'https://picsum.photos/seed/sos-medical/800/500',
    ),
    MapSosItemModel(
      id: 'medical_binh_thanh_2',
      type: SosEmergencyType.medical,
      urgencyScore: '7/10',
      time: '8 phút trước',
      description: 'Tai nạn giao thông nhẹ, có người bị thương cần sơ cứu.',
      address: 'Bình Thạnh, TP.HCM',
      acceptButtonTextKey: 'accept_rescue',
      point: LatLng(10.8128, 106.7115),
      imageUrl: 'https://picsum.photos/seed/sos-medical-2/800/500',
    ),
    MapSosItemModel(
      id: 'rescue_quan_7',
      type: SosEmergencyType.needRescue,
      urgencyScore: '8/10',
      time: '12 phút trước',
      description: 'Xe bị kẹt giữa dòng nước lũ, trên xe có 2 người lớn và 1 trẻ em.',
      address: 'Quận 7, TP.HCM',
      acceptButtonTextKey: 'accept_mission',
      point: LatLng(10.7340, 106.7216),
      imageUrl: 'https://picsum.photos/seed/sos-rescue/800/500',
    ),
    MapSosItemModel(
      id: 'rescue_quan_7_2',
      type: SosEmergencyType.needRescue,
      urgencyScore: '9/10',
      time: '15 phút trước',
      description: 'Nhà bị ngập sâu, cần thuyền đưa người già và trẻ em ra ngoài.',
      address: 'Quận 7, TP.HCM',
      acceptButtonTextKey: 'accept_mission',
      point: LatLng(10.7365, 106.7238),
      imageUrl: 'https://picsum.photos/seed/sos-rescue-2/800/500',
    ),
    MapSosItemModel(
      id: 'rescue_quan_7_3',
      type: SosEmergencyType.food,
      urgencyScore: '5/10',
      time: '20 phút trước',
      description: 'Khu vực bị cô lập, thiếu nước uống sạch.',
      address: 'Quận 7, TP.HCM',
      acceptButtonTextKey: 'accept_rescue',
      point: LatLng(10.7322, 106.7190),
      imageUrl: 'https://picsum.photos/seed/sos-rescue-3/800/500',
    ),
    MapSosItemModel(
      id: 'food_thu_duc',
      type: SosEmergencyType.food,
      urgencyScore: '6/10',
      time: '30 phút trước',
      description: 'Gia đình 5 người đang thiếu thực phẩm và nước uống sạch sau mưa lũ.',
      address: 'Thủ Đức, TP.HCM',
      acceptButtonTextKey: 'accept_rescue',
      point: LatLng(10.8505, 106.7720),
      imageUrl: 'https://picsum.photos/seed/sos-food/800/500',
    ),
    MapSosItemModel(
      id: 'food_thu_duc_2',
      type: SosEmergencyType.food,
      urgencyScore: '7/10',
      time: '35 phút trước',
      description: 'Điểm sơ tán thiếu suất ăn cho khoảng 20 người.',
      address: 'Thủ Đức, TP.HCM',
      acceptButtonTextKey: 'accept_rescue',
      point: LatLng(10.8528, 106.7745),
      imageUrl: 'https://picsum.photos/seed/sos-food-2/800/500',
    ),
  ];

  static const LatLng initialCenter = LatLng(10.7769, 106.7009);
  static const double initialZoom = 12;
  static const double myLocationZoom = 16;

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
    await goToMyLocation(showError: false, moveCamera: false);
    final pos = currentPosition.value ?? initialCenter;
    await loadWeather(pos);
  }

  void selectItem(MapSosItemModel item) {
    selectedId.value = item.id;
    mapController.move(item.point, 15);
    showMapSosDetailDialog(item: item).then((_) => clearSelection());
  }

  void clearSelection() {
    selectedId.value = null;
  }

  void updateMapZoom(double zoom) {
    if ((mapZoom.value - zoom).abs() < 0.05) return;
    mapZoom.value = zoom;
  }

  Future<void> goToMyLocation({bool showError = true, bool moveCamera = true}) async {
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
      }
      await loadWeather(result.position!);
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> loadWeather(LatLng point) async {
    isWeatherLoading.value = true;
    try {
      weather.value = await WeatherUtil.fetchCurrentWeather(
        latitude: point.latitude,
        longitude: point.longitude,
      );
    } finally {
      isWeatherLoading.value = false;
    }
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}
