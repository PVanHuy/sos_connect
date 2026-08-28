import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/notification_detail/notification_detail_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/appeal_submit_helper.dart';
import 'package:sos_connect/utils/notification_appeal_utils.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class NotificationDetailPage extends GetWidget<NotificationDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: DefaultAppBar(title: 'notification_detail'.tr, backIconOther: true),
      body: Obx(() {
        if (controller.isLoading.value && controller.notificationDetail.value == null) {
          return const SizedBox.shrink();
        }

        final detail = controller.notificationDetail.value;
        if (detail == null) {
          return NoDataWidget(title: 'notifications_empty_title'.tr, description: 'notifications_empty_subtitle'.tr);
        }

        final imageUrl = detail.imageUrl?.trim() ?? '';
        final reason = NotificationAppealUtils.reasonOf(detail) ?? '';
        final canAppeal = NotificationAppealUtils.canAppeal(type: detail.type, action: detail.action);
        final targetType = NotificationAppealUtils.targetTypeOf(type: detail.type, action: detail.action);
        final targetId = NotificationAppealUtils.targetIdOf(detail);

        return SingleChildScrollView(
          padding: padding(all: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text((detail.title ?? '').toUpperCase(), style: StyleThemeData.size16Weight700()),
              SizedBox(height: 8.h),
              Text(detail.createdAt.toddMMyyyyHHmm, style: StyleThemeData.size12Weight400(color: appTheme.grayColor)),
              if (imageUrl.isNotEmpty) ...[
                SizedBox(height: 16.h),
                CustomImageWidget(
                  borderRadius: 8,
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 192.h,
                  fit: BoxFit.cover,
                  noImage: false,
                ),
              ],
              SizedBox(height: 16.h),
              Text(detail.content ?? '', style: StyleThemeData.size14Weight400()),
              if (reason.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: padding(all: 12),
                  decoration: BoxDecoration(color: appTheme.redF4Color, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('admin_reason'.tr, style: StyleThemeData.size12Weight700(color: appTheme.red55Color)),
                      SizedBox(height: 8.h),
                      Text(reason, style: StyleThemeData.size14Weight400()),
                    ],
                  ),
                ),
              ],
              if (canAppeal && (targetType ?? '').isNotEmpty && (targetId ?? '').isNotEmpty) ...[
                SizedBox(height: 16.h),
                CustomButton(
                  buttonText: 'send_appeal'.tr,
                  hasSafeArea: false,
                  onPressed: () => AppealSubmitHelper.submit(targetType: targetType!, targetId: targetId!),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
