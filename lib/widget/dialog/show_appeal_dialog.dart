import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/custom_text_field.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

Future<String?> showAppealDialog() {
  return Get.dialog<String>(const _AppealDialog(), barrierDismissible: false);
}

class _AppealDialog extends StatefulWidget {
  const _AppealDialog();

  @override
  State<_AppealDialog> createState() => _AppealDialogState();
}

class _AppealDialogState extends State<_AppealDialog> {
  final _reasonController = TextEditingController();
  var _isValid = false;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _reasonController.text.trim().isNotEmpty;
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
    _reasonController.removeListener(_validateForm);
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: appTheme.whiteColor,
      insetPadding: padding(horizontal: 16),
      child: Padding(
        padding: padding(vertical: 24, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('send_appeal'.tr, style: StyleThemeData.size20Weight700(), textAlign: TextAlign.center),
              SizedBox(height: 8.h),
              Text('send_appeal_desc'.tr, style: StyleThemeData.size12Weight400(), textAlign: TextAlign.center),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _reasonController,
                titleText: 'appeal_reason'.tr,
                hintText: 'enter_appeal_reason'.tr,
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
                      buttonText: 'send_appeal'.tr,
                      onPressed: _isValid
                          ? () {
                              final reason = _reasonController.text.trim();
                              if (reason.isEmpty) return;
                              _close(reason);
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
