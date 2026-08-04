import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/user_detail/user_detail_controller.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/loading_widget.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class UserDetailPage extends GetWidget<UserDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: DefaultAppBar(title: 'member_information'.tr, backIconOther: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        if (controller.userModel.value == null) {
          return NoDataWidget(
            title: 'member_information_empty_title'.tr,
            description: 'member_information_empty_subtitle'.tr,
          );
        }

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: padding(horizontal: 16, top: 12, bottom: 24),
          child: Column(
            children: [
              CustomImageWidget(imageUrl: controller.avatarUrl, size: 114.w, noImage: false),
              SizedBox(height: 36.h),
              CustomTextField(
                titleText: 'full_name'.tr,
                controller: controller.fullNameController,
                borderRadius: 12,
                readOnly: true,
                prefixIcon: _prefixIcon(Assets.icons.user.path),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                titleText: 'phone_number'.tr,
                controller: controller.phoneController,
                borderRadius: 12,
                readOnly: true,
                isPhone: true,
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                titleText: 'email'.tr,
                controller: controller.emailController,
                borderRadius: 12,
                readOnly: true,
                isRequired: false,
                prefixIcon: _prefixIcon(Assets.icons.mail.path),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                titleText: 'province_city'.tr,
                controller: controller.provinceController,
                borderRadius: 12,
                readOnly: true,
                prefixIcon: Padding(
                  padding: padding(left: 12, right: 8),
                  child: ImageAssetCustom(imagePath: Assets.icons.location.path, size: 20),
                ),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                titleText: 'role'.tr,
                controller: controller.roleController,
                borderRadius: 12,
                readOnly: true,
                isRequired: false,
                prefixIcon: _prefixIcon(Assets.icons.tagUser.path),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                titleText: 'cccd'.tr,
                controller: controller.cccdController,
                borderRadius: 12,
                readOnly: true,
                isRequired: false,
                prefixIcon: _prefixIcon(Assets.icons.clipboardText.path),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                titleText: 'birth_date'.tr,
                controller: controller.birthDateController,
                borderRadius: 12,
                readOnly: true,
                isRequired: false,
                prefixIcon: _prefixIcon(Assets.icons.calendarDays.path),
              ),
            ],
          ),
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
