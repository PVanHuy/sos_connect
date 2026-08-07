import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/pages/support/widget/item_support_sos_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/skeleton/support_sos_list_skeleton.dart';

class SupportListView extends GetView<SupportController> {
  const SupportListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: controller.selectProvince,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: padding(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: appTheme.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: appTheme.grayE5Color),
            ),
            child: Row(
              children: [
                ImageAssetCustom(imagePath: Assets.icons.location.path, size: 18),
                SizedBox(width: 8.w),
                Expanded(
                  child: Obx(
                    () => Text(
                      controller.selectedProvinceName,
                      style: StyleThemeData.size14Weight400(
                        color: controller.selectedProvince.value == null ? appTheme.gray83Color : appTheme.blackColor,
                      ),
                    ),
                  ),
                ),
                ImageAssetCustom(imagePath: Assets.icons.arrowDown.path, size: 16, color: appTheme.gray83Color),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: Text('sos_ranked_by_ai'.tr, style: StyleThemeData.size14Weight700())),
            InkWell(
              onTap: controller.openListFilter,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: padding(all: 4),
                child: Obx(() {
                  final hasFilter = controller.hasActiveFilter;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ImageAssetCustom(imagePath: Assets.icons.filter.path, size: 20, color: appTheme.gray83Color),
                      if (hasFilter)
                        Positioned(
                          right: -1.w,
                          top: -1.h,
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: appTheme.red55Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: appTheme.whiteColor, width: 1),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: LazyListView(
            controller: controller.sosListController,
            callInit: false,
            hasRefresh: true,
            shrinkWrap: false,
            physics: const AlwaysScrollableScrollPhysics(),
            listPadding: EdgeInsets.zero,
            emptyView: SizedBox.expand(
              child: NoDataWidget(
                isScroll: false,
                title: 'sos_list_empty_title'.tr,
                description: 'sos_list_empty_subtitle'.tr,
              ),
            ),
            skeletonView: () => const SupportSosListSkeleton(),
            divider: SizedBox(height: 12.h),
            itemBuilder: (index, item) {
              return Obx(
                () => ItemSupportSosWidget(
                  type: item.emergencyType,
                  urgencyScore: item.urgencyScoreText,
                  time: controller.formatSosTime(item.createdAt),
                  description: item.description ?? '',
                  address: item.addressText ?? '',
                  imageUrl: item.image ?? '',
                  acceptButtonText: 'accept_rescue'.tr,
                  showAcceptButton: controller.canAcceptSos,
                  isAccepting: controller.acceptingId.value == item.id,
                  onAccept: () => controller.onAcceptSos(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
