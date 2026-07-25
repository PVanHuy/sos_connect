import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/change_password/change_password_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/formatter_util.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ChangePasswordPage extends GetWidget<ChangePasswordController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: .translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: AppGradient.whiteAndBlueF4Gradient),
          child: SafeArea(
            child: Column(
              children: [
                const DefaultAppBar(centerTitle: false, backgroundColor: Colors.transparent, backIconOther: true),
                Expanded(
                  child: SingleChildScrollView(
                    padding: padding(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        SizedBox(height: 12.h),
                        Text('change_password'.tr, style: StyleThemeData.size30Weight700()),
                        SizedBox(height: 8.h),
                        Text('desc_change_password'.tr, style: StyleThemeData.size12Weight400()),
                        SizedBox(height: 48.h),
                        CustomTextField(
                          controller: controller.currentPasswordController,
                          titleText: 'current_password'.tr,
                          hintText: 'enter_current_password'.tr,
                          isPassword: true,
                          borderRadius: 12,
                          formatter: FormatterUtil.passwordFormatter,
                          prefixIcon: Padding(
                            padding: padding(left: 12, right: 8),
                            child: Assets.icons.lock.svg(
                              width: 20.w,
                              height: 20.w,
                              colorFilter: .mode(appTheme.appColor, .srcIn),
                            ),
                          ),
                          onValidate: (value) => CustomValidator.validateRequiredField(value, 'current_password'.tr),
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: controller.passwordController,
                          titleText: 'new_password'.tr,
                          hintText: 'enter_new_password'.tr,
                          isPassword: true,
                          borderRadius: 12,
                          formatter: FormatterUtil.passwordFormatter,
                          prefixIcon: Padding(
                            padding: padding(left: 12, right: 8),
                            child: Assets.icons.lock.svg(
                              width: 20.w,
                              height: 20.w,
                              colorFilter: .mode(appTheme.appColor, .srcIn),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Obx(
                          () => Text(
                            'desc_password_rule'.tr,
                            style: StyleThemeData.size12Weight400(
                              color: !controller.isPasswordTouched.value || controller.isPasswordRuleValid.value
                                  ? appTheme.blackColor
                                  : appTheme.appColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: controller.confirmPasswordController,
                          titleText: 'confirm_new_password'.tr,
                          hintText: 'enter_confirm_new_password'.tr,
                          isPassword: true,
                          borderRadius: 12,
                          formatter: FormatterUtil.passwordFormatter,
                          prefixIcon: Padding(
                            padding: padding(left: 12, right: 8),
                            child: Assets.icons.lock.svg(
                              width: 20.w,
                              height: 20.w,
                              colorFilter: .mode(appTheme.appColor, .srcIn),
                            ),
                          ),
                          onValidate: (value) {
                            final requiredMessage = CustomValidator.validateRequiredField(
                              value.trim(),
                              'confirm_new_password'.tr,
                            );
                            if (requiredMessage.isNotEmpty) return requiredMessage;
                            if (value.trim() != controller.passwordController.text.trim()) {
                              return 'wrong_password'.tr;
                            }
                            return '';
                          },
                        ),
                        Obx(
                          () => CustomButton(
                            margin: padding(top: 24, bottom: 24),
                            buttonText: 'confirm'.tr,
                            onPressed: controller.isFormValid.value ? controller.onConfirm : null,
                            isLoading: controller.isLoading.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
