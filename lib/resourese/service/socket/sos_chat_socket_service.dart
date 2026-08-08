import 'dart:async';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;
import 'package:sos_connect/model/chat/sos_chat_message_model.dart';
import 'package:sos_connect/model/chat/sos_chat_other_party_model.dart';
import 'package:sos_connect/resourese/service/socket/socket_event.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/shared_key.dart';

/// Singleton Socket.IO client for namespace `/chat`.
class SosChatSocketService extends GetxService {
  socket_io_client.Socket? _socket;
  String? _joinedSosId;
  void Function(SosChatMessageModel)? _onMessage;
  void Function(String sosId, SosChatOtherPartyModel? otherParty)? _onJoined;

  String get _serverUri => '${AppConstants.socketUrl}/chat';

  bool get _isConnected => _socket?.connected == true;

  Future<void> ensureConnected() async {
    if (_isConnected) {
      loggerHelper.debug('already connected id=${_socket?.id}');
      return;
    }
    if (_socket != null) await disconnect();

    final completer = Completer<void>();
    final token = LocalStorage.getString(SharedKey.token);

    loggerHelper.debug(
      'connecting uri=$_serverUri token=${token.isEmpty ? '(empty)' : '${token.substring(0, token.length.clamp(0, 12))}...'}',
    );

    _socket = socket_io_client.io(
      _serverUri,
      socket_io_client.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .setPath('/socket.io')
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    _socket!
      ..onAny((event, data) {
        loggerHelper.debug('<< ON ANY event=$event data=$data');
      })
      ..onConnect((_) {
        loggerHelper.debug('connected id=${_socket?.id}');
        if (!completer.isCompleted) completer.complete();
      })
      ..onConnectError((data) {
        loggerHelper.debug('connect_error data=$data');
        if (!completer.isCompleted) completer.completeError(data ?? 'connect_error');
      })
      ..onDisconnect((reason) {
        loggerHelper.debug('disconnected reason=$reason');
      })
      ..on(SocketEvent.chatNewMessage, _handleNewMessage)
      ..on(SocketEvent.chatJoined, _handleJoined)
      ..on(SocketEvent.chatRoomReady, (data) {
        loggerHelper.debug('<< ${SocketEvent.chatRoomReady} data=$data');
      })
      ..connect();

    try {
      await completer.future.timeout(const Duration(seconds: 10));
    } catch (e) {
      loggerHelper.error('SosChatSocketService ensureConnected error: $e');
      await disconnect();
      rethrow;
    }
  }

  void joinRoom(String sosId) {
    final id = sosId.trim();
    if (id.isEmpty || !_isConnected) {
      loggerHelper.debug('joinRoom skipped sosId=$id connected=$_isConnected');
      return;
    }

    final payload = {'sos_id': id};
    _joinedSosId = id;
    loggerHelper.debug('>> EMIT ${SocketEvent.chatJoin} payload=$payload');
    _socket!.emit(SocketEvent.chatJoin, payload);
  }

  void sendMessage({required String sosId, required String content}) {
    final id = sosId.trim();
    final text = content.trim();
    if (id.isEmpty || text.isEmpty || !_isConnected) {
      loggerHelper.debug('sendMessage skipped sosId=$id contentLen=${text.length} connected=$_isConnected');
      return;
    }

    if (_joinedSosId != id) joinRoom(id);

    final payload = {'sos_id': id, 'content': text};
    loggerHelper.debug('>> EMIT ${SocketEvent.chatSendMessage} payload=$payload');
    _socket!.emit(SocketEvent.chatSendMessage, payload);
  }

  void onNewMessage(void Function(SosChatMessageModel) callback) => _onMessage = callback;

  void offNewMessage(void Function(SosChatMessageModel) callback) {
    if (_onMessage == callback) _onMessage = null;
  }

  void onJoined(void Function(String sosId, SosChatOtherPartyModel? otherParty) callback) => _onJoined = callback;

  void offJoined(void Function(String sosId, SosChatOtherPartyModel? otherParty) callback) {
    if (_onJoined == callback) _onJoined = null;
  }

  void _handleJoined(dynamic data) {
    loggerHelper.debug('<< ${SocketEvent.chatJoined} raw=$data type=${data.runtimeType}');
    try {
      if (data is! Map) return;
      final map = Map<String, dynamic>.from(data);
      final sosId = (map['sos_id']?.toString() ?? '').trim();
      final rawOtherParty = map['other_party'];
      final otherParty = rawOtherParty is Map
          ? SosChatOtherPartyModel.fromJson(Map<String, dynamic>.from(rawOtherParty))
          : null;
      _onJoined?.call(sosId, otherParty);
    } catch (e) {
      loggerHelper.error('SosChat _handleJoined error: $e');
    }
  }

  void _handleNewMessage(dynamic data) {
    loggerHelper.debug('<< ${SocketEvent.chatNewMessage} raw=$data type=${data.runtimeType}');
    try {
      if (data is! Map) {
        loggerHelper.debug('new_message ignored: data is not Map');
        return;
      }
      final map = Map<String, dynamic>.from(data);
      loggerHelper.debug('<< ${SocketEvent.chatNewMessage} parsed=$map');
      final message = SosChatMessageModel.fromJson(map);
      if ((message.id?.trim() ?? '').isEmpty) {
        loggerHelper.debug('new_message ignored: empty id');
        return;
      }
      _onMessage?.call(message);
    } catch (e) {
      loggerHelper.error('SosChat _handleNewMessage error: $e');
    }
  }

  Future<void> disconnect() async {
    loggerHelper.debug('disconnecting joinedSosId=$_joinedSosId');
    _joinedSosId = null;
    try {
      _socket?.off(SocketEvent.chatNewMessage);
      _socket?.off(SocketEvent.chatJoined);
      _socket?.off(SocketEvent.chatRoomReady);
      _socket?.disconnect();
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
  }

  @override
  void onClose() {
    unawaited(disconnect());
    _onMessage = null;
    _onJoined = null;
    super.onClose();
  }
}
