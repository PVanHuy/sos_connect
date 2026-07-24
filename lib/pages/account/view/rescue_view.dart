import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/account/account_controller.dart';
import 'package:sos_connect/pages/account/widget/item_row_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class RescueView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding(horizontal: 16, top: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: appTheme.blackColor.withSafeOpacity(.1), blurRadius: 24, offset: Offset.zero),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding(all: 12),
            child: Text('rescue'.tr, style: StyleThemeData.size14Weight700()),
          ),
          ItemRowWidget(icon: Assets.icons.driver, label: 'register_rescue_team'.tr, onTap: () {}),
          ItemRowWidget(icon: Assets.icons.task, label: 'rescue_receiving'.tr, onTap: () {}),
          ItemRowWidget(
            icon: Assets.icons.clipboardText,
            label: 'rescue_received'.tr,
            isLast: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
