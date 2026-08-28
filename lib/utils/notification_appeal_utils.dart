import 'package:sos_connect/model/notification/notification_model.dart';
import 'package:sos_connect/utils/appeal_target_type_utils.dart';
import 'package:sos_connect/utils/noti_type_utils.dart';

class NotificationAppealUtils {
  static bool canAppeal({String? type, String? action}) {
    final notiType = (type ?? '').trim();
    final notiAction = (action ?? '').trim();

    if (notiType == NotiTypeUtils.teamRegistration && notiAction == NotiActionUtils.rejected) return true;
    if (notiType == NotiTypeUtils.teamMembership && notiAction == NotiActionUtils.deleted) return true;
    if (notiType == NotiTypeUtils.sosRequest && notiAction == NotiActionUtils.rejected) return true;
    return false;
  }

  static String? targetTypeOf({String? type, String? action}) {
    final notiType = (type ?? '').trim();
    final notiAction = (action ?? '').trim();

    if (notiType == NotiTypeUtils.teamRegistration && notiAction == NotiActionUtils.rejected) {
      return AppealTargetTypeUtils.teamRegistration;
    }
    if (notiType == NotiTypeUtils.teamMembership && notiAction == NotiActionUtils.deleted) {
      return AppealTargetTypeUtils.teamDeletion;
    }
    if (notiType == NotiTypeUtils.sosRequest && notiAction == NotiActionUtils.rejected) {
      return AppealTargetTypeUtils.sosRejection;
    }
    return null;
  }

  static String? targetIdOf(NotificationModel notification) {
    final targetType = targetTypeOf(type: notification.type, action: notification.action);
    if (targetType == AppealTargetTypeUtils.sosRejection) {
      final sosId = notification.data?.sosId?.trim() ?? '';
      if (sosId.isNotEmpty) return sosId;
    }

    final teamId = notification.data?.teamId?.trim() ?? '';
    if (teamId.isNotEmpty) return teamId;

    final requestId = notification.requestId?.trim() ?? '';
    return requestId.isNotEmpty ? requestId : null;
  }

  static String? reasonOf(NotificationModel notification) {
    final fromData = notification.data?.reason?.trim() ?? '';
    return fromData.isNotEmpty ? fromData : null;
  }
}
