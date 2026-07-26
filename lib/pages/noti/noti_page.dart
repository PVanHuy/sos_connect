import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/noti/widget/item_noti_widget.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotiPage extends GetWidget<NotiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'notifications'.tr),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            ItemNotiWidget(
              title: '🚀 Bạn Say Tôi Lái ra mắt tính năng mới',
              time: '2 giờ trước',
              content: 'Trải nghiệm nhanh hơn, mượt hơn. Khám phá ngay hôm nay!',
              isRead: false,
              onTap: () {},
            ),
            ItemNotiWidget(
              title: '🚀 Bạn Say Tôi Lái ra mắt tính năng mới',
              time: '2 giờ trước',
              content: 'Trải nghiệm nhanh hơn, mượt hơn. Khám phá ngay hôm nay!',
              isRead: true,
              onTap: () {},
            ),
            ItemNotiWidget(
              title: '🚀 Bạn Say Tôi Lái ra mắt tính năng mới',
              time: '2 giờ trước',
              content: 'Trải nghiệm nhanh hơn, mượt hơn. Khám phá ngay hôm nay!',
              isRead: true,
              onTap: () {},
            ),
            NoDataWidget(title: 'notifications_empty_title'.tr, description: 'notifications_empty_subtitle'.tr),
          ],
        ),
      ),
    );
  }
}
