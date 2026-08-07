import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/rescue_posts/rescue_posts_controller.dart';
import 'package:sos_connect/pages/rescue_posts/widget/item_rescue_post_widget.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/skeleton/rescue_posts_list_skeleton.dart';

class RescuePostsPage extends GetWidget<RescuePostsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.sliverColor,
      appBar: DefaultAppBar(title: controller.listType.title, backIconOther: true),
      body: LazyListView(
        controller: controller.postsController,
        callInit: true,
        hasRefresh: true,
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        listPadding: padding(horizontal: 16, top: 8, bottom: 24),
        emptyView: NoDataWidget(
          isScroll: true,
          title: 'sos_list_empty_title'.tr,
          description: 'sos_list_empty_subtitle'.tr,
        ),
        skeletonView: () => const RescuePostsListSkeleton(),
        divider: SizedBox(height: 12.h),
        itemBuilder: (index, item) {
          final type = item.emergencyType;
          final team = item.teamRescue;
          final showSafeButton = controller.listType.showSafeButton && item.canMarkAsSafe;

          return Obx(() {
            final isMarking = controller.markingSafeId.value == item.id;
            return ItemRescuePostWidget(
              imageUrl: item.image ?? '',
              supportType: type.title,
              supportTypeColor: type.style.text,
              supportTypeBgColor: type.style.background,
              time: controller.formatTime(item.createdAt),
              remainingTime: controller.statusLabel(item),
              description: item.description ?? '',
              address: item.addressText ?? '',
              phone: item.phone ?? '',
              teamName: team?.name ?? '',
              managerName: team?.leader ?? '',
              managerPhone: team?.phone ?? '',
              showSafeButton: showSafeButton,
              isMarkingSafe: isMarking,
              onMarkAsSafe: showSafeButton ? () => controller.markAsSafe(item) : null,
            );
          });
        },
      ),
    );
  }
}
