import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/personal_information/personal_information_controller.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/formatter_util.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/line_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class PersonalInformationPage extends GetWidget<PersonalInformationController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: .translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appTheme.whiteColor,
        appBar: DefaultAppBar(title: 'personal_info'.tr, backIconOther: true),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: padding(horizontal: 16, top: 12, bottom: 20),
            child: Column(
              children: [
                Obx(
                  () => InkWell(
                    onTap: controller.pickImage,
                    borderRadius: .circular(1000),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        controller.avatarFile.value?.file != null
                            ? ClipRRect(
                                borderRadius: .circular(1000),
                                child: Image.file(
                                  controller.avatarFile.value!.file!,
                                  width: 114.w,
                                  height: 114.w,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CustomImageWidget(imageUrl: controller.avatarUrl.value, size: 114.w, noImage: false),
                        Positioned(
                          right: 0,
                          bottom: -2,
                          child: Container(
                            padding: padding(all: 6),
                            decoration: BoxDecoration(
                              color: appTheme.whiteColor,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: appTheme.blackColor.withValues(alpha: 0.12), blurRadius: 8)],
                            ),
                            child: Assets.icons.camera.svg(
                              width: 20.w,
                              height: 20.w,
                              colorFilter: .mode(appTheme.appColor, .srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 36.h),
                CustomTextField(
                  controller: controller.fullNameController,
                  titleText: 'full_name'.tr,
                  hintText: 'enter_full_name'.tr,
                  borderRadius: 12,
                  formatter: FormatterUtil.fullNameFormatter,
                  prefixIcon: Padding(
                    padding: padding(left: 12, right: 8),
                    child: ImageAssetCustom(imagePath: Assets.icons.user.path, size: 20, color: appTheme.appColor),
                  ),
                  onValidate: (value) => CustomValidator.validateFullName(value.trim()),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.phoneController,
                  titleText: 'phone_number'.tr,
                  hintText: 'enter_phone_number'.tr,
                  borderRadius: 12,
                  readOnly: true,
                  isPhone: true,
                  inputType: TextInputType.phone,
                  formatter: FormatterUtil.phoneFormatter,
                  onValidateAsync: (value) async => CustomValidator.validatePhone(value.trim()),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.emailController,
                  titleText: 'email'.tr,
                  hintText: 'enter_email'.tr,
                  borderRadius: 12,
                  isRequired: false,
                  inputType: TextInputType.emailAddress,
                  formatter: FormatterUtil.emailFormatter,
                  prefixIcon: Padding(
                    padding: padding(left: 12, right: 8),
                    child: ImageAssetCustom(imagePath: Assets.icons.mail.path, size: 20, color: appTheme.appColor),
                  ),
                  onValidate: (value) => CustomValidator.validateEmail(value.trim(), isRequired: false),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.provinceController,
                  titleText: 'province_city'.tr,
                  hintText: 'select_province_city'.tr,
                  borderRadius: 12,
                  readOnly: true,
                  onTap: controller.selectProvince,
                  prefixIcon: Padding(
                    padding: padding(left: 12, right: 8),
                    child: ImageAssetCustom(imagePath: Assets.icons.location.path, size: 20),
                  ),
                  suffixIcon: IconButton(
                    onPressed: controller.selectProvince,
                    icon: Assets.icons.arrowDown.svg(width: 18.w, height: 18.w),
                  ),
                  onValidate: (value) => CustomValidator.validateRequiredField(value.trim(), 'province_city'.tr),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.roleController,
                  titleText: 'role'.tr,
                  hintText: 'enter_role'.tr,
                  borderRadius: 12,
                  isRequired: false,
                  readOnly: true,
                  prefixIcon: Padding(
                    padding: padding(left: 12, right: 8),
                    child: ImageAssetCustom(imagePath: Assets.icons.tagUser.path, size: 20, color: appTheme.appColor),
                  ),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.cccdController,
                  titleText: 'cccd'.tr,
                  hintText: 'enter_cccd'.tr,
                  borderRadius: 12,
                  isRequired: false,
                  inputType: TextInputType.number,
                  formatter: FormatterUtil.cccdFormatter,
                  prefixIcon: Padding(
                    padding: padding(left: 12, right: 8),
                    child: ImageAssetCustom(
                      imagePath: Assets.icons.clipboardText.path,
                      size: 20,
                      color: appTheme.appColor,
                    ),
                  ),
                  onValidate: (value) => CustomValidator.validateCCCD(value.trim(), isRequired: false),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.birthDateController,
                  titleText: 'birth_date'.tr,
                  hintText: 'enter_birth_date'.tr,
                  borderRadius: 12,
                  isRequired: false,
                  readOnly: true,
                  onTap: () => controller.pickBirthDate(context),
                  prefixIcon: Padding(
                    padding: padding(left: 12, right: 8),
                    child: ImageAssetCustom(
                      imagePath: Assets.icons.calendarDays.path,
                      size: 20,
                      color: appTheme.appColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LineWidget(color: appTheme.grayF6Color),
              CustomButton(
                margin: padding(horizontal: 16, bottom: 16, top: 12),
                buttonText: 'save'.tr,
                onPressed: controller.isFormValid.value ? controller.savePersonalInformation : null,
                isLoading: controller.isLoading.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
