import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/create_new_password/create_new_password_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/formatter_util.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/image_background_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class CreateNewPasswordPage extends GetWidget<CreateNewPasswordController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ImageBgWidget(
          child: SafeArea(
            top: false,
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: padding(horizontal: 20, bottom: 24),
                child: Column(
                  children: [
                    Assets.images.logoApp.logoText.image(width: 200.w, height: 100.w),
                    SizedBox(height: 24.h),
                    Container(
                      width: double.infinity,
                      padding: padding(horizontal: 20, top: 12, bottom: 24),
                      decoration: BoxDecoration(
                        color: appTheme.whiteColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: appTheme.blackColor.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'create_new_password'.tr,
                            textAlign: TextAlign.center,
                            style: StyleThemeData.size24Weight700(),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'create_new_password_description'.tr,
                            textAlign: TextAlign.center,
                            style: StyleThemeData.size12Weight400(color: appTheme.black53Color, height: 1.4),
                          ),
                          SizedBox(height: 24.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                controller: controller.passwordController,
                                titleText: 'new_password'.tr,
                                hintText: 'enter_new_password'.tr,
                                isPassword: true,
                                formatter: FormatterUtil.passwordFormatter,
                                borderRadius: 12,
                                showFocusBorder: true,
                                prefixIcon: Padding(
                                  padding: padding(left: 12, right: 8),
                                  child: Assets.icons.lock.svg(
                                    width: 20.w,
                                    height: 20.w,
                                    colorFilter: .mode(appTheme.appColor, BlendMode.srcIn),
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
                                        : appTheme.errorColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          CustomTextField(
                            controller: controller.confirmPasswordController,
                            titleText: 'confirm_new_password'.tr,
                            hintText: 'enter_confirm_new_password'.tr,
                            isPassword: true,
                            inputAction: TextInputAction.done,
                            formatter: FormatterUtil.passwordFormatter,
                            borderRadius: 12,
                            showFocusBorder: true,
                            prefixIcon: Padding(
                              padding: padding(left: 12, right: 8),
                              child: Assets.icons.lock.svg(
                                width: 20.w,
                                height: 20.w,
                                colorFilter: .mode(appTheme.appColor, BlendMode.srcIn),
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
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('already_have_account'.tr, style: StyleThemeData.size12Weight400()),
                              SizedBox(width: 4.w),
                              InkWell(
                                onTap: controller.goToSignIn,
                                child: Text(
                                  'sign_in'.tr,
                                  style: StyleThemeData.size12Weight400(color: appTheme.appColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Obx(
                            () => CustomButton(
                              buttonText: 'confirm'.tr,
                              onPressed: controller.isFormValid.value ? controller.onConfirm : null,
                              isLoading: controller.isLoading.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
