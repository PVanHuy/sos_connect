import 'package:flutter/material.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ItemBorderWidget extends StatelessWidget {
  const ItemBorderWidget({
    super.key,
    required this.code,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.borderLeftColor,
    required this.infoRows,
    this.borderRadius = 8,
    this.onTap,
  });

  final String code;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final Color borderLeftColor;
  final List<InfoItemRow> infoRows;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(borderRadius),
      child: Container(
        padding: padding(all: 12),
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          borderRadius: .circular(borderRadius),
          border: Border(left: BorderSide(color: borderLeftColor, width: 10)),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Expanded(child: Text(code, style: StyleThemeData.size16Weight700())),
                Container(
                  padding: padding(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(color: statusColor, borderRadius: .circular(50)),
                  child: Text(status, style: StyleThemeData.size12Weight700(color: statusTextColor)),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Column(
              spacing: 8.h,
              children: infoRows
                  .map(
                    (e) => Row(
                      spacing: 12.w,
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .center,
                      children: [
                        Row(
                          children: [
                            e.icon,
                            SizedBox(width: 8.w),
                            Text(e.title, style: StyleThemeData.size14Weight400()),
                          ],
                        ),
                        Flexible(
                          child: Text(
                            e.content,
                            textAlign: .right,
                            style: StyleThemeData.size14Weight600(),
                            overflow: .ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItemRow {
  final Widget icon;
  final String title;
  final String content;
  final Color? iconColorFilter;
  InfoItemRow({required this.icon, required this.title, required this.content, this.iconColorFilter});
}
