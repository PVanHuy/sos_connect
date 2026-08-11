import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/color_extension.dart';
import 'package:sos_connect/gen/assets.gen.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/pages/register_rescue_team/register_rescue_team_controller.dart';
import 'package:sos_connect/pages/register_rescue_team/view/step1_register_rescue_team_view.dart';
import 'package:sos_connect/pages/register_rescue_team/view/step2_register_rescue_team_view.dart';
import 'package:sos_connect/pages/register_rescue_team/view/team_info_view.dart';
import 'package:sos_connect/resourese/service/socket/team_live_mode_service.dart';
import 'package:sos_connect/theme/style/style_theme.dart';
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
                  actions: showTeamInfo && controller.isLeader
                      ? [
                          Obx(() {
                            if (!Get.isRegistered<TeamLiveModeService>()) {
                              return const SizedBox.shrink();
                            }
                            final liveService = Get.find<TeamLiveModeService>();
                            final isLive = liveService.isLive.value;
                            final isToggling = liveService.isToggling.value;
                            final label = isLive ? 'team_live_mode_on_label'.tr : 'team_live_mode_off_label'.tr;
                            final color = isLive ? appTheme.appColor : appTheme.gray83Color;

                            return Padding(
                              padding: padding(right: 8),
                              child: InkWell(
                                onTap: isToggling ? null : () => liveService.toggleLiveMode(),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: padding(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isLive
                                        ? appTheme.appColor.withSafeOpacity(0.1)
                                        : appTheme.sliverColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: isLive ? appTheme.appColor : appTheme.grayE5Color),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isToggling)
                                        SizedBox(
                                          width: 14.w,
                                          height: 14.w,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: color),
                                        )
                                      else
                                        Assets.icons.power.svg(
                                          width: 16.w,
                                          height: 16.w,
                                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                                        ),
                                      SizedBox(width: 6.w),
                                      Text(label, style: StyleThemeData.size12Weight700(color: color)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ]
                      : const [],
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
                        buttonText: isStep1 ? 'continue'.tr : (isEditing ? 'save'.tr : 'submit'.tr),
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
