import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';

enum SosEmergencyType { needRescue, medical, food, other }

class SosEmergencyTypeStyle {
  const SosEmergencyTypeStyle({required this.background, required this.text, required this.border});

  final Color background;
  final Color text;
  final Color border;
}

extension SosEmergencyTypeExtension on SosEmergencyType {
  static const List<SosEmergencyType> selectableTypes = [
    SosEmergencyType.needRescue,
    SosEmergencyType.medical,
    SosEmergencyType.food,
  ];

  static const String apiHelp = 'HELP';
  static const String apiEssential = 'ESSENTIAL';
  static const String apiFood = 'FOOD';
  static const String apiTowing = 'TOWING';
  static const String apiOther = 'OTHER';

  String get title {
    switch (this) {
      case SosEmergencyType.needRescue:
        return 'support_type_need_rescue'.tr;
      case SosEmergencyType.medical:
        return 'support_type_medical_emergency'.tr;
      case SosEmergencyType.food:
        return 'support_type_food_water'.tr;
      case SosEmergencyType.other:
        return 'support_type_other'.tr;
    }
  }

  String get iconPath {
    switch (this) {
      case SosEmergencyType.needRescue:
        return Assets.icons.seedling.path;
      case SosEmergencyType.medical:
        return Assets.icons.flash.path;
      case SosEmergencyType.food:
        return Assets.icons.food.path;
      case SosEmergencyType.other:
        return Assets.icons.warningOther.path;
    }
  }

  String get apiType {
    switch (this) {
      case SosEmergencyType.needRescue:
        return apiHelp;
      case SosEmergencyType.medical:
        return apiEssential;
      case SosEmergencyType.food:
        return apiFood;
      case SosEmergencyType.other:
        return apiOther;
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
      case SosEmergencyType.other:
        return SosEmergencyTypeStyle(
          background: appTheme.grayE5Color,
          text: appTheme.gray83Color,
          border: appTheme.gray83Color,
        );
    }
  }

  static SosEmergencyType fromApi(String? type) {
    switch ((type ?? '').toUpperCase()) {
      case apiHelp:
        return SosEmergencyType.needRescue;
      case apiEssential:
        return SosEmergencyType.medical;
      case apiFood:
      case apiTowing:
        return SosEmergencyType.food;
      case apiOther:
        return SosEmergencyType.other;
      default:
        return SosEmergencyType.other;
    }
  }
}
