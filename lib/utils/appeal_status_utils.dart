import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/utils/team_status_utils.dart';

class AppealStatusUtils {
  static const String pending = 'pending';
  static const String resolved = 'resolved';
  static const String rejected = 'rejected';
}

extension AppealStatusExtension on String? {
  bool get isAppealPending => (this ?? '').toLowerCase() == AppealStatusUtils.pending;
  bool get isAppealResolved => (this ?? '').toLowerCase() == AppealStatusUtils.resolved;
  bool get isAppealRejected => (this ?? '').toLowerCase() == AppealStatusUtils.rejected;

  String get appealStatusName {
    switch ((this ?? '').toLowerCase()) {
      case AppealStatusUtils.pending:
        return 'appeal_status_pending'.tr;
      case AppealStatusUtils.resolved:
        return 'appeal_status_resolved'.tr;
      case AppealStatusUtils.rejected:
        return 'appeal_status_rejected'.tr;
      default:
        return (this ?? '').toString();
    }
  }

  TeamStatusStyle get appealStatusStyle {
    switch ((this ?? '').toLowerCase()) {
      case AppealStatusUtils.pending:
        return TeamStatusStyle(
          background: appTheme.yellowE6Color,
          text: appTheme.yellow22Color,
          border: appTheme.yellow22Color,
        );
      case AppealStatusUtils.resolved:
        return TeamStatusStyle(
          background: appTheme.bgGreenColor,
          text: appTheme.green47Color,
          border: appTheme.green47Color,
        );
      case AppealStatusUtils.rejected:
        return TeamStatusStyle(background: appTheme.redF4Color, text: appTheme.red55Color, border: appTheme.red55Color);
      default:
        return TeamStatusStyle(
          background: appTheme.grayF1Color,
          text: appTheme.oldSliverColor,
          border: appTheme.oldSliverColor,
        );
    }
  }
}
