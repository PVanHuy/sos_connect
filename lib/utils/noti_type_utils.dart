class NotiTypeUtils {
  static const String joinRequest = 'join_request';
  static const String announcement = 'announcement';
  static const String teamMembership = 'team_membership';
  static const String teamRegistration = 'team_registration';
  static const String sosRequest = 'sos_request';
  static const String chat = 'chat';
  static const String appeal = 'appeal';
}

class NotiActionUtils {
  static const String created = 'created';
  static const String rejected = 'rejected';
  static const String accepted = 'accepted';
  static const String approved = 'approved';
  static const String supported = 'supported';
  static const String broadcast = 'broadcast';
  static const String kicked = 'kicked';
  static const String nearby = 'nearby';
  static const String newMessage = 'new_message';
  static const String deleted = 'deleted';
  static const String resolved = 'resolved';

  static bool isSosRequesterUpdate(String? action) {
    final value = (action ?? '').trim().toLowerCase();
    return value == approved || value == supported || value == rejected;
  }

  static bool isSosNearby(String? action) => (action ?? '').trim().toLowerCase() == nearby;
}
