import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
    this.height,
    this.titleBtn = '',
    this.onTap,
    this.isScroll = false,
    this.isShowDes = true,
    this.imageWidget,
    this.title,
    this.description,
    this.titleStyle,
    this.descriptionStyle,
  });

  final double? height;
  final String titleBtn;
  final VoidCallback? onTap;
  final bool isScroll;
  final bool isShowDes;
  final Widget? imageWidget;
  final String? title;
  final String? description;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  @override
  Widget build(BuildContext context) {
    return isScroll == true
        ? CustomScrollView(slivers: [SliverFillRemaining(child: _buildContentWidegt())])
        : _buildContentWidegt();
  }

  Widget _buildContentWidegt() {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          SizedBox(height: height),
          imageWidget ?? Assets.images.emptyNoti.image(width: 147.w, height: 137.h),
          SizedBox(height: 12.h),
          Column(
            crossAxisAlignment: .center,
            children: [
              Text(title ?? 'no_data'.tr, style: titleStyle ?? StyleThemeData.size16Weight700(), textAlign: .center),
              SizedBox(height: 8.h),
              if (isShowDes)
                Text(
                  description ?? 'no_data_description'.tr,
                  style: descriptionStyle ?? StyleThemeData.size12Weight400(color: appTheme.gray83Color),
                  textAlign: .center,
                ),
              if (onTap != null) ...[
                SizedBox(height: 12.h),
                CustomButton(
                  buttonText: titleBtn,
                  hasSafeArea: false,
                  isFullWidth: false,
                  paddingButton: padding(horizontal: 56, vertical: 12),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
