import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/formatter_util.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/dash_border_painter.dart';
import 'package:sos_connect/widget/full_photo_viewer.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class Step1RegisterRescueTeamView extends GetView<RegisterRescueTeamController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: padding(horizontal: 16, top: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('team_information'.tr, style: StyleThemeData.size20Weight700()),
          SizedBox(height: 8.h),
          Text('team_information_desc'.tr, style: StyleThemeData.size14Weight400(color: appTheme.gray80Color)),
          SizedBox(height: 16.h),
          CustomTextField(
            titleText: 'team_name'.tr,
            hintText: 'enter_team_name'.tr,
            controller: controller.teamNameController,
            borderRadius: 12,
            formatter: FormatterUtil.titleFormatter,
            onValidate: (value) => CustomValidator.validateRequiredField(value.trim(), 'team_name'.tr),
          ),
          SizedBox(height: 12.h),
          Text('activity_area'.tr, style: StyleThemeData.size14Weight700()),
          SizedBox(height: 12.h),
          CustomTextField(
            titleText: 'province_city'.tr,
            hintText: 'select_province_city'.tr,
            controller: controller.provinceController,
            borderRadius: 12,
            readOnly: true,
            onTap: controller.selectProvince,
            suffixIcon: IconButton(
              onPressed: controller.selectProvince,
              icon: Assets.icons.arrowDown.svg(width: 18.w, height: 18.w),
            ),
            onValidate: (value) => CustomValidator.validateRequiredField(value.trim(), 'province_city'.tr),
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            titleText: 'ward'.tr,
            hintText: 'select_ward'.tr,
            controller: controller.wardController,
            borderRadius: 12,
            readOnly: true,
            onTap: controller.selectWard,
            suffixIcon: IconButton(
              onPressed: controller.selectWard,
              icon: Assets.icons.arrowDown.svg(width: 18.w, height: 18.w),
            ),
            onValidate: (value) => CustomValidator.validateRequiredField(value.trim(), 'ward'.tr),
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            titleText: 'member_count'.tr,
            hintText: 'enter_member_count'.tr,
            controller: controller.memberCountController,
            borderRadius: 12,
            inputType: TextInputType.number,
            maxLength: 2,
            formatter: FormatterUtil.numberFormatter,
            onValidate: (value) => CustomValidator.validateRequiredField(value.trim(), 'member_count'.tr),
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            titleText: 'organization_unit'.tr,
            hintText: 'enter_organization_unit'.tr,
            controller: controller.organizationController,
            borderRadius: 12,
            formatter: FormatterUtil.titleFormatter,
            onValidate: (value) => CustomValidator.validateRequiredField(value.trim(), 'organization_unit'.tr),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text('confirmation_document'.tr, style: StyleThemeData.size14Weight700()),
              SizedBox(width: 4.w),
              Text('*', style: StyleThemeData.size14Weight700(color: appTheme.errorColor)),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(() => _buildUploadCard(context)),
        ],
      ),
    );
  }

  Widget _buildUploadCard(BuildContext context) {
    final file = controller.confirmationDocument.value?.file;
    final existingUrl = controller.existingDocumentUrl;

    return CustomPaint(
      painter: DashBorderPainter(color: appTheme.appColor, strokeWidth: 1.w, radius: 16, dashWidth: 4, dashGap: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: file != null
            ? AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    InkWell(
                      onTap: () => FullPhotoViewer.open(context, assets: [file]),
                      child: Image.file(file, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 8.w,
                      bottom: 8.h,
                      child: InkWell(
                        onTap: controller.pickConfirmationDocument,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: padding(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: appTheme.whiteColor.withSafeOpacity(0.92),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'change_image'.tr,
                            style: StyleThemeData.size12Weight400(color: appTheme.appColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : existingUrl.isNotEmpty
            ? AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    InkWell(
                      onTap: () => FullPhotoViewer.open(context, assets: [existingUrl]),
                      child: CustomImageWidget(
                        imageUrl: existingUrl,
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 0,
                        noImage: false,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 8.w,
                      bottom: 8.h,
                      child: InkWell(
                        onTap: controller.pickConfirmationDocument,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: padding(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: appTheme.whiteColor.withSafeOpacity(0.92),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'change_image'.tr,
                            style: StyleThemeData.size12Weight400(color: appTheme.appColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: controller.pickConfirmationDocument,
                child: Container(
                  width: double.infinity,
                  padding: padding(vertical: 16),
                  child: Column(
                    children: [
                      Assets.icons.galleryAdd.svg(width: 32.w, height: 32.w, color: appTheme.appColor),
                      SizedBox(height: 12.h),
                      Text('upload_image'.tr, style: StyleThemeData.size14Weight700(color: appTheme.appColor)),
                      SizedBox(height: 2.h),
                      Text(
                        'upload_confirmation_document_note'.tr,
                        style: StyleThemeData.size14Weight400(color: appTheme.gray8FColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
