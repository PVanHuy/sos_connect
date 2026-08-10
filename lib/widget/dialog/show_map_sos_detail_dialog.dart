import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/map/map_sos_item_model.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/pages/support/widget/item_support_sos_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

Future<void> showMapSosDetailDialog({
  required MapSosItemModel item,
  VoidCallback? onAccept,
  bool showAcceptButton = false,
}) async {
  await Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: appTheme.transparentColor,
      elevation: 0,
      insetPadding: padding(horizontal: 16),
      child: ItemSupportSosWidget(
        type: item.type,
        urgencyScore: item.urgencyScore,
        time: item.time,
        description: item.description,
        address: item.address,
        imageUrl: item.imageUrl,
        acceptButtonText: item.acceptButtonTextKey.tr,
        showAcceptButton: showAcceptButton,
        onViewOnMap: () => MapController.openInAppRoute(item.point),
        onAccept: showAcceptButton
            ? () {
                Get.back();
                onAccept?.call();
              }
            : null,
      ),
    ),
    barrierColor: appTheme.blackColor.withValues(alpha: 0.45),
  );
}
