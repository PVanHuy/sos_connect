import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

void showAlertDialog({required String title, String content = '', String titleBtn = '', VoidCallback? onConfirm}) {
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
            CustomButton(
              buttonText: titleBtn.isNotEmpty ? titleBtn : 'close'.tr,
              gradient: AppGradient.blueBFFAndAFFGradient,
              textColor: appTheme.whiteColor,
              onPressed: () {
                Get.back();
                onConfirm?.call();
              },
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
