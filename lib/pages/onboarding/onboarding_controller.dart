import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/location_util.dart';
import 'package:sos_connect/widget/dialog/show_alert_dialog.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';

enum OnboardingState { step1, step2, step3 }

class OnboardingController extends GetxController {
  final Rx<OnboardingState> onboardingState = OnboardingState.step1.obs;
  final isRequestingPermission = false.obs;

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
    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> skipOnboarding() async {
    if (isRequestingPermission.value) return;

    try {
      isRequestingPermission.value = true;
      final status = await LocationUtil.ensurePermission();
      if (isClosed) return;

      if (status == LocationPermissionGateStatus.granted) {
        Get.offAllNamed(Routes.SIGN_IN);
        return;
      }

      _showLocationRequiredDialog(status);
    } finally {
      if (!isClosed) isRequestingPermission.value = false;
    }
  }

  void _showLocationRequiredDialog(LocationPermissionGateStatus status) {
    switch (status) {
      case LocationPermissionGateStatus.serviceDisabled:
        showConfirmDialog(
          title: 'location_required_title'.tr,
          content: 'location_service_disabled'.tr,
          titleBtn: 'settings'.tr,
          cancelBtnTitle: 'close'.tr,
          onConfirm: () => LocationUtil.openLocationSettings(),
        );
      case LocationPermissionGateStatus.deniedForever:
        showConfirmDialog(
          title: 'location_required_title'.tr,
          content: 'location_permission_denied_forever'.tr,
          titleBtn: 'settings'.tr,
          cancelBtnTitle: 'close'.tr,
          onConfirm: () => LocationUtil.openAppSettings(),
        );
      case LocationPermissionGateStatus.denied:
        showAlertDialog(title: 'location_required_title'.tr, content: 'location_required_content'.tr);
      case LocationPermissionGateStatus.granted:
        break;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
