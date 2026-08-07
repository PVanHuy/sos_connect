import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/model/notification/notification_model.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/noti/widget/item_noti_widget.dart';
import 'package:sos_connect/utils/noti_tab_type_utils.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/skeleton/noti_skeleton.dart';

class AppNotiView extends GetView<NotiController> {
  const AppNotiView({super.key});

  @override
  Widget build(BuildContext context) {
    return LazyListView<NotificationModel>(
      controller: controller.appListController,
      hasRefresh: true,
      shrinkWrap: false,
      callInit: true,
      listPadding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      emptyView: NoDataWidget(
        isScroll: true,
        title: NotiTabType.app.emptyTitle,
        description: NotiTabType.app.emptySubtitle,
      ),
      skeletonView: () => const NotiSkeletonView(),
      itemBuilder: (index, notification) {
        return ItemNotiWidget(
          title: notification.title ?? '',
          time: notification.createdAt.toddMMyyyyHHmm,
          content: notification.content ?? '',
          isRead: notification.isRead,
          onTap: () => controller.handleNotificationTap(notification),
        );
      },
    );
  }
}
