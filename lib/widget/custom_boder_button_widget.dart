import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

import '../../main.dart';

class CustomBorderButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final EdgeInsets? margin;
  final double radius;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final TextStyle? styleButtonText;
  final EdgeInsets? paddingButton;
  final bool hasSafeArea;
  final bool isFullWidth;

  const CustomBorderButtonWidget({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.margin,
    this.radius = 50,
    this.icon,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.styleButtonText,
    this.paddingButton,
    this.hasSafeArea = true,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return hasSafeArea
        ? SafeArea(top: false, child: _buildBorderButtonWidget(context))
        : _buildBorderButtonWidget(context);
  }

  Widget _buildBorderButtonWidget(BuildContext context) {
    return Padding(
      padding: margin == null ? .zero : margin!,
      child: InkWell(
        onTap: isLoading
            ? null
            : () {
                FocusScope.of(context).unfocus();
                onPressed?.call();
              },
        borderRadius: .circular(radius),
        child: Container(
          width: isFullWidth ? .infinity : null,
          padding: paddingButton ?? padding(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: .circular(radius),
            border: Border.all(
              width: 1.w,
              color: onPressed == null ? appTheme.lavenderColor : color ?? appTheme.grayE6Color,
            ),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  mainAxisSize: isFullWidth ? .max : .min,
                  children: [
                    SizedBox(
                      height: 15.w,
                      width: 15.w,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(textColor ?? appTheme.appColor),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text('loading'.tr, style: StyleThemeData.size16Weight700(color: textColor ?? appTheme.appColor)),
                  ],
                )
              : Row(
                  mainAxisAlignment: .center,
                  mainAxisSize: isFullWidth ? .max : .min,
                  children: [
                    icon != null ? Padding(padding: padding(right: 8), child: icon) : const SizedBox(),
                    Text(
                      buttonText,
                      textAlign: .center,
                      style:
                          styleButtonText ??
                          StyleThemeData.size14Weight600(
                            color:
                                (onPressed != null ? textColor : appTheme.gray86Color) ??
                                (onPressed != null ? appTheme.whiteColor : appTheme.gray86Color),
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
