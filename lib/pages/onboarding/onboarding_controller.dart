import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sos_connect/routes/pages.dart';

enum OnboardingState { step1, step2, step3 }

class OnboardingController extends GetxController {
  final Rx<OnboardingState> onboardingState = OnboardingState.step1.obs;

  final PageController pageController = PageController();

  bool get isLastStep => onboardingState.value == OnboardingState.step3;

  String get titleKey => 'onboarding_title_${onboardingState.value.index + 1}';

  String get descKey => 'onboarding_desc_${onboardingState.value.index + 1}';

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

  void onContinue() {
    if (isLastStep) {
      skipOnboarding();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
