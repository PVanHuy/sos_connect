import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/utils/team_status_utils.dart';

class JoinTeamRequestStatusUtils {
  static const String accepted = 'ACCEPTED';
  static const String rejected = 'REJECTED';
  static const String pending = 'PENDING';
}

extension JoinTeamRequestStatusExtension on String? {
  bool get isJoinRequestAccepted => (this ?? '').toUpperCase() == JoinTeamRequestStatusUtils.accepted;
  bool get isJoinRequestRejected => (this ?? '').toUpperCase() == JoinTeamRequestStatusUtils.rejected;
  bool get isJoinRequestPending => (this ?? '').toUpperCase() == JoinTeamRequestStatusUtils.pending;

  String get joinRequestStatusName {
    switch ((this ?? '').toUpperCase()) {
      case JoinTeamRequestStatusUtils.accepted:
        return 'join_request_status_accepted'.tr;
      case JoinTeamRequestStatusUtils.rejected:
        return 'join_request_status_rejected'.tr;
      case JoinTeamRequestStatusUtils.pending:
        return 'join_request_status_pending'.tr;
      default:
        return (this ?? '').toString();
    }
  }

  TeamStatusStyle get joinRequestStatusStyle {
    switch ((this ?? '').toUpperCase()) {
      case JoinTeamRequestStatusUtils.accepted:
        return TeamStatusStyle(
          background: appTheme.bgGreenColor,
          text: appTheme.green47Color,
          border: appTheme.green47Color,
        );
      case JoinTeamRequestStatusUtils.rejected:
        return TeamStatusStyle(background: appTheme.redF4Color, text: appTheme.red55Color, border: appTheme.red55Color);
      case JoinTeamRequestStatusUtils.pending:
        return TeamStatusStyle(
          background: appTheme.yellowE6Color,
          text: appTheme.yellow22Color,
          border: appTheme.yellow22Color,
        );
      default:
        return TeamStatusStyle(
          background: appTheme.grayF1Color,
          text: appTheme.oldSliverColor,
          border: appTheme.oldSliverColor,
        );
    }
  }
}
