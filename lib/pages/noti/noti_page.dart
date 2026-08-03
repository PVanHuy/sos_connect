import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/notification/notification_model.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/noti/widget/item_noti_widget.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/skeleton/noti_skeleton.dart';

class NotiPage extends GetWidget<NotiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: DefaultAppBar(title: 'notifications'.tr, backButton: false),
      body: LazyListView<NotificationModel>(
        controller: controller.notificationListController,
        hasRefresh: true,
        shrinkWrap: false,
        callInit: true,
        listPadding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        emptyView: NoDataWidget(
          isScroll: true,
          title: 'notifications_empty_title'.tr,
          description: 'notifications_empty_subtitle'.tr,
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
      ),
    );
  }
}
