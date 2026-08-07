import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/image_asset_custom.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class DashboardPage extends GetWidget<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: controller.animateToTab,
        children: controller.pages,
      ),
      bottomNavigationBar: Obx(_buildBottomNavigationBar),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: padding(top: 12, bottom: 16),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        border: Border(top: BorderSide(color: appTheme.grayE5Color)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildNavItem(
              index: 0,
              iconInactivePath: Assets.images.map.path,
              iconActivePath: Assets.images.map.path,
              label: 'map'.tr,
              inactiveColor: appTheme.gray8FColor,
            ),
            _buildNavItem(
              index: 1,
              iconInactivePath: Assets.icons.conceptSharing.path,
              iconActivePath: Assets.icons.conceptSharingBold.path,
              label: 'survival'.tr,
            ),
            _buildNavItem(
              index: 2,
              iconInactivePath: Assets.icons.message.path,
              iconActivePath: Assets.icons.messageBold.path,
              label: 'support'.tr,
            ),
            _buildNavItem(
              index: 3,
              iconInactivePath: Assets.icons.notification.path,
              iconActivePath: Assets.icons.notificationBold.path,
              label: 'news'.tr,
              badgeCount: controller.notificationCount.value,
            ),
            _buildNavItem(
              index: 4,
              iconInactivePath: Assets.icons.user.path,
              iconActivePath: Assets.icons.userBold.path,
              label: 'account'.tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconInactivePath,
    required String iconActivePath,
    required String label,
    double iconSize = 24,
    Color? inactiveColor,
    int badgeCount = 0,
  }) {
    final isActive = controller.currentPage.value == index;
    final defaultInactive = inactiveColor ?? appTheme.gray8FColor;
    final iconColor = isActive ? appTheme.appColor : defaultInactive;
    final textColor = isActive ? appTheme.appColor : defaultInactive;
    final iconPath = isActive ? iconActivePath : iconInactivePath;
    final badgeText = badgeCount > 99 ? '99+' : '$badgeCount';

    return Expanded(
      child: InkWell(
        onTap: () => controller.goToTab(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 4.h,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ImageAssetCustom(imagePath: iconPath, size: iconSize, color: iconColor),
                if (badgeCount > 0)
                  Positioned(
                    right: -8.w,
                    top: -4.h,
                    child: Container(
                      constraints: BoxConstraints(minWidth: 16.w),
                      padding: padding(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(color: appTheme.red55Color, borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        badgeText,
                        textAlign: TextAlign.center,
                        style: StyleThemeData.size10Weight700(color: appTheme.whiteColor, height: 1.2),
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              label,
              style: isActive
                  ? StyleThemeData.size10Weight700(color: textColor)
                  : StyleThemeData.size10Weight400(color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
