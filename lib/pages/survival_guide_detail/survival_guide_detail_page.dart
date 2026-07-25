import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/survival/survival_guide_model.dart';
import 'package:sos_connect/pages/survival_guide_detail/survival_guide_detail_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SurvivalGuideDetailPage extends GetWidget<SurvivalGuideDetailController> {
  @override
  Widget build(BuildContext context) {
    final guide = controller.guide;

    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: DefaultAppBar(title: guide?.title ?? 'survival'.tr, centerTitle: false, backIconOther: true),
      body: guide == null
          ? const NoDataWidget(isShowDes: false)
          : SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: padding(horizontal: 16, top: 12, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: padding(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: guide.category.style.background,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      guide.category.title,
                      style: StyleThemeData.size12Weight700(color: guide.category.style.text),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(guide.summary, style: StyleThemeData.size14Weight400(color: appTheme.gray83Color)),
                  SizedBox(height: 20.h),
                  Text('survival_steps'.tr, style: StyleThemeData.size16Weight700()),
                  SizedBox(height: 12.h),
                  ...List.generate(guide.steps.length, (index) {
                    final step = guide.steps[index];
                    return Padding(
                      padding: padding(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28.w,
                            height: 28.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: guide.category.style.background, shape: BoxShape.circle),
                            child: Text(
                              '${index + 1}',
                              style: StyleThemeData.size12Weight700(color: guide.category.style.text),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(child: Text(step, style: StyleThemeData.size14Weight400())),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
