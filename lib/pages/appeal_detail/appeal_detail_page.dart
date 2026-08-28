import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/appeal_detail/appeal_detail_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/appeal_status_utils.dart';
import 'package:sos_connect/utils/appeal_target_type_utils.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/info_item_widget.dart';
import 'package:sos_connect/widget/loading_widget.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class AppealDetailPage extends GetWidget<AppealDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.sliverColor,
      appBar: DefaultAppBar(title: 'appeal_detail'.tr, backIconOther: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        final detail = controller.appeal.value;
        if (detail == null) {
          return NoDataWidget(title: 'appeals_empty_title'.tr, description: 'appeals_empty_subtitle'.tr);
        }

        final statusStyle = detail.status.appealStatusStyle;
        final statusText = detail.status.appealStatusName;
        final adminResponse = detail.adminResponse?.trim() ?? '';

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: padding(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      detail.targetType.appealTargetTypeName.isNotEmpty
                          ? detail.targetType.appealTargetTypeName
                          : 'no_data'.tr,
                      style: StyleThemeData.size16Weight700(),
                    ),
                  ),
                  if (statusText.isNotEmpty)
                    Container(
                      padding: padding(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: statusStyle.background, borderRadius: BorderRadius.circular(50)),
                      child: Text(statusText, style: StyleThemeData.size12Weight700(color: statusStyle.text)),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: padding(all: 16),
                decoration: BoxDecoration(color: appTheme.whiteColor, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  spacing: 12.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoItemWidget(title: 'appeal_target_type'.tr, content: detail.targetType.appealTargetTypeName),
                    InfoItemWidget(title: 'created_at'.tr, content: detail.createdAt.toddMMyyyyHHmm),
                    InfoItemWidget(title: 'appeal_reason'.tr, content: detail.reason ?? ''),
                    InfoItemWidget(title: 'request_status'.tr, content: statusText),
                    if (adminResponse.isNotEmpty)
                      InfoItemWidget(title: 'admin_response'.tr, content: adminResponse),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
