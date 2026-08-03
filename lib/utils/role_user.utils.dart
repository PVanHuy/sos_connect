import 'package:get/get.dart';

class UserRoleUtils {
  static const String guest = 'guest';
  static const String volunteer = 'volunteer';
  static const String leader = 'leader';
}

extension UserRoleExtension on String {
  String get userRoleName {
    switch (toLowerCase()) {
      case UserRoleUtils.guest:
        return 'role_guest'.tr;
      case UserRoleUtils.volunteer:
        return 'role_volunteer'.tr;
      case UserRoleUtils.leader:
        return 'role_leader'.tr;
      default:
        return this;
    }
  }
}

/// Role khi đăng ký đội cứu hộ (position).
class RescueTeamRoleUtils {
  static const String volunteer = UserRoleUtils.volunteer;
  static const String leader = UserRoleUtils.leader;
}

extension RescueTeamRoleExtension on String {
  String get rescueTeamRoleName => userRoleName;
}
