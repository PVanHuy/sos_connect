import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/rescue_posts/rescue_posts_controller.dart';
import 'package:sos_connect/pages/rescue_posts/widget/item_rescue_post_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/rescue_support_type_utils.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class RescuePostsPage extends GetWidget<RescuePostsController> {
  @override
  Widget build(BuildContext context) {
    final showSafeButton = controller.listType.showSafeButton;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: AppGradient.whiteAndBlueF4Gradient),
        child: Column(
          children: [
            DefaultAppBar(
              title: controller.listType.title,
              titleStyle: StyleThemeData.size20Weight700(color: appTheme.whiteColor),
              centerTitle: false,
              backgroundColor: appTheme.transparentColor,
              backIconOther: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: padding(horizontal: 16, top: 8, bottom: 24),
                child: Column(
                  spacing: 12.h,
                  children: [
                    if (controller.listType == RescueListType.yourRequests) ...[
                      ItemRescuePostWidget(
                        supportType: 'support_type_medical'.tr,
                        supportTypeColor: appTheme.red38Color,
                        supportTypeBgColor: appTheme.redF4Color,
                        time: 'Đăng 2 giờ trước',
                        remainingTime: 'Còn 22:00:00',
                        description: 'Cần hỗ trợ y tế khẩn cấp cho người già bị sốt cao, khó thở.',
                        address: '12 Nguyễn Trãi, Thanh Xuân, Hà Nội',
                        phone: '0987654321',
                        teamName: 'Đội cứu hộ Hà Nội 1',
                        managerName: 'Nguyễn Văn A',
                        managerPhone: '0901234567',
                        showSafeButton: showSafeButton,
                        onMarkAsSafe: controller.markAsSafe,
                      ),
                      ItemRescuePostWidget(
                        supportType: 'support_type_food'.tr,
                        supportTypeColor: appTheme.greenColor,
                        supportTypeBgColor: appTheme.bgGreenColor,
                        time: 'Đăng 5 giờ trước',
                        remainingTime: 'Còn 19:00:00',
                        description: 'Gia đình 4 người đang bị cô lập, cần thực phẩm và nước uống.',
                        address: '45 Lê Lợi, Quận 1, TP.HCM',
                        phone: '0977123456',
                        teamName: 'Đội tình nguyện miền Trung',
                        managerName: 'Trần Thị B',
                        managerPhone: '0912345678',
                        showSafeButton: showSafeButton,
                        onMarkAsSafe: controller.markAsSafe,
                      ),
                    ] else if (controller.listType == RescueListType.receiving) ...[
                      ItemRescuePostWidget(
                        supportType: 'support_type_need_rescue'.tr,
                        supportTypeColor: appTheme.appColor,
                        supportTypeBgColor: appTheme.lavenderColor,
                        time: 'Đăng 1 giờ trước',
                        remainingTime: 'Còn 23:00:00',
                        description: 'Người bị kẹt trên mái nhà do nước lũ dâng cao, cần cứu hộ ngay.',
                        address: 'Thôn 3, xã Phú An, Thừa Thiên Huế',
                        phone: '0966555444',
                        teamName: 'Đội cứu hộ Hà Nội 1',
                        managerName: 'Nguyễn Văn A',
                        managerPhone: '0901234567',
                      ),
                      ItemRescuePostWidget(
                        supportType: 'support_type_medical'.tr,
                        supportTypeColor: appTheme.red38Color,
                        supportTypeBgColor: appTheme.redF4Color,
                        time: 'Đăng 8 giờ trước',
                        remainingTime: 'Còn 16:00:00',
                        description: 'Trẻ em bị thương ở chân, cần sơ cứu và đưa đến trạm y tế gần nhất.',
                        address: '78 Trần Phú, Nha Trang',
                        phone: '0933111222',
                        teamName: 'Đội tình nguyện miền Trung',
                        managerName: 'Trần Thị B',
                        managerPhone: '0912345678',
                      ),
                    ] else ...[
                      ItemRescuePostWidget(
                        supportType: 'support_type_food'.tr,
                        supportTypeColor: appTheme.greenColor,
                        supportTypeBgColor: appTheme.bgGreenColor,
                        time: 'Đăng 1 ngày trước',
                        remainingTime: 'completed'.tr,
                        description: 'Đã nhận hỗ trợ thực phẩm và nước uống cho hộ gia đình bị ảnh hưởng.',
                        address: '21 Hai Bà Trưng, Đà Nẵng',
                        phone: '0944555666',
                        teamName: 'Đội cứu hộ Hà Nội 1',
                        managerName: 'Nguyễn Văn A',
                        managerPhone: '0901234567',
                      ),
                      ItemRescuePostWidget(
                        supportType: 'support_type_need_rescue'.tr,
                        supportTypeColor: appTheme.appColor,
                        supportTypeBgColor: appTheme.lavenderColor,
                        time: 'Đăng 2 ngày trước',
                        remainingTime: 'completed'.tr,
                        description: 'Đã đưa người bị nạn ra khỏi khu vực nguy hiểm an toàn.',
                        address: 'Khu phố 5, Thủ Đức, TP.HCM',
                        phone: '0922333444',
                        teamName: 'Đội tình nguyện miền Trung',
                        managerName: 'Trần Thị B',
                        managerPhone: '0912345678',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
