import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/chat/chat_controller.dart';
import 'package:sos_connect/pages/chat/widgets/message_bubble.dart';
import 'package:sos_connect/pages/chat/widgets/typing_indicator.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class ChatPage extends GetWidget<ChatController> {
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
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Assets.icons.arrowLeft.svg(
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(appTheme.blackColor, BlendMode.srcIn),
            ),
          ),
          title: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.blueE5Color),
                child: Center(
                  child: Text('AI', style: StyleThemeData.size14Weight600(color: appTheme.whiteColor)),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('chat_assistant'.tr, style: StyleThemeData.size16Weight700()),
                  Text('chat_online'.tr, style: StyleThemeData.size12Weight400(color: appTheme.gray94Color)),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: padding(all: 16),
                  itemCount: controller.messages.length + (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.messages.length && controller.isLoading.value) {
                      return const TypingIndicator();
                    }
                    return MessageBubble(message: controller.messages[index]);
                  },
                );
              }),
            ),
            Container(
              padding: padding(all: 16),
              decoration: BoxDecoration(
                color: appTheme.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: appTheme.blackColor.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      if (controller.messages.length <= 1 && !controller.isLoading.value) {
                        final questions = controller.suggestedQuestions;
                        final firstRowQuestions = questions.take((questions.length / 2).ceil()).toList();
                        final secondRowQuestions = questions.skip((questions.length / 2).ceil()).toList();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 40.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: firstRowQuestions.length,
                                itemBuilder: (context, index) {
                                  final question = firstRowQuestions[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: InkWell(
                                      onTap: () => controller.selectSuggestedQuestion(question),
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: padding(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: appTheme.grayF1Color,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: appTheme.blueBFFColor.withValues(alpha: 0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            question,
                                            style: StyleThemeData.size12Weight400(color: appTheme.blackColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (secondRowQuestions.isNotEmpty) ...[
                              SizedBox(height: 8.h),
                              SizedBox(
                                height: 40.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: secondRowQuestions.length,
                                  itemBuilder: (context, index) {
                                    final question = secondRowQuestions[index];
                                    return Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: InkWell(
                                        onTap: () => controller.selectSuggestedQuestion(question),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: padding(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: appTheme.grayF1Color,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: appTheme.blueBFFColor.withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              question,
                                              style: StyleThemeData.size12Weight400(color: appTheme.blackColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: appTheme.grayF1Color,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: controller.messageController,
                              decoration: InputDecoration(
                                hintText: 'chat_type_message'.tr,
                                hintStyle: StyleThemeData.size14Weight400(color: appTheme.gray94Color),
                                border: InputBorder.none,
                                contentPadding: padding(horizontal: 16, vertical: 12),
                              ),
                              style: StyleThemeData.size14Weight400(),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => controller.sendMessage(),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Obx(() {
                          return InkWell(
                            onTap: controller.isLoading.value ? null : controller.sendMessage,
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: controller.isLoading.value ? null : AppGradient.gradientBlueGenderMale,
                                color: controller.isLoading.value ? appTheme.grayE6Color : null,
                              ),
                              child: Center(
                                child: controller.isLoading.value
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
