import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/rescue_posts/widget/rescue_chip_widget.dart';
import 'package:sos_connect/pages/rescue_posts/widget/rescue_info_row_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/route_launcher_util.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/full_photo_viewer.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ItemRescuePostWidget extends StatelessWidget {
  const ItemRescuePostWidget({
    super.key,
    this.imageUrl = '',
    required this.supportType,
    required this.supportTypeColor,
    required this.supportTypeBgColor,
    required this.time,
    required this.remainingTime,
    required this.description,
    required this.address,
    required this.phone,
    required this.teamName,
    required this.managerName,
    required this.managerPhone,
    this.showSafeButton = false,
    this.onMarkAsSafe,
  });

  final String imageUrl;
  final String supportType;
  final Color supportTypeColor;
  final Color supportTypeBgColor;
  final String time;
  final String remainingTime;
  final String description;
  final String address;
  final String phone;
  final String teamName;
  final String managerName;
  final String managerPhone;
  final bool showSafeButton;
  final VoidCallback? onMarkAsSafe;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: .circular(12),
        boxShadow: [BoxShadow(color: appTheme.blackColor.withSafeOpacity(.08), blurRadius: 16, offset: Offset.zero)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  if (imageUrl.isEmpty) return;
                  FullPhotoViewer.open(context, assets: [imageUrl]);
                },
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 200.h,
                  borderRadius: 0,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10.h,
                left: 10.w,
                child: RescueChipWidget(
                  text: supportType,
                  foreground: supportTypeColor,
                  background: supportTypeBgColor,
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: RescueChipWidget(
                  text: remainingTime,
                  foreground: appTheme.whiteColor,
                  background: appTheme.blackColor.withSafeOpacity(.55),
                ),
              ),
            ],
          ),
          Padding(
            padding: padding(all: 12),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(time, style: StyleThemeData.size12Weight400(color: appTheme.gray83Color)),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: StyleThemeData.size14Weight400(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                RescueInfoRowWidget(
                  icon: Assets.icons.localTwo.path,
                  text: address,
                  onTap: () => RouteLauncherUtil.openGoogleMapByAddress(address),
                ),
                SizedBox(height: 8.h),
                RescueInfoRowWidget(
                  icon: Assets.icons.callBold.path,
                  text: phone,
                  onTap: () => RouteLauncherUtil.openPhoneCall(phone),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: padding(all: 12),
                  decoration: BoxDecoration(color: appTheme.grayF6Color, borderRadius: .circular(10)),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text('rescue_team_info'.tr, style: StyleThemeData.size12Weight700(color: appTheme.gray83Color)),
                      SizedBox(height: 6.h),
                      Text(teamName, style: StyleThemeData.size14Weight700()),
                      SizedBox(height: 4.h),
                      Text('${'manager'.tr}: $managerName', style: StyleThemeData.size12Weight400()),
                      SizedBox(height: 6.h),
                      RescueInfoRowWidget(
                        icon: Assets.icons.callBold.path,
                        text: managerPhone,
                        onTap: () => RouteLauncherUtil.openPhoneCall(managerPhone),
                      ),
                    ],
                  ),
                ),
                if (showSafeButton) ...[
                  SizedBox(height: 12.h),
                  CustomButton(buttonText: 'mark_as_safe'.tr, hasSafeArea: false, onPressed: onMarkAsSafe),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
