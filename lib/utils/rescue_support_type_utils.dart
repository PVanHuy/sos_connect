import 'package:get/get.dart';

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
        return 'rescue_received'.tr;
    }
  }

  bool get showSafeButton => this == RescueListType.yourRequests;
}
