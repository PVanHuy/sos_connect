import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/full_photo_viewer.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
// Backup Google Maps:
// import 'package:sos_connect/utils/route_launcher_util.dart';

class ItemSupportSosWidget extends StatelessWidget {
  const ItemSupportSosWidget({
    super.key,
    required this.type,
    required this.urgencyScore,
    required this.time,
    required this.description,
    required this.address,
    required this.acceptButtonText,
    this.imageUrl = '',
    this.showAcceptButton = true,
    this.isAccepting = false,
    this.onAccept,
    this.onViewOnMap,
  });

  final SosEmergencyType type;
  final String urgencyScore;
  final String time;
  final String description;
  final String address;
  final String acceptButtonText;
  final String imageUrl;
  final bool showAcceptButton;
  final bool isAccepting;
  final VoidCallback? onAccept;
  final VoidCallback? onViewOnMap;

  void _openMap() {
    // Backup: mở Google Maps theo địa chỉ
    // RouteLauncherUtil.openGoogleMapByAddress(address);
    onViewOnMap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final style = type.style;

    return Container(
      padding: padding(all: 12),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appTheme.grayE5Color),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text('${type.title} - $time', style: StyleThemeData.size14Weight700(color: style.text)),
              ),
              Container(
                padding: padding(all: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: style.text, shape: BoxShape.circle),
                child: Text(urgencyScore, style: StyleThemeData.size10Weight700(color: appTheme.whiteColor)),
              ),
            ],
          ),
          if (imageUrl.isNotEmpty) ...[
            SizedBox(height: 12.h),
            InkWell(
              onTap: () => FullPhotoViewer.open(context, assets: [imageUrl]),
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 180.h,
                borderRadius: 10,
                fit: BoxFit.cover,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: padding(all: 12),
            decoration: BoxDecoration(color: appTheme.grayF6Color, borderRadius: BorderRadius.circular(8)),
            child: Text(description.isNotEmpty ? description : 'no_data'.tr, style: StyleThemeData.size14Weight400()),
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: _openMap,
            child: Row(
              children: [
                ImageAssetCustom(imagePath: Assets.icons.localTwo.path, size: 16),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    address,
                    style: StyleThemeData.size12Weight400(
                      color: appTheme.appColor,
                    ).copyWith(decoration: TextDecoration.underline, decorationColor: appTheme.appColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonText: 'view_on_map'.tr,
                  color: appTheme.greenECColor,
                  textColor: appTheme.green47Color,
                  hasSafeArea: false,
                  onPressed: _openMap,
                ),
              ),
              if (showAcceptButton) ...[
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomButton(
                    buttonText: acceptButtonText,
                    hasSafeArea: false,
                    isLoading: isAccepting,
                    onPressed: isAccepting ? null : onAccept,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
