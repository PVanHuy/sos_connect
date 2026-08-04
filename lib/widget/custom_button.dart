import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

import '../../main.dart';

class CustomButton extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final EdgeInsets? margin;
  final double radius;
  final Widget? icon;
  final Color? color;
  final Gradient? gradient;
  final Color? textColor;
  final TextStyle? styleButtonText;
  final bool isLoading;
  final EdgeInsets? paddingButton;
  final bool hasSafeArea;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.styleButtonText,
    this.margin,
    this.radius = 50,
    this.icon,
    this.color,
    this.gradient,
    this.textColor,
    this.isLoading = false,
    this.paddingButton,
    this.hasSafeArea = true,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return hasSafeArea ? SafeArea(top: false, child: _buildButtonWidget(context)) : _buildButtonWidget(context);
  }

  Widget _buildButtonWidget(BuildContext context) {
    final resolvedGradient = color != null ? null : (gradient ?? AppGradient.purpleFFAndPurpleFFGradient);
    final loadingColor = textColor ?? appTheme.whiteColor;

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
          padding: paddingButton ?? padding(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: .circular(radius),
            color: onPressed == null && !isLoading ? appTheme.grayF5Color : (resolvedGradient != null ? null : color),
            gradient: onPressed != null || isLoading ? resolvedGradient : null,
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
                        valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text('loading'.tr, style: StyleThemeData.size14Weight600(color: loadingColor)),
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
                            color: textColor ?? (onPressed != null ? appTheme.whiteColor : appTheme.gray86Color),
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
