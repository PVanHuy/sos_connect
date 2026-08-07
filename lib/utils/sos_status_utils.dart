import 'package:get/get.dart';

class SosStatusUtils {
  static const String pending = 'PENDING';
  static const String requested = 'REQUESTED';
  static const String inProgress = 'IN_PROGRESS';
  static const String complete = 'COMPLETE';
  static const String canceled = 'CANCELED';
}

extension SosStatusExtension on String {
  bool get isSosInProgress => toUpperCase() == SosStatusUtils.inProgress;
  bool get isSosComplete => toUpperCase() == SosStatusUtils.complete;
  bool get isSosPending => toUpperCase() == SosStatusUtils.pending;

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
      default:
        return this;
    }
  }
}
