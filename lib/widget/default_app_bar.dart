import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? titleStyle;
  final bool backButton;
  final Function? onBackPressed;
  final String? type;
  final bool centerTitle;
  final List<Widget> actions;
  final Widget? backIcon;
  final Color? backgroundColor;
  final Widget? widgetText;
  final Color? colorTitle;
  final Color? colorIcon;

  const DefaultAppBar({
    super.key,
    this.title = '',
    this.titleStyle,
    this.backButton = true,
    this.onBackPressed,
    this.type,
    this.centerTitle = true,
    this.actions = const [],
    this.backIcon,
    this.backgroundColor,
    this.widgetText,
    this.colorTitle,
    this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? appTheme.whiteColor,
      surfaceTintColor: appTheme.transparentColor,
      scrolledUnderElevation: 0,
      title: widgetText ?? Text(title, style: titleStyle ?? StyleThemeData.size16Weight700(color: colorTitle)),
      centerTitle: centerTitle,
      leading: backButton
          ? IconButton(
              onPressed: () => onBackPressed != null ? onBackPressed!() : Get.back(),
              icon: backIcon ?? ImageAssetCustom(imagePath: Assets.icons.arrowLeft.path, size: 24.w, color: colorIcon),
            )
          : const SizedBox(),
      leadingWidth: backButton ? null : 0,
      elevation: 0,
      actions: actions,
      titleSpacing: centerTitle ? null : 0,
    );
  }

  @override
  Size get preferredSize => Size(Get.width, 50);
}
