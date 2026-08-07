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
}
