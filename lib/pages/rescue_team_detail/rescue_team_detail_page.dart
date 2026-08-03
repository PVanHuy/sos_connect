import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/rescue_team_detail/rescue_team_detail_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/team_status_utils.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/dash_border_painter.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/full_photo_viewer.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/line_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class RescueTeamDetailPage extends GetWidget<RescueTeamDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: DefaultAppBar(title: 'team_information_title'.tr, backIconOther: true),
      body: Obx(() {
        if (controller.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final team = controller.teamModel.value;
        if (team == null) {
          return Center(
            child: Text('no_data'.tr, style: StyleThemeData.size14Weight400(color: appTheme.gray80Color)),
          );
        }

        final statusStyle = team.teamStatus.teamStatusStyle;
        final documentUrl = team.documentUrl ?? '';

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: padding(horizontal: 16, top: 12, bottom: 24),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('team_information'.tr, style: StyleThemeData.size20Weight700())),
                  Container(
                    padding: padding(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusStyle.background,
                      borderRadius: .circular(20),
                      border: Border.all(color: statusStyle.border),
                    ),
                    child: Text(
                      team.teamStatus.teamStatusName,
                      style: StyleThemeData.size12Weight700(color: statusStyle.text),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                titleText: 'team_name'.tr,
                controller: controller.teamNameController,
                borderRadius: 12,
                readOnly: true,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                titleText: 'province_city'.tr,
                controller: controller.provinceController,
                borderRadius: 12,
                readOnly: true,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                titleText: 'ward'.tr,
                controller: controller.wardController,
                borderRadius: 12,
                readOnly: true,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                titleText: 'member_count'.tr,
                controller: controller.memberCountController,
                borderRadius: 12,
                readOnly: true,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                titleText: 'organization_unit'.tr,
                controller: controller.organizationController,
                borderRadius: 12,
                readOnly: true,
              ),
              SizedBox(height: 12.h),
              Text('confirmation_document'.tr, style: StyleThemeData.size14Weight700()),
              SizedBox(height: 8.h),
              CustomPaint(
                painter: DashBorderPainter(
                  color: appTheme.appColor,
                  strokeWidth: 1.w,
                  radius: 16,
                  dashWidth: 4,
                  dashGap: 4,
                ),
                child: ClipRRect(
                  borderRadius: .circular(16),
                  child: documentUrl.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: padding(vertical: 24),
                          alignment: .center,
                          child: Text('no_data'.tr, style: StyleThemeData.size14Weight400(color: appTheme.gray80Color)),
                        )
                      : AspectRatio(
                          aspectRatio: 16 / 10,
                          child: InkWell(
                            onTap: () => FullPhotoViewer.open(context, assets: [documentUrl]),
                            child: CustomImageWidget(
                              imageUrl: documentUrl,
                              width: double.infinity,
                              height: double.infinity,
                              borderRadius: 0,
                              noImage: false,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24.h),
              Text('contact_person'.tr, style: StyleThemeData.size20Weight700()),
              SizedBox(height: 16.h),
              CustomTextField(
                titleText: 'full_name'.tr,
                controller: controller.contactNameController,
                borderRadius: 12,
                readOnly: true,
                prefixIcon: _prefixIcon(Assets.icons.user.path),
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                titleText: 'phone_number'.tr,
                controller: controller.contactPhoneController,
                borderRadius: 12,
                readOnly: true,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                titleText: 'email'.tr,
                controller: controller.contactEmailController,
                borderRadius: 12,
                readOnly: true,
                isRequired: false,
                prefixIcon: _prefixIcon(Assets.icons.message.path),
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                titleText: 'role'.tr,
                controller: controller.roleController,
                borderRadius: 12,
                readOnly: true,
                prefixIcon: _prefixIcon(Assets.icons.tagUser.path),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (!controller.canJoinTeam) return const SizedBox.shrink();

        return Column(
          mainAxisSize: .min,
          children: [
            LineWidget(color: appTheme.grayF6Color),
            CustomButton(
              margin: padding(horizontal: 16, bottom: 16, top: 12),
              buttonText: 'join_team_request'.tr,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.onJoinTeam,
            ),
          ],
        );
      }),
    );
  }

  Widget _prefixIcon(String path) {
    return Padding(
      padding: padding(left: 12, right: 8),
      child: ImageAssetCustom(imagePath: path, size: 20, color: appTheme.appColor),
    );
  }
}
