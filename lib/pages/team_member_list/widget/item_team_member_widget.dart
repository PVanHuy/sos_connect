import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/team/team_member_model.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ItemTeamMemberWidget extends StatelessWidget {
  const ItemTeamMemberWidget({
    super.key,
    required this.member,
    required this.canKick,
    required this.isKicking,
    required this.onKick,
    this.onTap,
  });

  final TeamMemberModel member;
  final bool canKick;
  final bool isKicking;
  final VoidCallback onKick;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final username = member.user?.username?.trim().isNotEmpty == true ? member.user!.username! : 'no_data'.tr;
    final phone = member.user?.phone?.trim() ?? '';
    final role = (member.user?.roles ?? '').userRoleName;
    final joinedAt = member.joinedAt.toddMMyyyyNoEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: padding(all: 12),
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: appTheme.blackColor.withSafeOpacity(.08), blurRadius: 16, offset: Offset.zero)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomImageWidget(imageUrl: member.user?.avatar ?? '', size: 44.w, noImage: false),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username, style: StyleThemeData.size16Weight700()),
                      if (phone.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(phone, style: StyleThemeData.size12Weight400(color: appTheme.gray80Color)),
                      ],
                      if (joinedAt.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          '${'joined_at'.tr}: $joinedAt',
                          style: StyleThemeData.size12Weight400(color: appTheme.gray80Color),
                        ),
                      ],
                    ],
                  ),
                ),
                if (role.isNotEmpty)
                  Container(
                    padding: padding(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: appTheme.grayF6Color, borderRadius: BorderRadius.circular(20)),
                    child: Text(role, style: StyleThemeData.size12Weight700(color: appTheme.appColor)),
                  ),
              ],
            ),
            if (canKick) ...[
              SizedBox(height: 12.h),
              CustomButton(
                buttonText: 'kick'.tr,
                color: appTheme.redF4Color,
                textColor: appTheme.red55Color,
                paddingButton: padding(horizontal: 12, vertical: 10),
                hasSafeArea: false,
                isLoading: isKicking,
                onPressed: onKick,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
