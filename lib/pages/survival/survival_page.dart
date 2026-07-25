import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/survival/survival_guide_model.dart';
import 'package:sos_connect/pages/survival/survival_controller.dart';
import 'package:sos_connect/pages/survival/widget/item_survival_guide_widget.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/floating_draggable_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SurvivalPage extends GetWidget<SurvivalController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: padding(horizontal: 16, top: 12, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('survival'.tr, style: StyleThemeData.size24Weight700()),
                      SizedBox(height: 4.h),
                      Text('survival_desc'.tr, style: StyleThemeData.size12Weight400(color: appTheme.gray83Color)),
                      SizedBox(height: 20.h),
                      ...SurvivalGuideCategory.values.map(_buildSection),
                    ],
                  ),
                ),
                FloatingDraggableWidget(
                  bodySize: constraints.biggest,
                  topPadding: 150.h,
                  bottomPadding: 20.h,
                  onTap: () => Get.toNamed(Routes.CHAT),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(SurvivalGuideCategory category) {
    final guides = controller.guidesByCategory(category);
    final style = category.style;

    return Padding(
      padding: padding(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(color: style.text, shape: BoxShape.circle),
              ),
              SizedBox(width: 8.w),
              Text(category.title, style: StyleThemeData.size16Weight700(color: style.text)),
            ],
          ),
          SizedBox(height: 12.h),
          ...guides.map(
            (guide) => Padding(
              padding: padding(bottom: 10),
              child: ItemSurvivalGuideWidget(guide: guide, onTap: () => controller.openGuide(guide)),
            ),
          ),
        ],
      ),
    );
  }
}
