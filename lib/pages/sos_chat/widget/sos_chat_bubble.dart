import 'package:flutter/material.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/chat/sos_chat_message_model.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SosChatBubble extends StatelessWidget {
  const SosChatBubble({super.key, required this.message, required this.isMine});

  final SosChatMessageModel message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(bottom: 12),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: padding(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMine ? appTheme.appColor : appTheme.grayF1Color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMine ? 16 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 16),
                ),
              ),
              child: Text(
                message.content?.trim() ?? '',
                style: StyleThemeData.size14Weight400(color: isMine ? appTheme.whiteColor : appTheme.blackColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
