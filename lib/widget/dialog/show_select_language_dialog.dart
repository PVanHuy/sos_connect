import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/resourese/service/localization_service.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/app_enums.dart';
import 'package:sos_connect/widget/app_radio_view.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

void showSelectLanguageDialog() {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Padding(
        padding: padding(horizontal: 120),
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
                          LocalizationService.changeLanguage(e);
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
  return _LanguageItemWidget(assetName: assetName, title: title, isSelected: isSelected, onTap: onTap);
}

class _LanguageItemWidget extends StatefulWidget {
  const _LanguageItemWidget({
    required this.assetName,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String assetName;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_LanguageItemWidget> createState() => _LanguageItemWidgetState();
}

class _LanguageItemWidgetState extends State<_LanguageItemWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: padding(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: _isHovering ? appTheme.background.withSafeOpacity(.2) : appTheme.transparentColor,
          ),
          child: Row(
            spacing: 12.w,
            children: [
              ImageAssetCustom(imagePath: widget.assetName, size: 24),
              Text(widget.title, style: StyleThemeData.size14Weight400()),
              const Spacer(),
              AppRadioView(isSelected: widget.isSelected, backgroundColor: appTheme.appColor),
            ],
          ),
        ),
      ),
    );
  }
}
