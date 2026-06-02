import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sos_connect/routes/pages.dart';

enum OnboardingState { step1, step2, step3 }

class OnboardingController extends GetxController {
  final Rx<OnboardingState> onboardingState = OnboardingState.step1.obs;

  final PageController pageController = PageController();

  void onPageChanged(int index) {
    switch (index) {
      case 0:
        onboardingState.value = OnboardingState.step1;
        break;
      case 1:
        onboardingState.value = OnboardingState.step2;
        break;
      case 2:
        onboardingState.value = OnboardingState.step3;
        break;
    }
  }

  void skipOnboarding() {
    Get.offAllNamed(Routes.SIGN_IN);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
