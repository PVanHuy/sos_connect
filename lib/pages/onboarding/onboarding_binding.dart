import 'package:get/get.dart';
import 'package:sos_connect/pages/onboarding/onboarding_controller.dart';

class OnboardingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}
