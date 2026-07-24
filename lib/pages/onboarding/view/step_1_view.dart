import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/onboarding/onboarding_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class Step1View extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.onboardingStep1.image(width: .infinity, fit: .cover),
        Expanded(
          child: Padding(
            padding: padding(horizontal: 16, vertical: 28),
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                Text('onboarding_title_1'.tr, style: StyleThemeData.size20Weight700(color: appTheme.whiteColor)),
                SizedBox(height: 4.h),
                Text('onboarding_desc_1'.tr, style: StyleThemeData.size14Weight400(color: appTheme.whiteColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
