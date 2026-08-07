import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SosTypeCardWidget extends StatelessWidget {
  const SosTypeCardWidget({
    super.key,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.background,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String iconPath;
  final Color color;
  final Color background;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(12),
      child: Container(
        width: double.infinity,
        padding: padding(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: .circular(12),
          border: Border.all(color: isSelected ? color : appTheme.transparentColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 28.w, height: 28.w, colorFilter: .mode(color, BlendMode.srcIn)),
            SizedBox(height: 4.h),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: StyleThemeData.size10Weight700(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
