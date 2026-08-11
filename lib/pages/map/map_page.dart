import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/pages/map/widget/map_weather_bar_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
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
                  final route = controller.activeRoute.value;
                  if (route == null) return const SizedBox.shrink();
                  return PolylineLayer(polylines: [route.toPolyline(strokeWidth: 5, color: appTheme.appColor)]);
                }),
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
                  final destination = controller.routeDestination.value;
                  final hasRoute = controller.activeRoute.value != null;
                  final zoom = controller.mapZoom.value;
                  final markers = <Marker>[];

                  if (myPos != null) {
                    if (hasRoute) {
                      markers.add(
                        Marker(
                          point: myPos,
                          width: 44.w,
                          height: 44.w,
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: appTheme.whiteColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: appTheme.blackColor.withSafeOpacity(0.22),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(Icons.navigation_rounded, color: appTheme.appColor, size: 26.w),
                          ),
                        ),
                      );
                    } else {
                      final width = MapMarkerClusterUtil.myLocationPinWidth(zoom);
                      final height = MapMarkerClusterUtil.myLocationPinHeight(zoom);
                      markers.add(
                        Marker(
                          point: myPos,
                          width: width,
                          height: height,
                          alignment: Alignment.bottomCenter,
                          child: Assets.images.pinLocation.image(width: width, height: height, fit: BoxFit.contain),
                        ),
                      );
                    }
                  }

                  if (destination != null) {
                    markers.add(
                      Marker(
                        point: destination,
                        width: 36.w,
                        height: 36.w,
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: appTheme.appColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: appTheme.whiteColor, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: appTheme.blackColor.withSafeOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.flag_rounded, color: appTheme.whiteColor, size: 18.w),
                        ),
                      ),
                    );
                  }

                  if (markers.isEmpty) return const SizedBox.shrink();
                  return MarkerLayer(markers: markers);
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
            left: 16.w,
            right: 16.w,
            bottom: 24.h,
            child: SafeArea(
              top: false,
              child: Obx(() {
                final route = controller.activeRoute.value;
                final hasRoute = route != null;
                final isLocating = controller.isLocating.value;
                final isFollowing = controller.isFollowingLocation.value;

                final locationBtn = Material(
                  color: isFollowing ? appTheme.appColor : appTheme.whiteColor,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: isLocating ? null : controller.goToMyLocation,
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 48.w,
                      height: hasRoute ? null : 48.w,
                      child: Center(
                        child: isLocating
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: isFollowing ? appTheme.whiteColor : appTheme.appColor,
                                ),
                              )
                            : Icon(
                                isFollowing ? Icons.navigation_rounded : Icons.my_location_rounded,
                                color: isFollowing ? appTheme.whiteColor : appTheme.appColor,
                                size: 24.w,
                              ),
                      ),
                    ),
                  ),
                );

                if (!hasRoute) {
                  return Align(alignment: Alignment.centerRight, child: locationBtn);
                }

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Material(
                          color: appTheme.whiteColor,
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: padding(horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                Icon(Icons.route_rounded, color: appTheme.appColor, size: 22.w),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    '${route.distanceLabel} · ${route.durationLabel}',
                                    style: StyleThemeData.size14Weight700(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'route_clear'.tr,
                                  onPressed: controller.clearRoute,
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(Icons.close_rounded, color: appTheme.gray83Color, size: 22.w),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      locationBtn,
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
