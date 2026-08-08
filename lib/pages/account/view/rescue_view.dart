import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/account/account_controller.dart';
import 'package:sos_connect/pages/account/widget/item_row_widget.dart';
import 'package:sos_connect/pages/rescue_completed/rescue_completed_parameter.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/rescue_support_type_utils.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class RescueView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding(horizontal: 16, top: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: appTheme.blackColor.withSafeOpacity(.1), blurRadius: 24, offset: Offset.zero)],
      ),
      child: Obx(() {
        final user = controller.dashboardController.userModel.value;
        final hasTeam = (user?.teamId ?? '').trim().isNotEmpty;
        final isLeader = (user?.roles ?? '').toLowerCase() == UserRoleUtils.leader;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: padding(all: 12),
              child: Text('rescue'.tr, style: StyleThemeData.size14Weight700()),
            ),
            ItemRowWidget(
              icon: Assets.icons.driver,
              label: hasTeam ? 'team_information_title'.tr : 'register_rescue_team'.tr,
              onTap: () => Get.toNamed(Routes.REGISTER_RESCUE_TEAM),
            ),
            ItemRowWidget(
              icon: Assets.icons.mindmapList,
              label: 'approved_rescue_teams'.tr,
              onTap: () => Get.toNamed(Routes.RESCUE_TEAM_LIST),
            ),
            ItemRowWidget(
              icon: Assets.icons.sendOther,
              label: isLeader ? 'join_team_request_list'.tr : 'my_join_team_request'.tr,
              badgeCount: isLeader ? controller.dashboardController.joinRequestCount.value : 0,
              onTap: () => Get.toNamed(Routes.JOIN_TEAM_REQUEST_LIST),
            ),
            ItemRowWidget(
              icon: Assets.icons.task,
              label: 'rescue_completed'.tr,
              isLast: true,
              onTap: () => Get.toNamed(
                Routes.RESCUE_COMPLETED,
                arguments: const RescueCompletedParameter(type: RescueListType.received),
              ),
            ),
          ],
        );
      }),
    );
  }
}
