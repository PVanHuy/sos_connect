import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

void showConfirmDialog({
  required String title,
  String content = '',
  String titleBtn = '',
  String cancelBtnTitle = '',
  VoidCallback? onConfirm,
  Color? colorBtn,
  Gradient? gradientBtn,
  Color? bgColorBtnBorder,
  Color? textColorBtnBorder,
  Color? grayE0Color,
}) {
  final confirmGradient = gradientBtn ?? (colorBtn == null ? AppGradient.blueBFFAndAFFGradient : null);
  final confirmColor = confirmGradient != null ? null : colorBtn ?? appTheme.appColor;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      backgroundColor: appTheme.whiteColor,
      insetPadding: padding(horizontal: 16),
      child: Container(
        padding: padding(vertical: 24, horizontal: 12),
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(title, style: StyleThemeData.size20Weight700(), textAlign: .center),
            SizedBox(height: 8.h),
            if (content.isNotEmpty)
              Center(
                child: Text(content, style: StyleThemeData.size12Weight400(), textAlign: .center),
              ),
            SizedBox(height: 24.h),
            Row(
              mainAxisSize: .min,
              spacing: 8.w,
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: cancelBtnTitle.isNotEmpty ? cancelBtnTitle : 'cancel'.tr,
                    color: appTheme.sliverColor,
                    textColor: textColorBtnBorder ?? appTheme.appColor,
                    onPressed: Get.back,
                  ),
                ),

                Expanded(
                  child: CustomButton(
                    buttonText: titleBtn.isNotEmpty ? titleBtn : 'confirm'.tr,
                    color: confirmColor,
                    gradient: confirmGradient,
                    textColor: appTheme.whiteColor,
                    onPressed: () {
                      Get.back();
                      onConfirm!();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
