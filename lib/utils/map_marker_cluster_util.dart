import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/map/map_sos_item_model.dart';
import 'package:sos_connect/pages/map/widget/map_sos_marker_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';

/// Utility gom marker gần nhau + animation zoom in/out (spiderfy).
class MapMarkerClusterUtil {
  MapMarkerClusterUtil._();

  static const AnimationsOptions animationsOptions = AnimationsOptions(
    zoom: Duration(milliseconds: 450),
    fitBound: Duration(milliseconds: 500),
    centerMarker: Duration(milliseconds: 400),
    spiderfy: Duration(milliseconds: 480),
    fadeInCurve: Curves.easeOutCubic,
    fadeOutCurve: Curves.easeInCubic,
    clusterExpandCurve: Curves.easeOutBack,
    clusterCollapseCurve: Curves.easeInCubic,
    spiderifyCurve: Curves.easeOutCubic,
    fitBoundCurves: Curves.easeInOutCubic,
    centerMarkerCurves: Curves.easeOutCubic,
  );

  static List<Marker> buildSosMarkers({
    required List<MapSosItemModel> items,
    required String? selectedId,
    required void Function(MapSosItemModel item) onTap,
  }) {
    return [
      for (final item in items)
        Marker(
          key: ValueKey(item.id),
          point: item.point,
          width: selectedId == item.id ? 56 : 44,
          height: selectedId == item.id ? 64 : 52,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () => onTap(item),
            child: MapSosMarkerWidget(type: item.type, isSelected: selectedId == item.id),
          ),
        ),
    ];
  }

  /// Layer cluster: zoom nhỏ → gom + hiện số; zoom lớn → bung marker có animation.
  static Widget buildClusterLayer({required List<Marker> markers}) {
    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        markers: markers,
        maxClusterRadius: 56,
        disableClusteringAtZoom: 15,
        size: const Size(48, 48),
        computeSize: (clusterMarkers) {
          final count = clusterMarkers.length;
          if (count >= 10) return const Size(56, 56);
          if (count >= 5) return const Size(52, 52);
          return const Size(48, 48);
        },
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40),
        maxZoom: 17,
        forceIntegerZoomLevel: false,
        zoomToBoundsOnClick: true,
        centerMarkerOnClick: false,
        spiderfyCluster: true,
        spiderfyCircleRadius: 56,
        spiderfySpiralDistanceMultiplier: 2,
        showPolygon: false,
        markerChildBehavior: true,
        animationsOptions: animationsOptions,
        builder: (context, clusterMarkers) => buildClusterBubble(clusterMarkers.length),
      ),
    );
  }

  static Widget buildClusterBubble(int count) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [appTheme.appColor, appTheme.appColor.withSafeOpacity(0.82)],
        ),
        border: Border.all(color: appTheme.whiteColor, width: 3),
        boxShadow: [
          BoxShadow(color: appTheme.appColor.withSafeOpacity(0.35), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Center(
        child: Text(count > 99 ? '99+' : '$count', style: StyleThemeData.size14Weight700(color: appTheme.whiteColor)),
      ),
    );
  }

  /// Pin vị trí hiện tại: zoom nhỏ → pin nhỏ hơn để không che marker SOS.
  static double myLocationPinWidth(double zoom) {
    final t = ((zoom - 10) / 6).clamp(0.0, 1.0);
    return 14 + t * 22; // ~zoom 10: 14px, zoom 16+: 36px
  }

  static double myLocationPinHeight(double zoom) {
    return myLocationPinWidth(zoom) * (44 / 36);
  }
}
