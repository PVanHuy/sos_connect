import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/pages/support/view/support_list_view.dart';
import 'package:sos_connect/pages/support/view/support_request_form_view.dart';
import 'package:sos_connect/pages/support/widget/sos_type_selector_widget.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';

class SupportPage extends GetWidget<SupportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      body: SafeArea(
        child: GestureDetector(
          behavior: .translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: padding(horizontal: 16, top: 8, bottom: 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(() {
                    final isRequest = controller.mode.value == SupportMode.request;
                    return InkWell(
                      onTap: controller.toggleMode,
                      borderRadius: .circular(999),
                      child: Container(
                        padding: padding(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: appTheme.blueBFFColor.withValues(alpha: 0.45),
                          borderRadius: .circular(999),
                        ),
                        child: Text(
                          isRequest ? 'request_help'.tr : 'list'.tr,
                          style: StyleThemeData.size12Weight700(color: appTheme.appColor),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 8.h),
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
                Obx(
                  () =>
                      controller.mode.value == SupportMode.request ? SupportRequestFormView() : const SupportListView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
