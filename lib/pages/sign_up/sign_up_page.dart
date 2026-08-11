import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/sign_up/sign_up_controller.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/formatter_util.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/image_background_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SignUpPage extends GetWidget<SignUpController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    width: .infinity,
                    padding: padding(horizontal: 20, top: 12, bottom: 24),
                    decoration: BoxDecoration(
                      color: appTheme.whiteColor,
                      borderRadius: .circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: appTheme.blackColor.withSafeOpacity(0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        Text('sign_up'.tr, textAlign: .center, style: StyleThemeData.size24Weight700()),
                        SizedBox(height: 8.h),
                        Text(
                          'sign_up_description'.tr,
                          textAlign: .center,
                          style: StyleThemeData.size12Weight400(color: appTheme.black53Color, height: 1.4),
                        ),
                        SizedBox(height: 24.h),
                        CustomTextField(
                          controller: controller.phoneController,
                          titleText: 'phone_number'.tr,
                          hintText: 'enter_phone_number'.tr,
                          inputType: .phone,
                          formatter: FormatterUtil.phoneFormatter,
                          borderRadius: 12,
                          showFocusBorder: true,
                          isPhone: true,
                          prefixIcon: Padding(
                            padding: padding(left: 12, right: 8),
                            child: Assets.icons.callBold.svg(
                              width: 20.w,
                              height: 20.w,
                              colorFilter: .mode(appTheme.appColor, .srcIn),
                            ),
                          ),
                          onValidateAsync: (value) async => CustomValidator.validatePhone(value),
                        ),
                        SizedBox(height: 16.h),
                        Column(
                          crossAxisAlignment: .start,
                          spacing: 12.h,
                          children: [
                            CustomTextField(
                              controller: controller.passwordController,
                              titleText: 'password'.tr,
                              hintText: 'enter_password'.tr,
                              isPassword: true,
                              formatter: FormatterUtil.passwordFormatter,
                              borderRadius: 12,
                              showFocusBorder: true,
                              prefixIcon: Padding(
                                padding: padding(left: 12, right: 8),
                                child: Assets.icons.lock.svg(
                                  width: 20.w,
                                  height: 20.w,
                                  colorFilter: .mode(appTheme.appColor, .srcIn),
                                ),
                              ),
                            ),
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
                          controller: controller.userNameController,
                          titleText: 'user_name'.tr,
                          hintText: 'enter_user_name'.tr,
                          inputAction: .done,
                          formatter: FormatterUtil.fullNameFormatter,
                          borderRadius: 12,
                          showFocusBorder: true,
                          prefixIcon: Padding(
                            padding: padding(left: 12, right: 8),
                            child: Assets.icons.user.svg(
                              width: 20.w,
                              height: 20.w,
                              colorFilter: .mode(appTheme.appColor, .srcIn),
                            ),
                          ),
                          onValidate: CustomValidator.validateUserName,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: controller.provinceController,
                          titleText: 'province_city'.tr,
                          hintText: 'select_province_city'.tr,
                          borderRadius: 12,
                          showFocusBorder: true,
                          readOnly: true,
                          onTap: controller.selectProvince,
                          prefixIcon: Padding(
                            padding: padding(left: 12, right: 8),
                            child: Assets.icons.location.svg(width: 20.w, height: 20.w),
                          ),
                          suffixIcon: IconButton(
                            onPressed: controller.selectProvince,
                            icon: Assets.icons.arrowDown.svg(width: 18.w, height: 18.w),
                          ),
                          onValidate: (value) =>
                              CustomValidator.validateRequiredField(value.trim(), 'province_city'.tr),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            Text('already_have_account'.tr, style: StyleThemeData.size12Weight400()),
                            SizedBox(width: 4.w),
                            InkWell(
                              onTap: () => Get.offNamed(Routes.SIGN_IN),
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
                            buttonText: 'sign_up'.tr,
                            onPressed: controller.isFormValid.value ? controller.onSignUp : null,
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
    );
  }
}
