import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:toastification/toastification.dart';

class DialogUtils {
  static void showSuccessDialog(String content) {
    toastification.show(
      context: Get.context!,
      title: Text(content, style: StyleThemeData.size14Weight600(color: appTheme.successColor), maxLines: 3),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.success,
      backgroundColor: appTheme.bgGreenColor,
      borderSide: BorderSide(width: 1.w, color: appTheme.greenColor),
      icon: Container(
        padding: padding(all: 4),
        decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.successColor),
        child: Icon(Icons.check, size: 16.w, color: appTheme.whiteColor),
      ),
    );
  }

  static void showErrorDialog(String content) {
    toastification.show(
      context: Get.context!,
      title: Text(content, maxLines: 3),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.error,
      icon: Icon(Icons.error, size: 24.w, color: appTheme.errorColor),
    );
  }

  static void showWarningDialog(String content) {
    toastification.show(
      context: Get.context!,
      title: Text(content, maxLines: 3),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.warning,
    );
  }
}
