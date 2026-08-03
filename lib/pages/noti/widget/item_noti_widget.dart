import 'package:flutter/material.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ItemNotiWidget extends StatelessWidget {
  const ItemNotiWidget({
    super.key,
    required this.title,
    required this.time,
    required this.content,
    this.isRead = false,
    this.onTap,
  });

  final String title;
  final String time;
  final String content;
  final bool isRead;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var textColor = isRead ? appTheme.grayColor : appTheme.blackColor;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.w,
          children: [
            Container(
              padding: padding(all: 12),
              decoration: BoxDecoration(
                gradient: AppGradient.gradientBlueAFFAndAppColorGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Assets.icons.notificationBold.svg(
                width: 24.w,
                height: 24.w,
                colorFilter: ColorFilter.mode(appTheme.whiteColor, BlendMode.srcIn),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.h,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.w,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: StyleThemeData.size16Weight700(color: textColor),
                        ),
                      ),
                      Text(time, style: StyleThemeData.size12Weight400(color: appTheme.grayColor)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          content,
                          overflow: TextOverflow.ellipsis,
                          style: StyleThemeData.size12Weight400(color: textColor),
                        ),
                      ),
                      if (!isRead) ...[
                        SizedBox(width: 12.w),
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(color: appTheme.red57Color, shape: BoxShape.circle),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
