import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
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
  final double? titleSpacing;
  final bool backIconOther;
  final bool useProfileHeader;
  final String profileTitle;
  final String profileImageUrl;
  final bool showProfileImage;
  final VoidCallback? onTapAction;
  final Widget? actionIcon;
  final Color? backButtonBackgroundColor;
  final bool backButtonBoxShadow;
  final bool isBackIconOther;
  final bool isBackgroundIcon;

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
    this.titleSpacing,
    this.backIconOther = false,
    this.useProfileHeader = false,
    this.profileTitle = '',
    this.profileImageUrl = '',
    this.showProfileImage = true,
    this.onTapAction,
    this.actionIcon,
    this.backButtonBackgroundColor,
    this.backButtonBoxShadow = false,
    this.isBackIconOther = false,
    this.isBackgroundIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? appTheme.whiteColor,
      surfaceTintColor: appTheme.transparentColor,
      scrolledUnderElevation: 0,
      title: useProfileHeader
          ? Row(
              children: [
                SizedBox(width: 2.w),
                if (showProfileImage) ...[
                  Stack(
                    clipBehavior: .none,
                    children: [
                      CustomImageWidget(imageUrl: profileImageUrl, size: 46.w, noImage: false),
                      Positioned(
                        right: -1,
                        bottom: -1,
                        child: Container(
                          width: 14.w,
                          height: 14.w,
                          decoration: BoxDecoration(
                            color: appTheme.green49Color,
                            shape: .circle,
                            border: .all(color: appTheme.whiteColor, width: 1.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Text(profileTitle, overflow: .ellipsis, style: StyleThemeData.size16Weight700()),
                ),
              ],
            )
          : widgetText ?? Text(title, style: titleStyle ?? StyleThemeData.size16Weight700(color: colorTitle)),
      centerTitle: useProfileHeader ? false : centerTitle,
      leading: backButton
          ? IconButton(
              onPressed: () => onBackPressed != null ? onBackPressed!() : Get.back(),
              icon:
                  backIcon ??
                  Container(
                    padding: padding(all: 6),
                    decoration: BoxDecoration(
                      color: (isBackIconOther || isBackgroundIcon) ? appTheme.sliverColor : appTheme.whiteColor,
                      borderRadius: .circular(999),
                    ),
                    child: isBackIconOther
                        ? Assets.icons.arrowLeftOther.svg(width: 20.w, height: 20.w)
                        : Assets.icons.arrowLeft.svg(
                            width: 20.w,
                            height: 20.w,
                            colorFilter: colorIcon != null ? .mode(colorIcon!, .srcIn) : null,
                          ),
                  ),
            )
          : const SizedBox(),
      leadingWidth: backButton ? null : 0,
      elevation: 0,
      actions: useProfileHeader
          ? [
              IconButton(
                onPressed: onTapAction,
                icon: actionIcon ?? Assets.icons.callOther.svg(width: 24.w, height: 24.w),
              ),
              SizedBox(width: 8.w),
            ]
          : actions,
      titleSpacing: titleSpacing ?? ((useProfileHeader || !centerTitle) ? 0 : null),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, 50);
}
