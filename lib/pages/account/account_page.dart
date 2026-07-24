import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/account/account_controller.dart';
import 'package:sos_connect/pages/account/view/account_section_view.dart';
import 'package:sos_connect/pages/account/view/rescue_view.dart';
import 'package:sos_connect/pages/account/view/settings_account_view.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class AccountPage extends GetWidget<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: AppGradient.whiteAndBlueF4Gradient),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: padding(top: 12, bottom: 24),
            child: SafeArea(
              child: Column(
                children: [
                  CustomImageWidget(
                    imageUrl: '',
                    size: 100.w,
                    showBoder: true,
                    colorBoder: appTheme.whiteColor,
                    borderWidth: 4,
                    noImage: false,
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => Text(controller.userName.value, style: StyleThemeData.size20Weight700())),
                  AccountSectionView(),
                  RescueView(),
                  SettingsAccountView(),
                  SizedBox(height: 24.h),
                  CustomButton(
                    margin: padding(horizontal: 16),
                    buttonText: 'logout'.tr,
                    icon: ImageAssetCustom(imagePath: Assets.icons.logout.path, size: 24, color: appTheme.whiteColor),
                    onPressed: () => showConfirmDialog(
                      title: 'logout'.tr,
                      content: 'logout_confirm_content'.tr,
                      titleBtn: 'logout'.tr,
                      onConfirm: controller.logout,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
