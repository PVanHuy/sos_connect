import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/core/app_gradient.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

Future<String?> showJoinTeamRequestDialog() {
  return Get.dialog<String>(const _JoinTeamRequestDialog(), barrierDismissible: false);
}

class _JoinTeamRequestDialog extends StatefulWidget {
  const _JoinTeamRequestDialog();

  @override
  State<_JoinTeamRequestDialog> createState() => _JoinTeamRequestDialogState();
}

class _JoinTeamRequestDialogState extends State<_JoinTeamRequestDialog> {
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
    // CustomButton already unfocuses; wait next frame so focus tree settles before pop.
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
              Text('join_team_request'.tr, style: StyleThemeData.size20Weight700(), textAlign: .center),
              SizedBox(height: 8.h),
              Text('join_team_request_desc'.tr, style: StyleThemeData.size12Weight400(), textAlign: .center),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _messageController,
                titleText: 'join_team_reason'.tr,
                hintText: 'enter_join_team_reason'.tr,
                maxLines: 4,
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
                      buttonText: 'send_request'.tr,
                      gradient: AppGradient.blueBFFAndAFFGradient,
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
