import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ItemRowWidget extends StatelessWidget {
  const ItemRowWidget({
    super.key,
    required this.icon,
    required this.label,
    this.isLast = false,
    this.onTap,
    this.trailing,
    this.iconColor,
  });

  final SvgGenImage icon;
  final String label;
  final bool isLast;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appTheme.transparentColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
            : BorderRadius.zero,
        child: Padding(
          padding: padding(all: 12),
          child: Row(
            spacing: 8.w,
            children: [
              SvgPicture.asset(
                icon.path,
                width: 24.w,
                height: 24.w,
                colorFilter: .mode(iconColor ?? appTheme.appColor, BlendMode.srcIn),
              ),
              Expanded(child: Text(label, style: StyleThemeData.size14Weight400())),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
