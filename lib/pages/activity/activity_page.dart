import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/activity/activity_controller.dart';
import 'package:sos_connect/pages/activity/view/receiving_activity_view.dart';
import 'package:sos_connect/pages/activity/view/your_requests_activity_view.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/rescue_support_type_utils.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ActivityPage extends GetWidget<ActivityController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: appTheme.whiteColor,
        appBar: DefaultAppBar(
          title: controller.title,
          backButton: false,
          actions: controller.canSwitch
              ? [
                  Padding(
                    padding: padding(right: 8),
                    child: InkWell(
                      onTap: controller.toggleTab,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: padding(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: appTheme.sliverColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: appTheme.grayE5Color),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.icons.swap.svg(
                              width: 16.w,
                              height: 16.w,
                              colorFilter: ColorFilter.mode(appTheme.appColor, BlendMode.srcIn),
                            ),
                            SizedBox(width: 6.w),
                            Text('activity_switch'.tr, style: StyleThemeData.size12Weight700(color: appTheme.appColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              : const [],
        ),
        body: switch (controller.selectedTab.value) {
          RescueListType.receiving => const ReceivingActivityView(),
          RescueListType.yourRequests => const YourRequestsActivityView(),
          _ => const YourRequestsActivityView(),
        },
      ),
    );
  }
}
