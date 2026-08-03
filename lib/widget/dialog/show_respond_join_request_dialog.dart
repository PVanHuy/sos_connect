import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

Future<String?> showRespondJoinRequestDialog({
  required String title,
  required String description,
  required String confirmText,
  bool isReject = false,
}) {
  return Get.dialog<String>(
    _RespondJoinRequestDialog(title: title, description: description, confirmText: confirmText, isReject: isReject),
    barrierDismissible: false,
  );
}

class _RespondJoinRequestDialog extends StatefulWidget {
  const _RespondJoinRequestDialog({
    required this.title,
    required this.description,
    required this.confirmText,
    required this.isReject,
  });

  final String title;
  final String description;
  final String confirmText;
  final bool isReject;

  @override
  State<_RespondJoinRequestDialog> createState() => _RespondJoinRequestDialogState();
}

class _RespondJoinRequestDialogState extends State<_RespondJoinRequestDialog> {
  final _messageController = TextEditingController();
  var _isValid = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _messageController.text.trim().isNotEmpty;
    if (isValid == _isValid) return;
    setState(() => _isValid = isValid);
  }

  void _close([String? result]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!(Get.isDialogOpen ?? false)) return;
      Get.back(result: result);
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_validateForm);
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      backgroundColor: appTheme.whiteColor,
      insetPadding: padding(horizontal: 16),
      child: Padding(
        padding: padding(vertical: 24, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(widget.title, style: StyleThemeData.size20Weight700(), textAlign: .center),
              SizedBox(height: 8.h),
              Text(widget.description, style: StyleThemeData.size12Weight400(), textAlign: .center),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _messageController,
                titleText: 'response_message'.tr,
                hintText: 'enter_response_message'.tr,
                maxLines: 3,
                borderRadius: 12,
              ),
              SizedBox(height: 24.h),
              Row(
                spacing: 8.w,
                children: [
                  Expanded(
                    child: CustomButton(
                      buttonText: 'cancel'.tr,
                      color: appTheme.sliverColor,
                      textColor: appTheme.appColor,
                      onPressed: _close,
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      buttonText: widget.confirmText,
                      color: widget.isReject ? appTheme.errorColor : null,
                      gradient: widget.isReject ? null : AppGradient.blueBFFAndAFFGradient,
                      onPressed: _isValid
                          ? () {
                              final message = _messageController.text.trim();
                              if (message.isEmpty) return;
                              _close(message);
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
