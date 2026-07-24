import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/account/account_controller.dart';
import 'package:sos_connect/resourese/service/localization_service.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/app_enums.dart';
import 'package:sos_connect/widget/app_radio_view.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

void showSelectLanguageDialog(AccountController controller) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Padding(
        padding: padding(horizontal: 16),
        child: Dialog(
          backgroundColor: appTheme.whiteColor,
          insetPadding: .zero,
          shape: RoundedRectangleBorder(borderRadius: .circular(12)),
          child: Padding(
            padding: padding(top: 16),
            child: Column(
              mainAxisSize: .min,
              spacing: 21.h,
              children: [
                Padding(
                  padding: padding(horizontal: 16),
                  child: Align(
                    alignment: .centerLeft,
                    child: Text('language'.tr, style: StyleThemeData.size16Weight700()),
                  ),
                ),

                Column(
                  children: LocalizationService.supportedLanguage.map((e) {
                    return Padding(
                      padding: padding(bottom: 21),
                      child: itemLanguageWidget(
                        title: e.title,
                        assetName: e.flagAsset,
                        isSelected: LocalizationService.language == e,
                        onTap: () {
                          controller.changeLanguage(e);
                          Get.back();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget itemLanguageWidget({
  required String assetName,
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: padding(vertical: 8, horizontal: 20),
      child: Row(
        spacing: 12.w,
        children: [
          ImageAssetCustom(imagePath: assetName, size: 24),
          Text(title, style: StyleThemeData.size14Weight400()),
          const Spacer(),
          AppRadioView(isSelected: isSelected, backgroundColor: appTheme.appColor),
        ],
      ),
    ),
  );
}
