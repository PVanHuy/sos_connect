import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/pages/support/view/support_list_view.dart';
import 'package:sos_connect/pages/support/widget/sos_type_selector_widget.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SupportPage extends GetWidget<SupportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: padding(horizontal: 16, top: 8, bottom: 8),
          child: Column(
            children: [
              Text(
                'sos_emergency'.tr,
                textAlign: TextAlign.center,
                style: StyleThemeData.size24Weight700(color: appTheme.red38Color),
              ),
              SizedBox(height: 4.h),
              Text(
                'sos_emergency_desc'.tr,
                textAlign: TextAlign.center,
                style: StyleThemeData.size12Weight400(color: appTheme.gray83Color),
              ),
              SizedBox(height: 16.h),
              Obx(
                () =>
                    SosTypeSelectorWidget(selectedType: controller.selectedType.value, onSelect: controller.selectType),
              ),
              SizedBox(height: 16.h),
              const Expanded(child: SupportListView()),
              SizedBox(height: 12.h),
              CustomButton(
                buttonText: 'send_sos'.tr,
                hasSafeArea: false,
                gradient: AppGradient.redGradient,
                onPressed: () => Get.toNamed(Routes.SEND_SOS),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
