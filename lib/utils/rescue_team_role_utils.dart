import 'package:get/get.dart';

class RescueTeamRoleUtils {
  static const String volunteer = 'volunteer';
  static const String leader = 'leader';
}

extension RescueTeamRoleExtension on String {
  String get rescueTeamRoleName {
    switch (this) {
      case RescueTeamRoleUtils.volunteer:
        return 'role_volunteer'.tr;
      case RescueTeamRoleUtils.leader:
        return 'role_leader'.tr;
      default:
        return '';
    }
  }
}
