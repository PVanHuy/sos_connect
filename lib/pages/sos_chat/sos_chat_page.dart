import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/sos_chat/sos_chat_controller.dart';
import 'package:sos_connect/pages/sos_chat/widget/sos_chat_bubble.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/widget/custom_image_widget.dart';
import 'package:sos_connect/widget/full_photo_viewer.dart';
import 'package:sos_connect/widget/loading_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SosChatPage extends GetWidget<SosChatController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appTheme.whiteColor,
        appBar: AppBar(
          backgroundColor: appTheme.whiteColor,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Assets.icons.arrowLeft.svg(
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(appTheme.blackColor, BlendMode.srcIn),
            ),
          ),
          title: Obx(() {
            final avatar = controller.otherPartyAvatar;
            return Row(
              children: [
                InkWell(
                  onTap: avatar.isEmpty ? null : () => FullPhotoViewer.open(context, assets: [avatar]),
                  borderRadius: BorderRadius.circular(1000),
                  child: CustomImageWidget(imageUrl: avatar, size: 40.w, noImage: false),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.title, style: StyleThemeData.size16Weight700(), overflow: TextOverflow.ellipsis),
                      Text('sos_chat_subtitle'.tr, style: StyleThemeData.size12Weight400(color: appTheme.gray94Color)),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Obx(() {
                    if (controller.isLoading.value && controller.messages.isEmpty) {
                      return const LoadingWidget();
                    }

                    if (controller.messages.isEmpty) {
                      return Center(
                        child: Text(
                          'sos_chat_empty'.tr,
                          style: StyleThemeData.size14Weight400(color: appTheme.gray83Color),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        controller: controller.scrollController,
                        padding: padding(all: 16),
                        itemCount: controller.messages.length + (controller.isLoadingMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (controller.isLoadingMore.value && index == controller.messages.length) {
                            return Padding(
                              padding: padding(vertical: 12),
                              child: Center(
                                child: SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(appTheme.appColor),
                                  ),
                                ),
                              ),
                            );
                          }

                          final message = controller.messages[index];
                          return SosChatBubble(message: message, isMine: controller.isMine(message));
                        },
                      ),
                    );
                  }),
                  Obx(
                    () => controller.isShowScrollToBottom.value
                        ? Positioned(bottom: 12, right: 16, child: _buildScrollToBottom())
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Container(
              padding: padding(all: 16),
              decoration: BoxDecoration(
                color: appTheme.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: appTheme.blackColor.withSafeOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: appTheme.grayF1Color, borderRadius: BorderRadius.circular(24)),
                        child: TextField(
                          controller: controller.messageController,
                          decoration: InputDecoration(
                            hintText: 'sos_chat_hint'.tr,
                            hintStyle: StyleThemeData.size14Weight400(color: appTheme.gray94Color),
                            border: InputBorder.none,
                            contentPadding: padding(horizontal: 16, vertical: 12),
                            counterText: '',
                          ),
                          style: StyleThemeData.size14Weight400(),
                          maxLines: null,
                          maxLength: AppConstants.maxSosChatMessageLength,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => controller.sendMessage(),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Obx(() {
                      final canSend = controller.inputValue.value.trim().isNotEmpty && !controller.isSending.value;
                      return InkWell(
                        onTap: canSend ? controller.sendMessage : null,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: canSend ? AppGradient.gradientBlueGenderMale : null,
                            color: canSend ? null : appTheme.grayE6Color,
                          ),
                          child: Center(
                            child: controller.isSending.value
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(appTheme.gray94Color),
                                    ),
                                  )
                                : Assets.icons.send.svg(
                                    width: 20.w,
                                    height: 20.w,
                                    colorFilter: ColorFilter.mode(appTheme.whiteColor, BlendMode.srcIn),
                                  ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollToBottom() {
    return InkWell(
      onTap: controller.scrollToBottom,
      borderRadius: BorderRadius.circular(8),
      child: Obx(() {
        if (controller.isShowNewMessScroll.value) {
          return Container(
            padding: padding(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: appTheme.whiteColor,
              boxShadow: [
                BoxShadow(color: appTheme.blackColor.withSafeOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('sos_chat_new_messages'.tr, style: StyleThemeData.size12Weight700(color: appTheme.appColor)),
                SizedBox(width: 5.w),
                Assets.icons.arrowDown.svg(
                  width: 16.w,
                  height: 16.w,
                  colorFilter: ColorFilter.mode(appTheme.appColor, BlendMode.srcIn),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: padding(all: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appTheme.whiteColor,
            boxShadow: [
                BoxShadow(color: appTheme.blackColor.withSafeOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Assets.icons.arrowDown.svg(
            width: 20.w,
            height: 20.w,
            colorFilter: ColorFilter.mode(appTheme.blackColor, BlendMode.srcIn),
          ),
        );
      }),
    );
  }
}
