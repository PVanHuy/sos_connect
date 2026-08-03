import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/join_request_detail/join_request_detail_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/join_team_request_status_utils.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/info_item_widget.dart';
import 'package:sos_connect/widget/loading_widget.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class JoinRequestDetailPage extends GetWidget<JoinRequestDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.sliverColor,
      appBar: DefaultAppBar(title: 'join_request_detail'.tr, backIconOther: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        final detail = controller.detail.value;
        if (detail == null) {
          return NoDataWidget(
            title: 'my_join_team_request_empty_title'.tr,
            description: 'my_join_team_request_empty_subtitle'.tr,
          );
        }

        final statusStyle = detail.status.joinRequestStatusStyle;
        final statusText = detail.status.joinRequestStatusName;

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
                      detail.teamName.isNotEmpty ? detail.teamName : 'no_data'.tr,
                      style: StyleThemeData.size16Weight700(),
                    ),
                  ),
                  if (statusText.isNotEmpty)
                    Container(
                      padding: padding(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusStyle.background,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        statusText,
                        style: StyleThemeData.size12Weight700(color: statusStyle.text),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: padding(all: 16),
                decoration: BoxDecoration(
                  color: appTheme.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  spacing: 12.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoItemWidget(title: 'team_name'.tr, content: detail.teamName),
                    InfoItemWidget(title: 'contact_person'.tr, content: detail.contactPerson),
                    InfoItemWidget(title: 'phone_number'.tr, content: detail.phone),
                    InfoItemWidget(title: 'created_at'.tr, content: detail.createdAt.toddMMyyyyHHmm),
                    InfoItemWidget(title: 'join_team_reason'.tr, content: detail.reason),
                    InfoItemWidget(title: 'request_status'.tr, content: statusText),
                    if (detail.responseMessage.isNotEmpty)
                      InfoItemWidget(title: 'response_message'.tr, content: detail.responseMessage),
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
