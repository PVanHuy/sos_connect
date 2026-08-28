import 'package:get/get.dart';

class AppealTargetTypeUtils {
  static const String teamRegistration = 'team_registration';
  static const String teamDeletion = 'team_deletion';
  static const String sosRejection = 'sos_rejection';
}

extension AppealTargetTypeExtension on String? {
  String get appealTargetTypeName {
    switch ((this ?? '').trim().toLowerCase()) {
      case AppealTargetTypeUtils.teamRegistration:
        return 'appeal_target_team_registration'.tr;
      case AppealTargetTypeUtils.teamDeletion:
        return 'appeal_target_team_deletion'.tr;
      case AppealTargetTypeUtils.sosRejection:
        return 'appeal_target_sos_rejection'.tr;
      default:
        return (this ?? '').toString();
    }
  }
}
