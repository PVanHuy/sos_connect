import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/team/current_join_team_request_model.dart';
import 'package:sos_connect/pages/join_request_detail/join_request_detail_parameter.dart';
import 'package:sos_connect/pages/join_team_request_list/join_team_request_list_controller.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/join_team_request_status_utils.dart';
import 'package:sos_connect/widget/item_border_widget.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/skeleton/join_team_request_list_skeleton.dart';

class UserRequestTeamView extends GetView<JoinTeamRequestListController> {
  const UserRequestTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return LazyListView<CurrentJoinTeamRequestModel>(
      controller: controller.myRequestListController,
      hasRefresh: true,
      shrinkWrap: false,
      callInit: true,
      physics: const AlwaysScrollableScrollPhysics(),
      listPadding: padding(top: 12, horizontal: 12, bottom: 24),
      emptyView: NoDataWidget(
        isScroll: true,
        title: 'my_join_team_request_empty_title'.tr,
        description: 'my_join_team_request_empty_subtitle'.tr,
      ),
      skeletonView: () => const JoinTeamRequestListSkeleton(),
      divider: SizedBox(height: 12.h),
      itemBuilder: (index, request) => _buildRequestItem(request),
    );
  }

  Widget _buildRequestItem(CurrentJoinTeamRequestModel request) {
    return Obx(() {
      final team = controller.teamOf(request);
      final statusStyle = request.status.joinRequestStatusStyle;
      final address = [team?.commune, team?.province].where((e) => (e ?? '').trim().isNotEmpty).join(', ');
      final createdAt = request.createdAt.toddMMyyyyNoEmpty;
      final message = request.requestMessage?.trim() ?? '';
      final responseMessage = request.responseMessage?.trim() ?? '';
      final requestId = request.id?.trim() ?? '';

      return ItemBorderWidget(
        onTap: requestId.isEmpty
            ? null
            : () {
                Get.toNamed(Routes.JOIN_REQUEST_DETAIL, arguments: JoinRequestDetailParameter(requestId: requestId));
              },
        code: team?.name ?? 'no_data'.tr,
        status: request.status.joinRequestStatusName,
        statusColor: statusStyle.background,
        statusTextColor: statusStyle.text,
        borderLeftColor: statusStyle.border,
        infoRows: [
          InfoItemRow(
            icon: Assets.icons.localTwo.svg(width: 16.w, height: 16.w),
            title: 'province_city'.tr,
            content: address.isNotEmpty ? address : (team?.province ?? ''),
          ),
          InfoItemRow(
            icon: Assets.icons.user.svg(width: 16.w, height: 16.w),
            title: 'contact_person'.tr,
            content: team?.leader ?? '',
          ),
          InfoItemRow(
            icon: Assets.icons.callBold.svg(width: 16.w, height: 16.w),
            title: 'phone_number'.tr,
            content: team?.phone ?? '',
          ),
          if (createdAt.isNotEmpty)
            InfoItemRow(
              icon: Assets.icons.clipboardText.svg(width: 16.w, height: 16.w),
              title: 'created_at'.tr,
              content: createdAt,
            ),
          if (message.isNotEmpty)
            InfoItemRow(
              icon: Assets.icons.message.svg(
                width: 16.w,
                height: 16.w,
                colorFilter: ColorFilter.mode(appTheme.red1AColor, BlendMode.srcIn),
              ),
              title: 'join_team_reason'.tr,
              content: message,
            ),
          // if (responseMessage.isNotEmpty)
          //   InfoItemRow(
          //     icon: Assets.icons.message.svg(
          //       width: 16.w,
          //       height: 16.w,
          //       colorFilter: ColorFilter.mode(appTheme.red1AColor, BlendMode.srcIn),
          //     ),
          //     title: 'response_message'.tr,
          //     content: responseMessage,
          //   ),
        ],
      );
    });
  }
}
