import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/account/account_controller.dart';
import 'package:sos_connect/pages/account/widget/item_row_widget.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/app_enums.dart';
import 'package:sos_connect/widget/dialog/show_select_language_dialog.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SettingsAccountView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding(horizontal: 16, top: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: .circular(12),
        boxShadow: [BoxShadow(color: appTheme.blackColor.withSafeOpacity(.1), blurRadius: 24, offset: Offset.zero)],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: padding(all: 12),
            child: Text('settings'.tr, style: StyleThemeData.size14Weight700()),
          ),
          ItemRowWidget(
            icon: Assets.icons.global,
            label: 'language'.tr,
            onTap: () => showSelectLanguageDialog(controller),
            trailing: Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(controller.currentLanguage.value.title, style: StyleThemeData.size12Weight400()),
                  SizedBox(width: 4.w),
                  SvgPicture.asset(Assets.icons.arrowDown.path, width: 16.w, height: 16.w),
                ],
              ),
            ),
          ),
          ItemRowWidget(
            icon: Assets.icons.lock,
            label: 'change_password'.tr,
            isLast: true,
            onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
          ),
        ],
      ),
    );
  }
}
