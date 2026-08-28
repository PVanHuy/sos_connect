import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/appeal/appeal_model.dart';
import 'package:sos_connect/pages/appeal_detail/appeal_detail_parameter.dart';
import 'package:sos_connect/pages/appeal_list/appeal_list_controller.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/appeal_status_utils.dart';
import 'package:sos_connect/utils/appeal_target_type_utils.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/item_border_widget.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/skeleton/appeal_list_skeleton.dart';

class AppealListPage extends GetWidget<AppealListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.sliverColor,
      appBar: DefaultAppBar(title: 'my_appeals'.tr, backIconOther: true),
      body: LazyListView<AppealModel>(
        controller: controller.listController,
        hasRefresh: true,
        shrinkWrap: false,
        callInit: true,
        physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
        listPadding: padding(top: 12, horizontal: 12, bottom: 24),
        emptyView: NoDataWidget(
          isScroll: true,
          title: 'appeals_empty_title'.tr,
          description: 'appeals_empty_subtitle'.tr,
        ),
        skeletonView: () => const AppealListSkeleton(),
        divider: SizedBox(height: 12.h),
        itemBuilder: (index, item) => _buildItem(item),
      ),
    );
  }

  Widget _buildItem(AppealModel item) {
    final statusStyle = item.status.appealStatusStyle;
    final appealId = item.id?.trim() ?? '';
    final createdAt = item.createdAt.toddMMyyyyNoEmpty;
    final reason = item.reason?.trim() ?? '';

    return ItemBorderWidget(
      onTap: appealId.isEmpty
          ? null
          : () {
              Get.toNamed(Routes.APPEAL_DETAIL, arguments: AppealDetailParameter(appealId: appealId));
            },
      code: item.targetType.appealTargetTypeName.isNotEmpty ? item.targetType.appealTargetTypeName : 'no_data'.tr,
      status: item.status.appealStatusName,
      statusColor: statusStyle.background,
      statusTextColor: statusStyle.text,
      borderLeftColor: statusStyle.border,
      infoRows: [
        if (createdAt.isNotEmpty)
          InfoItemRow(
            icon: Assets.icons.clipboardText.svg(width: 16.w, height: 16.w),
            title: 'created_at'.tr,
            content: createdAt,
          ),
        if (reason.isNotEmpty)
          InfoItemRow(
            icon: Assets.icons.message.svg(
              width: 16.w,
              height: 16.w,
              colorFilter: ColorFilter.mode(appTheme.red1AColor, BlendMode.srcIn),
            ),
            title: 'appeal_reason'.tr,
            content: reason,
          ),
      ],
    );
  }
}
