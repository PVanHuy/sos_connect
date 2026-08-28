import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/utils/team_status_utils.dart';

class SosStatusUtils {
  static const String pending = 'PENDING';
  static const String requested = 'REQUESTED';
  static const String inProgress = 'IN_PROGRESS';
  static const String complete = 'COMPLETE';
  static const String canceled = 'CANCELED';
  static const String rejected = 'REJECTED';
}

extension SosStatusExtension on String {
  bool get isSosInProgress => toUpperCase() == SosStatusUtils.inProgress;
  bool get isSosComplete => toUpperCase() == SosStatusUtils.complete;
  bool get isSosPending => toUpperCase() == SosStatusUtils.pending;
  bool get isSosRejected => toUpperCase() == SosStatusUtils.rejected;

  String get sosStatusName {
    switch (toUpperCase()) {
      case SosStatusUtils.pending:
        return 'sos_status_pending'.tr;
      case SosStatusUtils.requested:
        return 'sos_status_requested'.tr;
      case SosStatusUtils.inProgress:
        return 'sos_status_in_progress'.tr;
      case SosStatusUtils.complete:
        return 'sos_status_complete'.tr;
      case SosStatusUtils.canceled:
        return 'sos_status_canceled'.tr;
      case SosStatusUtils.rejected:
        return 'sos_status_rejected'.tr;
      default:
        return this;
    }
  }

  TeamStatusStyle get sosStatusStyle {
    switch (toUpperCase()) {
      case SosStatusUtils.pending:
      case SosStatusUtils.requested:
        return TeamStatusStyle(
          background: appTheme.yellowE6Color,
          text: appTheme.yellow22Color,
          border: appTheme.yellow22Color,
        );
      case SosStatusUtils.inProgress:
        return TeamStatusStyle(
          background: appTheme.blueE8Color,
          text: appTheme.appColor,
          border: appTheme.appColor,
        );
      case SosStatusUtils.complete:
        return TeamStatusStyle(
          background: appTheme.bgGreenColor,
          text: appTheme.green47Color,
          border: appTheme.green47Color,
        );
      case SosStatusUtils.canceled:
      case SosStatusUtils.rejected:
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
