import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/noti/view/app_noti_view.dart';
import 'package:sos_connect/pages/noti/view/system_noti_view.dart';
import 'package:sos_connect/pages/noti/widget/noti_tab_bar_widget.dart';
import 'package:sos_connect/utils/noti_tab_type_utils.dart';
import 'package:sos_connect/widget/default_app_bar.dart';

class NotiPage extends GetWidget<NotiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: DefaultAppBar(title: 'notifications'.tr, backButton: false),
      body: Column(
        children: [
          Obx(
            () => NotiTabBarWidget(
              selectedTab: controller.selectedTab.value,
              onSelect: controller.selectTab,
            ),
          ),
          Expanded(
            child: Obx(() {
              return switch (controller.selectedTab.value) {
                NotiTabType.system => const SystemNotiView(),
                NotiTabType.app => const AppNotiView(),
              };
            }),
          ),
        ],
      ),
    );
  }
}
