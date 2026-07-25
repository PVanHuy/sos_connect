import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';

enum SosEmergencyType { needRescue, medical, food }

class SosEmergencyTypeStyle {
  const SosEmergencyTypeStyle({
    required this.background,
    required this.text,
    required this.border,
  });

  final Color background;
  final Color text;
  final Color border;
}

extension SosEmergencyTypeExtension on SosEmergencyType {
  String get title {
    switch (this) {
      case SosEmergencyType.needRescue:
        return 'support_type_need_rescue'.tr;
      case SosEmergencyType.medical:
        return 'support_type_medical_emergency'.tr;
      case SosEmergencyType.food:
        return 'support_type_food_water'.tr;
    }
  }

  String get iconPath {
    switch (this) {
      case SosEmergencyType.needRescue:
        return Assets.icons.warningOther.path;
      case SosEmergencyType.medical:
        return Assets.icons.flash.path;
      case SosEmergencyType.food:
        return Assets.icons.wallet.path;
    }
  }

  SosEmergencyTypeStyle get style {
    switch (this) {
      case SosEmergencyType.needRescue:
        return SosEmergencyTypeStyle(
          background: appTheme.greenECColor,
          text: appTheme.green47Color,
          border: appTheme.green47Color,
        );
      case SosEmergencyType.medical:
        return SosEmergencyTypeStyle(
          background: appTheme.pinkE5Color,
          text: appTheme.red38Color,
          border: appTheme.red38Color,
        );
      case SosEmergencyType.food:
        return SosEmergencyTypeStyle(
          background: appTheme.lavenderColor,
          text: appTheme.appColor,
          border: appTheme.appColor,
        );
    }
  }
}
