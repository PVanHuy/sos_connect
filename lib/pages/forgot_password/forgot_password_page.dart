import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/forgot_password/forgot_password_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/formatter_util.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ForgotPasswordPage extends GetWidget<ForgotPasswordController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: .translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const DefaultAppBar(centerTitle: false, isBackIconOther: true),
        body: SingleChildScrollView(
          padding: padding(horizontal: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(height: 12.h),
              Text('${'forgot_password'.tr}?', style: StyleThemeData.size30Weight700()),
              SizedBox(height: 8.h),
              Text('desc_forgot_password'.tr, style: StyleThemeData.size12Weight400()),
              SizedBox(height: 87.h),
              CustomTextField(
                controller: controller.phoneController,
                titleText: 'phone_number'.tr,
                hintText: 'enter_phone_number'.tr,
                isPhone: true,
                inputType: TextInputType.phone,
                formatter: FormatterUtil.phoneFormatter,
                onValidateAsync: (value) async => await CustomValidator.validatePhone(value),
              ),
              Obx(
                () => CustomButton(
                  margin: padding(top: 24),
                  buttonText: 'continue'.tr,
                  onPressed: controller.isFormValid.value ? controller.onContinue : null,
                  isLoading: controller.isLoading.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
