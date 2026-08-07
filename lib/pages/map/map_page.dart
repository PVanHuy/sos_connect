import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/pages/map/widget/map_weather_bar_widget.dart';
import 'package:sos_connect/utils/map_marker_cluster_util.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class MapPage extends GetWidget<MapController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      body: Stack(
        children: [
          RepaintBoundary(
            child: FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: MapController.initialCenter,
                initialZoom: MapController.initialZoom,
                minZoom: 5,
                maxZoom: 18,
                backgroundColor: appTheme.grayF1Color,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
                onMapReady: controller.onMapReady,
                onTap: (tapPosition, point) => controller.clearSelection(),
                onPositionChanged: controller.onMapPositionChanged,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.sosconnect.app',
                  maxNativeZoom: 19,
                  keepBuffer: 2,
                  panBuffer: 1,
                ),
                Obx(() {
                  if (controller.isClusterMode) {
                    final clusters = controller.clusters.toList();
                    return MarkerLayer(
                      markers: [
                        for (final cluster in clusters)
                          Marker(
                            point: cluster.point,
                            width: cluster.count >= 10 ? 56 : 48,
                            height: cluster.count >= 10 ? 56 : 48,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () => controller.onClusterTap(cluster),
                              child: MapMarkerClusterUtil.buildClusterBubble(cluster.count),
                            ),
                          ),
                      ],
                    );
                  }

                  final selectedId = controller.selectedId.value;
                  final items = controller.items.toList();
                  return MarkerLayer(
                    markers: MapMarkerClusterUtil.buildSosMarkers(
                      items: items,
                      selectedId: selectedId,
                      onTap: controller.selectItem,
                    ),
                  );
                }),
                Obx(() {
                  final myPos = controller.currentPosition.value;
                  if (myPos == null) return const SizedBox.shrink();

                  final zoom = controller.mapZoom.value;
                  final width = MapMarkerClusterUtil.myLocationPinWidth(zoom);
                  final height = MapMarkerClusterUtil.myLocationPinHeight(zoom);

                  return MarkerLayer(
                    markers: [
                      Marker(
                        point: myPos,
                        width: width,
                        height: height,
                        alignment: Alignment.bottomCenter,
                        child: Assets.images.pinLocation.image(width: width, height: height, fit: BoxFit.contain),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: padding(horizontal: 16, top: 8),
                child: Obx(
                  () => MapWeatherBarWidget(
                    weather: controller.weather.value,
                    isLoading: controller.isWeatherLoading.value,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16.w,
            bottom: 24.h,
            child: SafeArea(
              top: false,
              child: Obx(
                () => FloatingActionButton.small(
                  heroTag: 'map_my_location',
                  backgroundColor: appTheme.whiteColor,
                  onPressed: controller.isLocating.value ? null : controller.goToMyLocation,
                  child: controller.isLocating.value
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: CircularProgressIndicator(strokeWidth: 2, color: appTheme.appColor),
                        )
                      : Icon(Icons.my_location_rounded, color: appTheme.appColor, size: 22.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
