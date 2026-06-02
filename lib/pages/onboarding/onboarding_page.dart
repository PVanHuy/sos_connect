import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/onboarding/onboarding_controller.dart';
import 'package:sos_connect/pages/onboarding/view/step_1_view.dart';
import 'package:sos_connect/pages/onboarding/view/step_2_view.dart';
import 'package:sos_connect/pages/onboarding/view/step_3_view.dart';
import 'package:sos_connect/pages/onboarding/widget/input_step_index_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/slide_action_button.dart';

class OnboardingPage extends GetWidget<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.appColor,
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) => controller.onPageChanged(index),
        children: [Step1View(), Step2View(), Step3View()],
      ),
      bottomNavigationBar: Obx(() {
        final isLastStep = controller.onboardingState.value == OnboardingState.step3;
        return Column(
          mainAxisSize: .min,
          children: [
            SizedBox(height: 42.h),
            InputStepIndexWidget(
              count: OnboardingState.values.length,
              currentIndex: controller.onboardingState.value.index,
            ),
            SizedBox(height: 24.h),
            SlideActionButton(
              text: isLastStep ? 'btn_start'.tr : 'btn_continue'.tr,
              margin: padding(horizontal: 16, bottom: 24, top: 12),

              onCompleted: () => controller.onPageChanged(controller.onboardingState.value.index + 1),
            ),
          ],
        );
      }),
    );
  }
}
