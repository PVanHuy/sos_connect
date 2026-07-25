import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/formatter_util.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/dash_border_painter.dart';
import 'package:sos_connect/widget/full_photo_viewer.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SupportRequestFormView extends GetView<SupportController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding(all: 12),
      decoration: BoxDecoration(color: appTheme.grayF6Color, borderRadius: .circular(16)),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 12.h,
        children: [
          CustomTextField(
            controller: controller.descriptionController,
            titleText: 'situation_description'.tr,
            hintText: 'enter_situation_description'.tr,
            maxLines: 4,
            borderRadius: 12,
            isRequired: false,
          ),
          CustomTextField(
            controller: controller.locationController,
            titleText: 'location'.tr,
            hintText: 'enter_current_location'.tr,
            borderRadius: 12,
            onValidate: (value) => CustomValidator.validateRequiredField(value, 'location'.tr),
          ),
          CustomTextField(
            controller: controller.phoneController,
            titleText: 'contact_info'.tr,
            hintText: 'phone_number'.tr,
            inputType: TextInputType.phone,
            isPhone: true,
            borderRadius: 12,
            formatter: FormatterUtil.phoneFormatter,
            onValidateAsync: (value) => CustomValidator.validatePhone(value),
          ),
          Text('images'.tr, style: StyleThemeData.size14Weight700()),
          Obx(() => _buildUploadCard(context)),
          SizedBox(height: 16.h),
          Obx(() {
            final isValid = controller.isFormValid.value;
            return CustomButton(
              buttonText: 'send_sos'.tr,
              hasSafeArea: false,
              color: isValid ? null : appTheme.whiteColor,
              textColor: isValid ? null : appTheme.gray86Color,
              onPressed: isValid ? controller.sendSos : () {},
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUploadCard(BuildContext context) {
    final file = controller.selectedImage.value;
    return CustomPaint(
      painter: DashBorderPainter(color: appTheme.appColor, strokeWidth: 1.w, radius: 16, dashWidth: 4, dashGap: 4),
      child: ClipRRect(
        borderRadius: .circular(16),
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
                        onTap: controller.pickImage,
                        borderRadius: .circular(20),
                        child: Container(
                          padding: padding(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: appTheme.whiteColor.withValues(alpha: 0.92),
                            borderRadius: .circular(20),
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
                onTap: controller.pickImage,
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
                        'upload_sos_image_note'.tr,
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
