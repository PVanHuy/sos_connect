import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/onboarding/onboarding_controller.dart';
import 'package:sos_connect/pages/onboarding/widget/input_step_index_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/image_background_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/slide_action_button.dart';

class OnboardingPage extends GetWidget<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: .expand,
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: [
              ImageBgWidget(imagePath: Assets.images.onboarding1.path, child: const SizedBox.expand()),
              ImageBgWidget(imagePath: Assets.images.onboarding2.path, child: const SizedBox.expand()),
              ImageBgWidget(imagePath: Assets.images.onboarding3.path, child: const SizedBox.expand()),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: padding(horizontal: 16),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Obx(() {
                    if (controller.isLastStep) return const SizedBox.shrink();
                    return Align(
                      alignment: .topRight,
                      child: TextButton(
                        onPressed: controller.skipOnboarding,
                        child: Text('skip'.tr, style: StyleThemeData.size14Weight700()),
                      ),
                    );
                  }),
                  Expanded(
                    child: Align(
                      alignment: .bottomCenter,
                      child: SingleChildScrollView(
                        reverse: true,
                        physics: const ClampingScrollPhysics(),
                        child: Obx(() {
                          final isLastStep = controller.isLastStep;
                          return Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                controller.titleKey.tr,
                                style: StyleThemeData.size20Weight700(color: appTheme.whiteColor),
                              ),
                              Padding(
                                padding: padding(top: 4, bottom: 20),
                                child: Text(
                                  controller.descKey.tr,
                                  style: StyleThemeData.size14Weight400(color: appTheme.whiteColor),
                                ),
                              ),
                              InputStepIndexWidget(
                                count: OnboardingState.values.length,
                                currentIndex: controller.onboardingState.value.index,
                              ),
                              SlideActionButton(
                                text: isLastStep ? 'btn_start'.tr : 'btn_continue'.tr,
                                hasSafeArea: false,
                                margin: padding(top: 20, bottom: 24),
                                onCompleted: controller.onContinue,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
