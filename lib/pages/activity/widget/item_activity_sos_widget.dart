import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/activity/widget/activity_chip_widget.dart';
import 'package:sos_connect/pages/activity/widget/activity_info_row_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/route_launcher_util.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/full_photo_viewer.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ItemActivitySosWidget extends StatelessWidget {
  const ItemActivitySosWidget({
    super.key,
    this.imageUrl = '',
    required this.supportType,
    required this.supportTypeColor,
    required this.supportTypeBgColor,
    required this.remainingTime,
    required this.description,
    required this.address,
    required this.phone,
    this.statusTextColor,
    this.statusBgColor,
    this.teamName = '',
    this.managerName = '',
    this.managerPhone = '',
    this.showSafeButton = false,
    this.isMarkingSafe = false,
    this.onMarkAsSafe,
    this.showChatButton = false,
    this.onChat,
    this.onViewOnMap,
    this.rejectionReason = '',
    this.showAppealButton = false,
    this.onAppeal,
  });

  final String imageUrl;
  final String supportType;
  final Color supportTypeColor;
  final Color supportTypeBgColor;
  final String remainingTime;
  final Color? statusTextColor;
  final Color? statusBgColor;
  final String description;
  final String address;
  final String phone;
  final String teamName;
  final String managerName;
  final String managerPhone;
  final bool showSafeButton;
  final bool isMarkingSafe;
  final VoidCallback? onMarkAsSafe;
  final bool showChatButton;
  final VoidCallback? onChat;
  final VoidCallback? onViewOnMap;
  final String rejectionReason;
  final bool showAppealButton;
  final VoidCallback? onAppeal;

  bool get _hasTeamInfo => teamName.trim().isNotEmpty;

  void _openMap() {
    // Backup: mở Google Maps theo địa chỉ
    // RouteLauncherUtil.openGoogleMapByAddress(address);
    onViewOnMap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appTheme.grayE5Color),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ActivityChipWidget(text: supportType, foreground: supportTypeColor, background: supportTypeBgColor),
              const Spacer(),
              if (remainingTime.trim().isNotEmpty)
                ActivityChipWidget(
                  text: remainingTime,
                  foreground: statusTextColor ?? appTheme.oldSliverColor,
                  background: statusBgColor ?? appTheme.grayF1Color,
                ),
            ],
          ),
          if (imageUrl.isNotEmpty) ...[
            SizedBox(height: 12.h),
            InkWell(
              onTap: () => FullPhotoViewer.open(context, assets: [imageUrl]),
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 180.h,
                borderRadius: 10,
                fit: BoxFit.cover,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: padding(all: 12),
            decoration: BoxDecoration(color: appTheme.grayF6Color, borderRadius: BorderRadius.circular(8)),
            child: Text(
              description.isNotEmpty ? description : 'no_data'.tr,
              style: StyleThemeData.size14Weight400(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 12.h),
          ActivityInfoRowWidget(icon: Assets.icons.localTwo.path, text: address, onTap: _openMap),
          SizedBox(height: 8.h),
          ActivityInfoRowWidget(
            icon: Assets.icons.callBold.path,
            text: phone,
            onTap: () => RouteLauncherUtil.openPhoneCall(phone),
          ),
          if (_hasTeamInfo) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: padding(all: 12),
              decoration: BoxDecoration(color: appTheme.grayF6Color, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('rescue_team_info'.tr, style: StyleThemeData.size12Weight700(color: appTheme.gray83Color)),
                  SizedBox(height: 6.h),
                  Text(teamName, style: StyleThemeData.size14Weight700()),
                  if (managerName.trim().isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text('${'manager'.tr}: $managerName', style: StyleThemeData.size12Weight400()),
                  ],
                  if (managerPhone.trim().isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    ActivityInfoRowWidget(
                      icon: Assets.icons.callBold.path,
                      text: managerPhone,
                      onTap: () => RouteLauncherUtil.openPhoneCall(managerPhone),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (rejectionReason.trim().isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: padding(all: 12),
              decoration: BoxDecoration(color: appTheme.redF4Color, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('admin_reason'.tr, style: StyleThemeData.size12Weight700(color: appTheme.red55Color)),
                  SizedBox(height: 4.h),
                  Text(rejectionReason.trim(), style: StyleThemeData.size14Weight400()),
                ],
              ),
            ),
          ],
          if (onViewOnMap != null || showChatButton) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                if (onViewOnMap != null)
                  Expanded(
                    child: CustomButton(
                      buttonText: 'view_on_map'.tr,
                      color: appTheme.greenECColor,
                      textColor: appTheme.green47Color,
                      hasSafeArea: false,
                      onPressed: _openMap,
                    ),
                  ),
                if (onViewOnMap != null && showChatButton) SizedBox(width: 8.w),
                if (showChatButton)
                  Expanded(
                    child: CustomButton(buttonText: 'sos_chat_open'.tr, hasSafeArea: false, onPressed: onChat),
                  ),
              ],
            ),
          ],
          if (showAppealButton) ...[
            SizedBox(height: 12.h),
            CustomButton(
              buttonText: 'send_appeal'.tr,
              color: appTheme.sliverColor,
              textColor: appTheme.appColor,
              hasSafeArea: false,
              onPressed: onAppeal,
            ),
          ],
          if (showSafeButton) ...[
            SizedBox(height: 12.h),
            CustomButton(
              buttonText: 'mark_as_safe'.tr,
              hasSafeArea: false,
              isLoading: isMarkingSafe,
              onPressed: onMarkAsSafe,
            ),
          ],
        ],
      ),
    );
  }
}
