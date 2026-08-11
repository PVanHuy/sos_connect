import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/activity/activity_controller.dart';
import 'package:sos_connect/pages/activity/widget/item_activity_sos_widget.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/pages/sos_chat/sos_chat_parameter.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/utils/sos_status_utils.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/skeleton/rescue_posts_list_skeleton.dart';

class ReceivingActivityView extends GetView<ActivityController> {
  const ReceivingActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return LazyListView(
      controller: controller.receivingListController,
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
        final status = item.status ?? '';
        final canChat = sosId.isNotEmpty && (status.isSosInProgress || status.isSosComplete);
        final chatReadOnly = status.isSosComplete;
        final statusStyle = (item.status ?? SosStatusUtils.inProgress).sosStatusStyle;

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
          showChatButton: canChat,
          onChat: canChat
              ? () => Get.toNamed(
                  Routes.SOS_CHAT,
                  arguments: SosChatParameter(sosId: sosId, readOnly: chatReadOnly),
                )
              : null,
          onViewOnMap: () => MapController.openInAppRouteFromCoords(lat: item.lat, lon: item.lon),
        );
      },
    );
  }
}
