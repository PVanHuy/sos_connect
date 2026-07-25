import 'package:flutter/material.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/survival/survival_guide_model.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ItemSurvivalGuideWidget extends StatelessWidget {
  const ItemSurvivalGuideWidget({
    super.key,
    required this.guide,
    this.onTap,
  });

  final SurvivalGuideModel guide;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = guide.category.style;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: padding(all: 12),
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appTheme.grayE5Color),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: padding(all: 10),
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ImageAssetCustom(
                imagePath: guide.category.iconPath,
                size: 20,
                color: style.text,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guide.title, style: StyleThemeData.size14Weight700()),
                  SizedBox(height: 4.h),
                  Text(
                    guide.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: StyleThemeData.size12Weight400(color: appTheme.gray83Color),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            ImageAssetCustom(
              imagePath: Assets.icons.arrowRight.path,
              size: 16,
              color: appTheme.gray83Color,
            ),
          ],
        ),
      ),
    );
  }
}
