import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';

enum SurvivalGuideCategory { firstAid, naturalDisaster }

class SurvivalGuideCategoryStyle {
  const SurvivalGuideCategoryStyle({
    required this.background,
    required this.text,
    required this.border,
  });

  final Color background;
  final Color text;
  final Color border;
}

extension SurvivalGuideCategoryExtension on SurvivalGuideCategory {
  String get title {
    switch (this) {
      case SurvivalGuideCategory.firstAid:
        return 'survival_first_aid'.tr;
      case SurvivalGuideCategory.naturalDisaster:
        return 'survival_natural_disaster'.tr;
    }
  }

  String get iconPath {
    switch (this) {
      case SurvivalGuideCategory.firstAid:
        return Assets.icons.flash.path;
      case SurvivalGuideCategory.naturalDisaster:
        return Assets.icons.warningOther.path;
    }
  }

  SurvivalGuideCategoryStyle get style {
    switch (this) {
      case SurvivalGuideCategory.firstAid:
        return SurvivalGuideCategoryStyle(
          background: appTheme.pinkE5Color,
          text: appTheme.red38Color,
          border: appTheme.red38Color,
        );
      case SurvivalGuideCategory.naturalDisaster:
        return SurvivalGuideCategoryStyle(
          background: appTheme.lavenderColor,
          text: appTheme.appColor,
          border: appTheme.appColor,
        );
    }
  }
}

class SurvivalGuideModel {
  const SurvivalGuideModel({
    required this.id,
    required this.category,
    required this.titleKey,
    required this.summaryKey,
    required this.stepKeys,
  });

  final String id;
  final SurvivalGuideCategory category;
  final String titleKey;
  final String summaryKey;
  final List<String> stepKeys;

  String get title => titleKey.tr;

  String get summary => summaryKey.tr;

  List<String> get steps => stepKeys.map((key) => key.tr).toList();
}

class SurvivalGuideData {
  SurvivalGuideData._();

  static const List<SurvivalGuideModel> guides = [
    SurvivalGuideModel(
      id: 'cpr',
      category: SurvivalGuideCategory.firstAid,
      titleKey: 'survival_cpr_title',
      summaryKey: 'survival_cpr_summary',
      stepKeys: [
        'survival_cpr_step_1',
        'survival_cpr_step_2',
        'survival_cpr_step_3',
        'survival_cpr_step_4',
        'survival_cpr_step_5',
        'survival_cpr_step_6',
      ],
    ),
    SurvivalGuideModel(
      id: 'stroke',
      category: SurvivalGuideCategory.firstAid,
      titleKey: 'survival_stroke_title',
      summaryKey: 'survival_stroke_summary',
      stepKeys: [
        'survival_stroke_step_1',
        'survival_stroke_step_2',
        'survival_stroke_step_3',
        'survival_stroke_step_4',
        'survival_stroke_step_5',
      ],
    ),
    SurvivalGuideModel(
      id: 'drowning',
      category: SurvivalGuideCategory.firstAid,
      titleKey: 'survival_drowning_title',
      summaryKey: 'survival_drowning_summary',
      stepKeys: [
        'survival_drowning_step_1',
        'survival_drowning_step_2',
        'survival_drowning_step_3',
        'survival_drowning_step_4',
        'survival_drowning_step_5',
      ],
    ),
    SurvivalGuideModel(
      id: 'flood',
      category: SurvivalGuideCategory.naturalDisaster,
      titleKey: 'survival_flood_title',
      summaryKey: 'survival_flood_summary',
      stepKeys: [
        'survival_flood_step_1',
        'survival_flood_step_2',
        'survival_flood_step_3',
        'survival_flood_step_4',
        'survival_flood_step_5',
      ],
    ),
    SurvivalGuideModel(
      id: 'landslide',
      category: SurvivalGuideCategory.naturalDisaster,
      titleKey: 'survival_landslide_title',
      summaryKey: 'survival_landslide_summary',
      stepKeys: [
        'survival_landslide_step_1',
        'survival_landslide_step_2',
        'survival_landslide_step_3',
        'survival_landslide_step_4',
        'survival_landslide_step_5',
      ],
    ),
    SurvivalGuideModel(
      id: 'storm',
      category: SurvivalGuideCategory.naturalDisaster,
      titleKey: 'survival_storm_title',
      summaryKey: 'survival_storm_summary',
      stepKeys: [
        'survival_storm_step_1',
        'survival_storm_step_2',
        'survival_storm_step_3',
        'survival_storm_step_4',
        'survival_storm_step_5',
      ],
    ),
  ];

  static List<SurvivalGuideModel> byCategory(SurvivalGuideCategory category) {
    return guides.where((guide) => guide.category == category).toList();
  }

  static SurvivalGuideModel? findById(String id) {
    for (final guide in guides) {
      if (guide.id == id) return guide;
    }
    return null;
  }
}
