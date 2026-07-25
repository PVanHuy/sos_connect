import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/pages/support/widget/item_support_sos_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

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
            ImageAssetCustom(imagePath: Assets.icons.filter.path, size: 20, color: appTheme.gray83Color),
          ],
        ),
        SizedBox(height: 12.h),
        ItemSupportSosWidget(
          type: SosEmergencyType.medical,
          urgencyScore: '9/10',
          time: '5 phút trước',
          description: 'Người già bị ngất, cần hỗ trợ y tế khẩn cấp và đưa đến bệnh viện gần nhất.',
          address: 'Bình Thạnh, TP.HCM',
          acceptButtonText: 'accept_rescue'.tr,
          onAccept: () {},
        ),
        SizedBox(height: 12.h),
        ItemSupportSosWidget(
          type: SosEmergencyType.needRescue,
          urgencyScore: '8/10',
          time: '12 phút trước',
          description: 'Xe bị kẹt giữa dòng nước lũ, trên xe có 2 người lớn và 1 trẻ em.',
          address: 'Quận 7, TP.HCM',
          acceptButtonText: 'accept_mission'.tr,
          onAccept: () {},
        ),
        SizedBox(height: 12.h),
        ItemSupportSosWidget(
          type: SosEmergencyType.food,
          urgencyScore: '6/10',
          time: '30 phút trước',
          description: 'Gia đình 5 người đang thiếu thực phẩm và nước uống sạch sau mưa lũ.',
          address: 'Thủ Đức, TP.HCM',
          acceptButtonText: 'accept_rescue'.tr,
          onAccept: () {},
        ),
      ],
    );
  }
}
