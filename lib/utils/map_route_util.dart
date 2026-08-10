import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/logger_helper.dart';

class MapRouteResult {
  const MapRouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final List<LatLng> points;

  final double distanceMeters;

  final double durationSeconds;

  String get distanceLabel {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${distanceMeters.round()} m';
  }

  String get durationLabel {
    final totalMinutes = (durationSeconds / 60).round().clamp(1, 999999);
    if (totalMinutes < 60) return '$totalMinutes phút';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (minutes == 0) return '$hours giờ';
    return '$hours giờ $minutes phút';
  }

  Polyline toPolyline({double strokeWidth = 4, Color color = const Color(0xFF2563EB)}) {
    return Polyline(points: points, strokeWidth: strokeWidth, color: color);
  }
}


class MapRouteUtil {
  MapRouteUtil._();

  static Future<MapRouteResult?> fetchDrivingRoute({
    required LatLng from,
    required LatLng to,
    Duration timeout = const Duration(seconds: 12),
  }) {
    return fetchDrivingRouteAlong(points: [from, to], timeout: timeout);
  }

  static Future<MapRouteResult?> fetchDrivingRouteAlong({
    required List<LatLng> points,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    if (points.length < 2) return null;

    try {
      final baseUrl = AppConstants.osrmRouteUrl.replaceAll(RegExp(r'/+$'), '');
      // OSRM: lon,lat ; lon,lat
      final coords = points.map((p) => '${p.longitude},${p.latitude}').join(';');
      final uri = Uri.parse('$baseUrl/$coords?overview=full&geometries=geojson');

      final response = await http.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        loggerHelper.error('OSRM route failed: ${response.statusCode}');
        return null;
      }

      final body = jsonDecode(response.body);
      if (body is! Map) return null;

      if ((body['code']?.toString() ?? '') != 'Ok') {
        loggerHelper.error('OSRM route code: ${body['code']}');
        return null;
      }

      final routes = body['routes'];
      if (routes is! List || routes.isEmpty) return null;

      final route = routes.first;
      if (route is! Map) return null;

      final distance = (route['distance'] as num?)?.toDouble() ?? 0;
      final duration = (route['duration'] as num?)?.toDouble() ?? 0;
      final geometry = route['geometry'];
      if (geometry is! Map) return null;

      final rawCoords = geometry['coordinates'];
      if (rawCoords is! List || rawCoords.isEmpty) return null;

      final latLngPoints = <LatLng>[];
      for (final item in rawCoords) {
        if (item is! List || item.length < 2) continue;
        final lon = (item[0] as num?)?.toDouble();
        final lat = (item[1] as num?)?.toDouble();
        if (lon == null || lat == null) continue;
        // GeoJSON [lon, lat] → LatLng(lat, lon)
        latLngPoints.add(LatLng(lat, lon));
      }

      if (latLngPoints.length < 2) return null;

      return MapRouteResult(
        points: latLngPoints,
        distanceMeters: distance,
        durationSeconds: duration,
      );
    } catch (e) {
      loggerHelper.error('fetchDrivingRouteAlong error: $e');
      return null;
    }
  }
}
