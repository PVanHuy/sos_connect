import 'dart:async';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/resourese/service/socket/socket_event.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/location_util.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/shared_key.dart';

/// Socket namespace `/team/live_mode` — leader chia sẻ vị trí để nhận SOS nearby.
class TeamLiveModeService extends GetxService {
  static const Duration locationInterval = Duration(seconds: 240);
  static const int defaultRadiusMeters = 50000;

  socket_io_client.Socket? _socket;
  Timer? _locationTimer;

  final isLive = false.obs;
  final isToggling = false.obs;
  final radiusMeters = defaultRadiusMeters.obs;

  String get _serverUri => '${AppConstants.socketUrl}/team/live_mode';

  Map<String, dynamic> _authPayload() => {'token': LocalStorage.getString(SharedKey.token)};

  Future<bool> toggleLiveMode({bool? active, int? radius}) async {
    if (isToggling.value) return isLive.value;

    final nextActive = active ?? !isLive.value;
    final nextRadius = (radius ?? radiusMeters.value).clamp(1000, 500000);

    isToggling.value = true;
    try {
      if (nextActive) {
        await _connect();
        if (_socket == null || !_socket!.connected) {
          DialogUtils.showErrorDialog('team_live_mode_connect_failed'.tr);
          return false;
        }

        _emitToggle(active: true, radiusMeters: nextRadius);
        radiusMeters.value = nextRadius;

        final sent = await _emitCurrentLocation();
        if (!sent) {
          _emitToggle(active: false, radiusMeters: nextRadius);
          await _disconnectSocket();
          DialogUtils.showErrorDialog('team_live_mode_location_failed'.tr);
          return false;
        }

        isLive.value = true;
        _startLocationTimer();
        DialogUtils.showSuccessDialog('team_live_mode_on_success'.tr);
        return true;
      }

      if (_socket != null && _socket!.connected) {
        _emitToggle(active: false, radiusMeters: nextRadius);
      }
      await stopLiveMode(showMessage: true);
      return false;
    } catch (e) {
      loggerHelper.error('toggleLiveMode error: $e');
      DialogUtils.showErrorDialog('team_live_mode_toggle_failed'.tr);
      return isLive.value;
    } finally {
      isToggling.value = false;
    }
  }

  Future<void> stopLiveMode({bool showMessage = false}) async {
    _stopLocationTimer();
    final wasLive = isLive.value;
    isLive.value = false;

    if (_socket != null && _socket!.connected && wasLive) {
      _emitToggle(active: false, radiusMeters: radiusMeters.value);
    }
    await _disconnectSocket();

    if (showMessage && wasLive) {
      DialogUtils.showSuccessDialog('team_live_mode_off_success'.tr);
    }
  }

  Future<void> _connect() async {
    if (_socket != null && _socket!.connected) return;

    if (_socket != null) {
      await _disconnectSocket();
    }

    final completer = Completer<void>();

    _socket = socket_io_client.io(
      _serverUri,
      socket_io_client.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth(_authPayload())
          .setPath('/socket.io')
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      loggerHelper.log('[LIVE] connected id=${_socket?.id}', name: 'TeamLiveModeService');
      if (!completer.isCompleted) completer.complete();
    });

    _socket!.onConnectError((data) {
      loggerHelper.log('[LIVE] connect_error=$data', name: 'TeamLiveModeService');
      if (!completer.isCompleted) {
        completer.completeError(data ?? 'connect_error');
      }
    });

    _socket!.onDisconnect((reason) {
      loggerHelper.log('[LIVE] disconnected reason=$reason', name: 'TeamLiveModeService');
      if (isLive.value) {
        // Keep isLive true so UI still shows ON; try reconnect on next tick.
        _scheduleReconnect();
      }
    });

    _socket!.on(SocketEvent.sosNearbyAlert, _onNearbyAlert);

    _socket!.connect();

    try {
      await completer.future.timeout(const Duration(seconds: 10));
    } catch (_) {
      await _disconnectSocket();
      rethrow;
    }
  }

  void _scheduleReconnect() {
    Future.delayed(const Duration(seconds: 2), () async {
      if (!isLive.value) return;
      try {
        await _connect();
        if (_socket?.connected == true) {
          _emitToggle(active: true, radiusMeters: radiusMeters.value);
          await _emitCurrentLocation();
          _startLocationTimer();
        }
      } catch (e) {
        loggerHelper.error('Live mode reconnect error: $e');
      }
    });
  }

  void _emitToggle({required bool active, required int radiusMeters}) {
    _socket?.emit(SocketEvent.teamToggleLiveMode, {
      'active': active,
      'radius_meters': radiusMeters,
    });
    loggerHelper.log(
      '[LIVE] emit ${SocketEvent.teamToggleLiveMode} active=$active radius=$radiusMeters',
      name: 'TeamLiveModeService',
    );
  }

  Future<bool> _emitCurrentLocation() async {
    final result = await LocationUtil.getCurrentLatLng();
    if (!result.isSuccess || result.position == null) return false;

    final lat = result.position!.latitude;
    final lon = result.position!.longitude;
    _socket?.emit(SocketEvent.teamUpdateLocation, {'lat': lat, 'lon': lon});
    loggerHelper.log('[LIVE] emit ${SocketEvent.teamUpdateLocation} lat=$lat lon=$lon', name: 'TeamLiveModeService');
    return true;
  }

  void _startLocationTimer() {
    _stopLocationTimer();
    _locationTimer = Timer.periodic(locationInterval, (_) async {
      if (!isLive.value) return;
      if (_socket == null || !_socket!.connected) {
        _scheduleReconnect();
        return;
      }
      await _emitCurrentLocation();
    });
  }

  void _stopLocationTimer() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  void _onNearbyAlert(dynamic data) {
    loggerHelper.log('[LIVE] ${SocketEvent.sosNearbyAlert} data=$data', name: 'TeamLiveModeService');
    if (Get.isRegistered<SupportController>()) {
      Get.find<SupportController>().refreshList();
    }
    if (Get.isRegistered<MapController>()) {
      Get.find<MapController>().scheduleViewportReload();
    }
  }

  Future<void> _disconnectSocket() async {
    _stopLocationTimer();
    try {
      _socket?.off(SocketEvent.sosNearbyAlert);
      _socket?.disconnect();
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
  }

  @override
  void onClose() {
    unawaited(stopLiveMode());
    super.onClose();
  }
}
