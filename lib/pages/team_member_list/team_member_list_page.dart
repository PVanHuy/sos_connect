import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/team_member_list/team_member_list_controller.dart';
import 'package:sos_connect/pages/team_member_list/widget/item_team_member_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/skeleton/team_member_list_skeleton.dart';

class TeamMemberListPage extends GetWidget<TeamMemberListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: AppGradient.whiteAndBlueF4Gradient),
        child: Column(
          children: [
            Obx(
              () => DefaultAppBar(
                title: '${'team_members'.tr} (${controller.memberCountText})',
                titleStyle: StyleThemeData.size20Weight700(color: appTheme.whiteColor),
                backgroundColor: appTheme.transparentColor,
                backIconOther: true,
              ),
            ),
            Expanded(
              child: Obx(() {
                final kickingId = controller.kickingId.value;

                return LazyListView(
                  controller: controller.memberListController,
                  hasRefresh: true,
                  shrinkWrap: false,
                  callInit: true,
                  physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                  listPadding: padding(top: 12, horizontal: 12, bottom: 24),
                  emptyView: NoDataWidget(
                    isScroll: true,
                    title: 'team_members_empty_title'.tr,
                    description: 'team_members_empty_subtitle'.tr,
                  ),
                  skeletonView: () => TeamMemberListSkeleton(showKickButton: controller.isLeader),
                  divider: SizedBox(height: 12.h),
                  itemBuilder: (index, item) {
                    return ItemTeamMemberWidget(
                      member: item,
                      canKick: controller.canKick(item),
                      isKicking: kickingId == item.user?.id,
                      onKick: () => controller.onKick(item),
                      onTap: () => controller.onTapMember(item),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
