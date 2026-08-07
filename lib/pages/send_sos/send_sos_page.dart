import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/send_sos/send_sos_controller.dart';
import 'package:sos_connect/pages/send_sos/view/support_request_form_view.dart';
import 'package:sos_connect/pages/support/widget/sos_type_selector_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SendSosPage extends GetWidget<SendSosController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: DefaultAppBar(title: 'send_sos'.tr, backIconOther: true),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: padding(horizontal: 16, top: 8, bottom: 24),
            child: Column(
              children: [
                Text(
                  'sos_emergency'.tr,
                  textAlign: TextAlign.center,
                  style: StyleThemeData.size24Weight700(color: appTheme.red38Color),
                ),
                SizedBox(height: 4.h),
                Text(
                  'sos_emergency_desc'.tr,
                  textAlign: TextAlign.center,
                  style: StyleThemeData.size12Weight400(color: appTheme.gray83Color),
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => SosTypeSelectorWidget(
                    selectedType: controller.selectedType.value,
                    onSelect: controller.selectType,
                  ),
                ),
                SizedBox(height: 16.h),
                SupportRequestFormView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
