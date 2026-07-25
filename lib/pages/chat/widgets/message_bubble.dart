import 'package:flutter/material.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/chat/models/chat_message_model.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[_buildAvatar(), SizedBox(width: 8.w)],
          Flexible(
            child: Container(
              padding: padding(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? appTheme.blueE5Color : appTheme.grayF1Color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 16),
                ),
              ),
              child: Text(
                message.text,
                style: StyleThemeData.size14Weight400(
                  color: message.isUser ? appTheme.whiteColor : appTheme.blackColor,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[SizedBox(width: 8.w), _buildAvatar(isUser: true)],
        ],
      ),
    );
  }

  Widget _buildAvatar({bool isUser = false}) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: isUser ? appTheme.blueE5Color : appTheme.grayE6Color),
      child: Center(
        child: Text(
          isUser ? 'B' : 'AI',
          style: StyleThemeData.size12Weight700(color: isUser ? appTheme.whiteColor : appTheme.blackColor),
        ),
      ),
    );
  }
}
