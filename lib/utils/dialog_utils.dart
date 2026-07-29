import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/resourese/service/localization_service.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/app_enums.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:toastification/toastification.dart';

class DialogUtils {
  static String resolveMessage(dynamic message, {String fallback = ''}) {
    if (message == null) return fallback;
    if (message is String) return message.isNotEmpty ? message : fallback;
    if (message is Map) {
      final langKey = LocalizationService.language == Languages.en ? 'en' : 'vi';
      final localized = message[langKey]?.toString();
      if (localized != null && localized.isNotEmpty) return localized;
      final vi = message['vi']?.toString();
      if (vi != null && vi.isNotEmpty) return vi;
      final en = message['en']?.toString();
      if (en != null && en.isNotEmpty) return en;
    }
    return fallback;
  }

  static void showSuccessDialog(dynamic content) {
    final text = resolveMessage(content);
    if (text.isEmpty) return;

    toastification.show(
      context: Get.context!,
      title: Text(text, style: StyleThemeData.size14Weight600(color: appTheme.successColor), maxLines: 3),
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

  static void showErrorDialog(dynamic content) {
    final text = resolveMessage(content);
    if (text.isEmpty) return;

    toastification.show(
      context: Get.context!,
      title: Text(text, maxLines: 3),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.error,
      icon: Icon(Icons.error, size: 24.w, color: appTheme.errorColor),
    );
  }

  static void showWarningDialog(dynamic content) {
    final text = resolveMessage(content);
    if (text.isEmpty) return;

    toastification.show(
      context: Get.context!,
      title: Text(text, maxLines: 3),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.warning,
    );
  }
}
