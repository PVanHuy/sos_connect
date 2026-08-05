import 'dart:async';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/shared_key.dart';

class SocketIoService extends GetxService {
  socket_io_client.Socket? _socket;

  final Map<String, List<Function(dynamic)>> _listeners = {};
  final List<Function(String, dynamic)> _anyListeners = [];
  final List<Function()> _reconnectedCallbacks = [];

  final Rx<SocketIoConnectionState> connectionState = SocketIoConnectionState.disconnected.obs;

  bool get isConnected =>
      _socket != null && _socket!.connected && connectionState.value == SocketIoConnectionState.connected;

  bool _hasConnectedOnce = false;
  String? _lastServerUri;

  static String resolveSocketServerUri(String? staffRole) {
    final uri = '${AppConstants.socketUrl}/user/noti';

    return uri;
  }

  Map<String, dynamic> _authPayload() {
    String token = LocalStorage.getString(SharedKey.token);

    return {'token': token};
  }

  void _handleIncomingEvent(String event, dynamic data) {
    for (final callback in List<Function(String, dynamic)>.from(_anyListeners)) {
      try {
        callback(event, data);
      } catch (e) {
        loggerHelper.log('[WS ANY LISTENER ERROR] $e');
      }
    }

    if (_listeners.containsKey(event)) {
      for (final callback in List<Function(dynamic)>.from(_listeners[event]!)) {
        try {
          callback(data);
        } catch (e) {
          loggerHelper.log('[WS LISTENER ERROR on $event] $e');
        }
      }
    }
  }

  @override
  void onClose() {
    disconnect();
    _socket?.dispose();
    _socket = null;
    super.onClose();
  }

  Future<void> connect({String? staffRole}) async {
    final serverUri = resolveSocketServerUri(staffRole);

    if (isConnected && _lastServerUri == serverUri) {
      return;
    }

    if (_socket != null) {
      if (_lastServerUri == serverUri) {
        try {
          _socket!.auth = _authPayload();
          _socket!.connect();
          return;
        } catch (_) {
          disconnect();
        }
      } else {
        disconnect();
      }
    }

    connectionState.value = SocketIoConnectionState.connecting;
    loggerHelper.log('Connecting to Socket.IO… $serverUri', name: 'SocketIoService');

    _lastServerUri = serverUri;
    _socket = socket_io_client.io(
      serverUri,
      socket_io_client.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setAuth(_authPayload())
          .setPath('/socket.io')
          .enableForceNew()
          .enableAutoConnect()
          .build(),
    );

    _socket!.on('connect_error', (data) {
      connectionState.value = SocketIoConnectionState.error;
      loggerHelper.log('[WS CONNECT_ERROR] ${data?.toString()}', name: 'SocketIoService - CONNECT_ERROR');
    });

    _socket!.on('connect_failed', (data) {
      connectionState.value = SocketIoConnectionState.error;
      loggerHelper.log('[WS CONNECT_FAILED] ${data?.toString()}', name: 'SocketIoService - CONNECT_FAILED');
    });

    _socket!.onAny((String event, dynamic data) {
      _handleIncomingEvent(event, data);
    });

    _socket!.onConnect((_) {
      connectionState.value = SocketIoConnectionState.connected;
      loggerHelper.log('[WS CONNECTED] id=${_socket?.id}', name: 'SocketIoService - CONNECTED');

      if (_hasConnectedOnce) {
        for (final cb in List<Function()>.from(_reconnectedCallbacks)) {
          try {
            cb();
          } catch (e) {
            loggerHelper.log('[WS RECONNECTED CALLBACK ERROR] $e');
          }
        }
      }
      _hasConnectedOnce = true;
    });

    _socket!.onDisconnect((reason) {
      connectionState.value = SocketIoConnectionState.disconnected;
      loggerHelper.log('[WS DISCONNECTED] reason=$reason', name: 'SocketIoService - DISCONNECTED');
    });

    _socket!.onError((err) {
      connectionState.value = SocketIoConnectionState.error;
      loggerHelper.log('[WS ERROR] ${err?.toString()}');
    });

    _socket!.connect();
  }

  void disconnect() {
    if (_socket == null) return;
    try {
      _socket!.disconnect();
    } catch (_) {}
    _socket = null;
    _lastServerUri = null;
    connectionState.value = SocketIoConnectionState.disconnected;
    loggerHelper.log('Socket.IO disconnected');
  }

  void emit(String event, dynamic data) {
    if (!isConnected) {
      loggerHelper.log('[WS] Cannot emit, not connected');
      return;
    }

    try {
      loggerHelper.log('[SEND] event=$event data=$data', name: 'WebSocketService - SEND');
      _socket!.emit(event, data);
    } catch (e) {
      loggerHelper.log('[EMIT ERROR] $e');
    }
  }

  void subscribe(String channel) {
    emit('subscribe', {'channel': channel});
  }

  void on(String event, Function(dynamic data) callback) {
    final list = _listeners.putIfAbsent(event, () => []);
    // Idempotent: never register the exact same callback twice for one event.
    if (!list.contains(callback)) {
      list.add(callback);
    }
  }

  void off(String event, [Function(dynamic data)? callback]) {
    if (callback == null) {
      _listeners.remove(event);
    } else {
      _listeners[event]?.remove(callback);
    }
  }

  void onAny(Function(String event, dynamic data) callback) {
    if (!_anyListeners.contains(callback)) {
      _anyListeners.add(callback);
    }
  }

  void offAny(Function(String event, dynamic data) callback) {
    _anyListeners.remove(callback);
  }

  void addReconnectedCallback(Function() callback) {
    _reconnectedCallbacks.add(callback);
  }

  void clearReconnectedCallbacks() {
    _reconnectedCallbacks.clear();
  }
}

enum SocketIoConnectionState { disconnected, connecting, connected, error }
