import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/team/join_team_request_model.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ItemJoinTeamRequestWidget extends StatelessWidget {
  const ItemJoinTeamRequestWidget({
    super.key,
    required this.request,
    required this.isAccepting,
    required this.isRejecting,
    required this.onAccept,
    required this.onReject,
  });

  final JoinTeamRequestModel request;
  final bool isAccepting;
  final bool isRejecting;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final username = request.user?.username?.trim().isNotEmpty == true ? request.user!.username! : 'no_data'.tr;
    final phone = request.user?.phone?.trim() ?? '';
    final message = request.requestMessage?.trim() ?? '';
    final createdAt = request.createdAt.toddMMyyyyNoEmpty;
    final isBusy = isAccepting || isRejecting;

    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: .circular(12),
        boxShadow: [BoxShadow(color: appTheme.blackColor.withSafeOpacity(.08), blurRadius: 16, offset: Offset.zero)],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              CustomImageWidget(imageUrl: request.user?.avatar ?? '', size: 44.w, noImage: false),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(phone.isNotEmpty ? '$username - $phone' : username, style: StyleThemeData.size16Weight700()),
                    if (createdAt.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(createdAt, style: StyleThemeData.size12Weight400(color: appTheme.gray80Color)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (message.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text('join_team_reason'.tr, style: StyleThemeData.size12Weight700()),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: padding(all: 12),
              decoration: BoxDecoration(color: appTheme.grayF6Color, borderRadius: .circular(8)),
              child: Text(message, style: StyleThemeData.size14Weight400()),
            ),
          ],
          SizedBox(height: 16.h),
          Row(
            spacing: 8.w,
            children: [
              Expanded(
                child: CustomButton(
                  buttonText: 'reject'.tr,
                  color: appTheme.sliverColor,
                  textColor: appTheme.errorColor,
                  paddingButton: padding(horizontal: 12, vertical: 12),
                  hasSafeArea: false,
                  isLoading: isRejecting,
                  onPressed: isBusy ? null : onReject,
                ),
              ),
              Expanded(
                child: CustomButton(
                  buttonText: 'accept'.tr,
                  paddingButton: padding(horizontal: 12, vertical: 12),
                  hasSafeArea: false,
                  isLoading: isAccepting,
                  onPressed: isBusy ? null : onAccept,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
