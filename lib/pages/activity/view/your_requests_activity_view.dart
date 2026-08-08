import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/activity/activity_controller.dart';
import 'package:sos_connect/pages/activity/widget/item_activity_sos_widget.dart';
import 'package:sos_connect/pages/sos_chat/sos_chat_parameter.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/utils/sos_status_utils.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/skeleton/rescue_posts_list_skeleton.dart';

class YourRequestsActivityView extends GetView<ActivityController> {
  const YourRequestsActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return LazyListView(
      controller: controller.yourRequestsListController,
      callInit: true,
      hasRefresh: true,
      shrinkWrap: false,
      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
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
        final sosId = item.id?.trim() ?? '';
        final canChat = sosId.isNotEmpty && (item.status ?? '').isSosInProgress;
        final canSafe = item.canMarkAsSafe;
        final statusStyle = (item.status ?? SosStatusUtils.inProgress).sosStatusStyle;

        return Obx(() {
          final isMarking = controller.markingSafeId.value == item.id;
          return ItemActivitySosWidget(
            imageUrl: item.image ?? '',
            supportType: type.title,
            supportTypeColor: type.style.text,
            supportTypeBgColor: type.style.background,
            remainingTime: item.statusLabel,
            statusTextColor: statusStyle.text,
            statusBgColor: statusStyle.background,
            description: item.description ?? '',
            address: item.addressText ?? '',
            phone: item.phone ?? '',
            teamName: team?.name ?? '',
            managerName: team?.leader ?? '',
            managerPhone: team?.phone ?? '',
            showSafeButton: canSafe,
            isMarkingSafe: isMarking,
            onMarkAsSafe: canSafe ? () => controller.markAsSafe(item) : null,
            showChatButton: canChat,
            onChat: canChat
                ? () => Get.toNamed(Routes.SOS_CHAT, arguments: SosChatParameter(sosId: sosId))
                : null,
          );
        });
      },
    );
  }
}
