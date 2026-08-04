import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_controller.dart';
import 'package:sos_connect/pages/register_rescue_team/view/step1_register_rescue_team_view.dart';
import 'package:sos_connect/pages/register_rescue_team/view/step2_register_rescue_team_view.dart';
import 'package:sos_connect/pages/register_rescue_team/view/team_info_view.dart';
import 'package:sos_connect/widget/custom_button.dart';
import 'package:sos_connect/widget/default_app_bar.dart';
import 'package:sos_connect/widget/line_widget.dart';
import 'package:sos_connect/widget/reponsive/extension.dart';
import 'package:sos_connect/widget/step_progress_bar.dart';

class RegisterRescueTeamPage extends GetWidget<RegisterRescueTeamController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(() {
        final showTeamInfo = controller.showTeamInfo;
        final isEditing = controller.isEditingTeam.value;
        final showForm = !showTeamInfo;

        return Scaffold(
          backgroundColor: appTheme.whiteColor,
          body: SafeArea(
            child: Column(
              children: [
                DefaultAppBar(
                  title: isEditing
                      ? 'edit_team'.tr
                      : showTeamInfo
                      ? 'team_information_title'.tr
                      : 'register_rescue_team'.tr,
                  onBackPressed: controller.onBack,
                ),
                if (showForm)
                  Padding(
                    padding: padding(horizontal: 16, bottom: 12),
                    child: Obx(() => StepProgressBar(totalSteps: 2, currentStep: controller.currentStepIndex)),
                  ),
                Expanded(
                  child: showTeamInfo
                      ? TeamInfoView()
                      : Obx(() {
                          switch (controller.currentStep.value) {
                            case RegisterRescueTeamStep.step1:
                              return Step1RegisterRescueTeamView();
                            case RegisterRescueTeamStep.step2:
                              return Step2RegisterRescueTeamView();
                          }
                        }),
                ),
              ],
            ),
          ),
          bottomNavigationBar: showTeamInfo
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LineWidget(color: appTheme.grayF6Color),
                    Padding(
                      padding: padding(horizontal: 16, bottom: 16, top: 12),
                      child: Row(
                        children: [
                          if (controller.isLeader) ...[
                            Expanded(
                              child: CustomButton(
                                buttonText: 'edit_team'.tr,
                                color: appTheme.sliverColor,
                                textColor: appTheme.appColor,
                                hasSafeArea: false,
                                onPressed: controller.onEditTeam,
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                          Expanded(
                            child: CustomButton(
                              buttonText: 'view_team_members'.tr,
                              hasSafeArea: false,
                              onPressed: controller.onViewTeamMembers,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Obx(() {
                  final isStep1 = controller.currentStep.value == RegisterRescueTeamStep.step1;
                  final canContinue = isStep1 ? controller.isStep1Valid.value : controller.isStep2Valid.value;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LineWidget(color: appTheme.grayF6Color),
                      CustomButton(
                        margin: padding(horizontal: 16, bottom: 16, top: 12),
                        buttonText: isStep1
                            ? 'continue'.tr
                            : (isEditing ? 'save'.tr : 'submit'.tr),
                        isLoading: controller.isLoading.value,
                        onPressed: canContinue ? controller.onContinue : null,
                      ),
                    ],
                  );
                }),
        );
      }),
    );
  }
}
