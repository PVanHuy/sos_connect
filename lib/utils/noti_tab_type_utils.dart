import 'package:get/get.dart';
import 'package:sos_connect/utils/noti_type_utils.dart';

enum NotiTabType { app, system }

extension NotiTabTypeExtension on NotiTabType {
  String get title {
    switch (this) {
      case NotiTabType.system:
        return 'notification_tab_system'.tr;
      case NotiTabType.app:
        return 'notification_tab_app'.tr;
    }
  }

  String get emptyTitle {
    switch (this) {
      case NotiTabType.system:
        return 'notifications_system_empty_title'.tr;
      case NotiTabType.app:
        return 'notifications_app_empty_title'.tr;
    }
  }

  String get emptySubtitle {
    switch (this) {
      case NotiTabType.system:
        return 'notifications_system_empty_subtitle'.tr;
      case NotiTabType.app:
        return 'notifications_app_empty_subtitle'.tr;
    }
  }

  /// API query value: system = announcement, app = remaining types.
  String? get apiType {
    switch (this) {
      case NotiTabType.system:
        return NotiTypeUtils.announcement;
      case NotiTabType.app:
        return null;
    }
  }

  String? get apiExcludeType {
    switch (this) {
      case NotiTabType.system:
        return null;
      case NotiTabType.app:
        return NotiTypeUtils.announcement;
    }
  }

  static NotiTabType fromNotificationType(String? type) {
    if ((type ?? '').trim() == NotiTypeUtils.announcement) {
      return NotiTabType.system;
    }
    return NotiTabType.app;
  }

  bool matches(String? type) => fromNotificationType(type) == this;
}
