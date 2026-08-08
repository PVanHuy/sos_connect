class SocketEvent {
  static const String subscribe = 'subscribe';

  static const String channelSosFeed = 'sos-feed';
  static const String channelSosMap = 'sos-map';

  static const String sosNewRequest = 'sos:new_request';
  static const String sosMapUpdated = 'sos:map_updated';

  /// Namespace: /team/live_mode
  static const String teamToggleLiveMode = 'team:toggle_live_mode';
  static const String teamUpdateLocation = 'team:update_location';
  static const String sosNearbyAlert = 'sos:nearby_alert';

  /// Namespace: /chat
  static const String chatJoin = 'chat:join';
  static const String chatJoined = 'chat:joined';
  static const String chatSendMessage = 'chat:send_message';
  static const String chatNewMessage = 'chat:new_message';
  static const String chatRoomReady = 'chat:room_ready';
}
