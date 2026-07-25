import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/formatter_util.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class Step2RegisterRescueTeamView extends GetView<RegisterRescueTeamController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: padding(horizontal: 16, top: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('contact_person'.tr, style: StyleThemeData.size20Weight700()),
          SizedBox(height: 8.h),
          Text('contact_person_desc'.tr, style: StyleThemeData.size14Weight400(color: appTheme.gray80Color)),
          SizedBox(height: 16.h),
          CustomTextField(
            titleText: 'full_name'.tr,
            hintText: 'enter_full_name'.tr,
            controller: controller.contactNameController,
            borderRadius: 12,
            formatter: FormatterUtil.fullNameFormatter,
            prefixIcon: _prefixIcon(Assets.icons.user.path),
            onValidate: (value) => CustomValidator.validateFullName(value.trim()),
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            titleText: 'phone_number'.tr,
            hintText: 'enter_phone_number'.tr,
            controller: controller.contactPhoneController,
            borderRadius: 12,
            isPhone: true,
            inputType: TextInputType.phone,
            formatter: FormatterUtil.phoneFormatter,
            onValidateAsync: (value) async => CustomValidator.validatePhone(value.trim()),
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            titleText: 'email'.tr,
            hintText: 'enter_email'.tr,
            controller: controller.contactEmailController,
            borderRadius: 12,
            isRequired: false,
            inputType: TextInputType.emailAddress,
            formatter: FormatterUtil.emailFormatter,
            prefixIcon: _prefixIcon(Assets.icons.message.path),
            onValidate: (value) => CustomValidator.validateEmail(value.trim(), isRequired: false),
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            titleText: 'role'.tr,
            hintText: 'select_role'.tr,
            controller: controller.roleController,
            borderRadius: 12,
            readOnly: true,
            onTap: controller.selectRole,
            prefixIcon: _prefixIcon(Assets.icons.tagUser.path),
            suffixIcon: IconButton(
              onPressed: controller.selectRole,
              icon: Assets.icons.arrowDown.svg(width: 18.w, height: 18.w),
            ),
            onValidate: (value) => CustomValidator.validateRequiredField(value.trim(), 'role'.tr),
          ),
        ],
      ),
    );
  }

  Widget _prefixIcon(String path) {
    return Padding(
      padding: padding(left: 12, right: 8),
      child: ImageAssetCustom(imagePath: path, size: 20, color: appTheme.appColor),
    );
  }
}
