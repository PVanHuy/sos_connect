import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/otp/otp_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class OtpPage extends GetWidget<OtpController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: .translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const DefaultAppBar(isBackgroundIcon: true, isBackIconOther: true),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: padding(horizontal: 16),
          child: Column(
            children: [
              Padding(
                padding: padding(vertical: 12),
                child: Column(
                  spacing: 8.h,
                  crossAxisAlignment: .start,

                  children: [
                    Text('verify_otp'.tr, style: StyleThemeData.size30Weight700()),

                    Row(
                      spacing: 1.w,
                      children: [
                        Text('content_otp'.tr, style: StyleThemeData.size14Weight400()),

                        Expanded(
                          child: Text(
                            controller.parameter.phoneNumber,
                            overflow: .ellipsis,
                            style: StyleThemeData.size14Weight400(color: appTheme.appColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 52.h),
              _buildOtpInputWidget(),
              SizedBox(height: 24.h),
              Center(child: _buildResendWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInputWidget() {
    return Obx(() {
      final hasError = controller.otpError.value.isNotEmpty;
      final isOtpSuccess = controller.isOtpSuccess.value;
      final fillColor = hasError
          ? appTheme.redF4Color
          : isOtpSuccess
          ? appTheme.blueFAColor
          : appTheme.sliverColor;
      final borderColor = hasError
          ? appTheme.red26Color
          : isOtpSuccess
          ? appTheme.appColor
          : appTheme.grayE5Color;
      final focusBorderColor = hasError ? appTheme.red26Color : appTheme.appColor;

      return PinCodeTextField(
        controller: controller.otpTextController,
        autoDisposeControllers: false,
        appContext: Get.context!,
        length: AppConstants.maxOtpLength,
        onChanged: controller.updateVerificationCode,
        onCompleted: (value) {
          if (value.length == AppConstants.maxOtpLength) {
            controller.onConfirm();
          }
        },
        pinTheme: PinTheme(
          shape: .box,
          borderRadius: .circular(8),
          fieldHeight: 61.w,
          fieldWidth: 78.w,
          activeFillColor: fillColor,
          inactiveFillColor: fillColor,
          selectedFillColor: fillColor,
          activeColor: borderColor,
          inactiveColor: borderColor,
          selectedColor: focusBorderColor,
          borderWidth: 1.w,
          activeBorderWidth: 1.w,
          disabledBorderWidth: 1.w,
          selectedBorderWidth: 1.w,
          inactiveBorderWidth: 1.w,
          errorBorderWidth: 1.w,
        ),
        textStyle: StyleThemeData.size30Weight700(),
        keyboardType: .number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enableActiveFill: true,
        animationDuration: const Duration(milliseconds: 300),
        animationType: .fade,
        cursorColor: appTheme.appColor,
        obscureText: false,
        autovalidateMode: .disabled,
      );
    });
  }

  Widget _buildResendWidget() {
    return Obx(() {
      final hasError = controller.otpError.value.isNotEmpty;

      return Column(
        crossAxisAlignment: .center,
        children: [
          if (hasError) ...[
            Text(
              controller.otpError.value,
              style: StyleThemeData.size14Weight400(color: appTheme.errorColor),
              textAlign: .center,
            ),
            SizedBox(height: 8.h),
          ],
          Text('have_not_received_code'.tr, style: StyleThemeData.size14Weight400()),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: .center,
            children: [
              InkWell(
                onTap: controller.canResend.value ? controller.resendOtp : null,
                child: Text(
                  'resend'.tr,
                  style: StyleThemeData.size14Weight700(
                    color: controller.canResend.value ? appTheme.appColor : appTheme.gray8FColor,
                  ),
                ),
              ),
              if (!controller.canResend.value) ...[
                SizedBox(width: 4.w),
                Text(
                  '(${controller.countdown.value}s)',
                  style: StyleThemeData.size14Weight700(color: appTheme.appColor),
                ),
              ],
            ],
          ),
        ],
      );
    });
  }
}
