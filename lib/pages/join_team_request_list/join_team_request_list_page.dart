import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/join_team_request_list/join_team_request_list_controller.dart';
import 'package:sos_connect/pages/join_team_request_list/view/user_request_team_view.dart';
import 'package:sos_connect/pages/join_team_request_list/widget/item_join_team_request_widget.dart';
import 'package:sos_connect/utils/join_team_request_status_utils.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/skeleton/join_team_request_list_skeleton.dart';

class JoinTeamRequestListPage extends GetWidget<JoinTeamRequestListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.sliverColor,
      appBar: DefaultAppBar(
        title: controller.isLeader ? 'join_team_request_list'.tr : 'my_join_team_request'.tr,
        backIconOther: true,
      ),
      body: controller.isLeader ? _buildLeaderView() : const UserRequestTeamView(),
    );
  }

  Widget _buildLeaderView() {
    return Obx(() {
      final acceptingId = controller.acceptingId.value;
      final rejectingId = controller.rejectingId.value;

      return LazyListView(
        controller: controller.requestListController,
        hasRefresh: true,
        shrinkWrap: false,
        callInit: true,
        physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
        listPadding: padding(top: 12, horizontal: 12, bottom: 24),
        emptyView: NoDataWidget(
          isScroll: true,
          title: 'join_team_request_empty_title'.tr,
          description: 'join_team_request_empty_subtitle'.tr,
        ),
        skeletonView: () => const JoinTeamRequestListSkeleton(),
        divider: SizedBox(height: 12.h),
        itemBuilder: (index, item) {
          return ItemJoinTeamRequestWidget(
            request: item,
            isAccepting: acceptingId == item.id,
            isRejecting: rejectingId == item.id,
            onAccept: () => controller.onRespond(item, status: JoinTeamRequestStatusUtils.accepted),
            onReject: () => controller.onRespond(item, status: JoinTeamRequestStatusUtils.rejected),
          );
        },
      );
    });
  }
}
