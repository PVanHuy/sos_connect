import 'dart:ui';

import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';

extension LanguageExtension on Languages {
  String get title {
    switch (this) {
      case Languages.vi:
        return 'vietnamese'.tr;
      case Languages.en:
        return 'english'.tr;
    }
  }

  Locale get locale {
    switch (this) {
      case Languages.vi:
        return const Locale('vi', 'VN');
      case Languages.en:
        return const Locale('en', 'US');
    }
  }

  String get flagAsset {
    switch (this) {
      case Languages.vi:
        return Assets.icons.vietnam.path;
      case Languages.en:
        return Assets.icons.england.path;
    }
  }
}

enum Languages { vi, en }

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

extension WeekDayX on WeekDay {
  String get shortTitle {
    switch (this) {
      case WeekDay.monday:
        return 'short_mon'.tr;
      case WeekDay.tuesday:
        return 'short_tue'.tr;
      case WeekDay.wednesday:
        return 'short_wed'.tr;
      case WeekDay.thursday:
        return 'short_thu'.tr;
      case WeekDay.friday:
        return 'short_fri'.tr;
      case WeekDay.saturday:
        return 'short_sat'.tr;
      case WeekDay.sunday:
        return 'short_sun'.tr;
    }
  }

  String get title {
    switch (this) {
      case WeekDay.monday:
        return 'monday'.tr;
      case WeekDay.tuesday:
        return 'tuesday'.tr;
      case WeekDay.wednesday:
        return 'wednesday'.tr;
      case WeekDay.thursday:
        return 'thursday'.tr;
      case WeekDay.friday:
        return 'friday'.tr;
      case WeekDay.saturday:
        return 'saturday'.tr;
      case WeekDay.sunday:
        return 'sunday'.tr;
    }
  }
}
