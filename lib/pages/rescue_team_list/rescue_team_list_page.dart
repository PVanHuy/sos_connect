import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/rescue_team_detail/rescue_team_detail_parameter.dart';
import 'package:sos_connect/pages/rescue_team_list/rescue_team_list_controller.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/team_status_utils.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/item_border_widget.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/search/search_custom_field.dart';
import 'package:sos_connect/widget/skeleton/rescue_team_list_skeleton.dart';

class RescueTeamListPage extends GetWidget<RescueTeamListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.sliverColor,
      appBar: DefaultAppBar(title: 'approved_rescue_teams'.tr, backIconOther: true),
      body: Column(
        children: [
          Padding(
            padding: padding(horizontal: 12, top: 12, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: SearchCustomField(
                    hintText: 'search_team_name'.tr,
                    radius: 12,
                    backgroundColor: appTheme.whiteColor,
                    paddingTextfield: padding(horizontal: 12, vertical: 14),
                    onGetSearchValue: controller.onSearch,
                    getSearchStatus: controller.onUpdateSearchStatus,
                  ),
                ),
                SizedBox(width: 8.w),
                Obx(() {
                  final hasFilter = (controller.selectedProvince.value ?? '').isNotEmpty;
                  return InkWell(
                    onTap: controller.onFilterProvince,
                    onLongPress: controller.clearProvinceFilter,
                    borderRadius: .circular(12),
                    child: Container(
                      padding: padding(vertical: 16, horizontal: 14),
                      decoration: BoxDecoration(
                        color: appTheme.whiteColor,
                        borderRadius: .circular(12),
                        border: Border.all(color: hasFilter ? appTheme.appColor : appTheme.grayE5Color),
                      ),
                      child: ImageAssetCustom(
                        imagePath: Assets.icons.filter.path,
                        size: 20,
                        color: hasFilter ? appTheme.appColor : appTheme.gray83Color,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Obx(() {
            final province = controller.selectedProvince.value;
            if (province == null || province.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: padding(horizontal: 12, bottom: 8),
              child: Align(
                alignment: .centerLeft,
                child: InkWell(
                  onTap: controller.clearProvinceFilter,
                  borderRadius: .circular(20),
                  child: Container(
                    padding: padding(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: appTheme.appColor.withSafeOpacity(0.1),
                      borderRadius: .circular(20),
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Text(province, style: StyleThemeData.size12Weight700(color: appTheme.appColor)),
                        SizedBox(width: 4.w),
                        Icon(Icons.close, size: 14.w, color: appTheme.appColor),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          Expanded(
            child: LazyListView(
              controller: controller.teamListController,
              hasRefresh: true,
              shrinkWrap: false,
              callInit: true,
              physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              listPadding: padding(top: 4, horizontal: 12, bottom: 24),
              emptyView: const NoDataWidget(isScroll: true),
              skeletonView: () => const RescueTeamListSkeleton(),
              divider: SizedBox(height: 12.h),
              itemBuilder: (index, item) {
                final statusStyle = item.teamStatus.teamStatusStyle;
                final address = [item.commune, item.province].where((e) => (e ?? '').trim().isNotEmpty).join(', ');

                return ItemBorderWidget(
                  onTap: () {
                    final teamId = item.id?.trim() ?? '';
                    if (teamId.isEmpty) return;
                    Get.toNamed(
                      Routes.RESCUE_TEAM_DETAIL,
                      arguments: RescueTeamDetailParameter(
                        teamId: teamId,
                        hasPendingJoinRequest: controller.hasPendingJoinRequest,
                      ),
                    );
                  },
                  code: item.name ?? '',
                  status: item.teamStatus.teamStatusName,
                  statusColor: statusStyle.background,
                  statusTextColor: statusStyle.text,
                  borderLeftColor: statusStyle.border,
                  infoRows: [
                    InfoItemRow(
                      icon: Assets.icons.localTwo.svg(width: 16.w, height: 16.w),
                      title: 'province_city'.tr,
                      content: address.isNotEmpty ? address : (item.province ?? ''),
                    ),
                    InfoItemRow(
                      icon: Assets.icons.driver.svg(width: 16.w, height: 16.w),
                      title: 'member_count'.tr,
                      content: item.sizeMember ?? '',
                    ),
                    InfoItemRow(
                      icon: Assets.icons.user.svg(width: 16.w, height: 16.w),
                      title: 'contact_person'.tr,
                      content: item.leader ?? '',
                    ),
                    InfoItemRow(
                      icon: Assets.icons.callBold.svg(width: 16.w, height: 16.w),
                      title: 'phone_number'.tr,
                      content: item.phone ?? '',
                    ),
                    InfoItemRow(
                      icon: Assets.icons.clipboardText.svg(width: 16.w, height: 16.w),
                      title: 'organization_unit'.tr,
                      content: item.organizational ?? '',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
