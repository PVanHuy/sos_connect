import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class RescueInfoRowWidget extends StatelessWidget {
  const RescueInfoRowWidget({super.key, required this.icon, required this.text, this.onTap});

  final String icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(8),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          SvgPicture.asset(icon, width: 16.w, height: 16.w),
          SizedBox(width: 8.w),
          Expanded(child: Text(text, style: StyleThemeData.size12Weight400())),
        ],
      ),
    );
  }
}
