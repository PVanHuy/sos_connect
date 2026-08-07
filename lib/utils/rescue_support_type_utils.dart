import 'package:get/get.dart';
import 'package:sos_connect/utils/sos_status_utils.dart';

enum RescueListType {
  yourRequests,
  receiving,
  received;

  String get title {
    switch (this) {
      case RescueListType.yourRequests:
        return 'your_support_requests'.tr;
      case RescueListType.receiving:
        return 'rescue_receiving'.tr;
      case RescueListType.received:
        return 'rescue_completed'.tr;
    }
  }

  bool get showSafeButton => this == RescueListType.yourRequests;

  String? get apiStatus {
    switch (this) {
      case RescueListType.receiving:
        return SosStatusUtils.inProgress;
      case RescueListType.received:
        return SosStatusUtils.complete;
      case RescueListType.yourRequests:
        return null;
    }
  }
}

