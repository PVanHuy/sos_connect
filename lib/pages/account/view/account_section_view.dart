import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/account/account_controller.dart';
import 'package:sos_connect/pages/account/widget/item_row_widget.dart';
import 'package:sos_connect/pages/personal_information/personal_information_parameter.dart';
import 'package:sos_connect/pages/rescue_posts/rescue_posts_parameter.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/rescue_support_type_utils.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class AccountSectionView extends GetView<AccountController> {
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
            child: Text('account'.tr, style: StyleThemeData.size14Weight700()),
          ),
          ItemRowWidget(
            icon: Assets.icons.userSquare,
            label: 'personal_info'.tr,
            onTap: () => Get.toNamed(
              Routes.PERSONAL_INFORMATION,
              arguments: PersonalInformationParameter(
                userModel: controller.dashboardController.userModel.value,
              ),
            ),
          ),
          ItemRowWidget(
            icon: Assets.icons.message,
            label: 'your_support_requests'.tr,
            isLast: true,
            onTap: () => Get.toNamed(
              Routes.RESCUE_POSTS,
              arguments: const RescuePostsParameter(type: RescueListType.yourRequests),
            ),
          ),
        ],
      ),
    );
  }
}
