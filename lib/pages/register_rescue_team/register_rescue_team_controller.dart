import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/image_utils.dart';
import 'package:sos_connect/utils/rescue_team_role_utils.dart';
import 'package:sos_connect/utils/vietnam_address_utils.dart';
import 'package:sos_connect/widget/dialog/show_select_bottom_sheet.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

enum RegisterRescueTeamStep { step1, step2 }

class RegisterRescueTeamController extends GetxController {
  final teamNameController = TextEditingController();
  final provinceController = TextEditingController();
  final wardController = TextEditingController();
  final memberCountController = TextEditingController();
  final organizationController = TextEditingController();

  final contactNameController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final contactEmailController = TextEditingController();
  final roleController = TextEditingController();

  var currentStep = RegisterRescueTeamStep.step1.obs;
  var isLoading = false.obs;
  var isStep1Valid = false.obs;
  var isStep2Valid = false.obs;
  var confirmationDocument = Rxn<PostMedia>();

  var selectedProvince = Rxn<Province>();
  var selectedWard = Rxn<Ward>();
  var selectedRole = RxnString();

  int get currentStepIndex => currentStep.value.index + 1;

  @override
  void onInit() {
    super.onInit();
    teamNameController.addListener(_validateStep1);
    provinceController.addListener(_validateStep1);
    wardController.addListener(_validateStep1);
    memberCountController.addListener(_validateStep1);
    organizationController.addListener(_validateStep1);

    contactNameController.addListener(_validateStep2);
    contactPhoneController.addListener(_validateStep2);
    contactEmailController.addListener(_validateStep2);
    roleController.addListener(_validateStep2);

    _validateStep1();
    _validateStep2();
  }

  void _validateStep1() {
    if (isClosed) return;
    isStep1Valid.value =
        CustomValidator.validateRequiredField(teamNameController.text.trim(), 'team_name'.tr).isEmpty &&
        selectedProvince.value != null &&
        selectedWard.value != null &&
        CustomValidator.validateRequiredField(memberCountController.text.trim(), 'member_count'.tr).isEmpty &&
        CustomValidator.validateRequiredField(organizationController.text.trim(), 'organization_unit'.tr).isEmpty &&
        confirmationDocument.value?.file != null;
  }

  Future<void> _validateStep2() async {
    if (isClosed) return;
    final phoneValid = await CustomValidator.validatePhone(contactPhoneController.text.trim());
    if (isClosed) return;
    final emailValid = CustomValidator.validateEmail(contactEmailController.text.trim(), isRequired: false).isEmpty;

    isStep2Valid.value =
        CustomValidator.validateRequiredField(contactNameController.text.trim(), 'contact_person'.tr).isEmpty &&
        phoneValid.isEmpty &&
        emailValid &&
        selectedRole.value != null;
  }

  Future<void> pickConfirmationDocument() async {
    final file = await ImageUtils.pickImage();
    if (file == null) return;
    confirmationDocument.value = PostMedia(file: file);
    _validateStep1();
  }

  Future<void> selectProvince() async {
    final selected = await VietnamAddressUtils.pickProvince();
    if (selected == null) return;

    selectedProvince.value = selected;
    provinceController.text = selected.name;
    selectedWard.value = null;
    wardController.clear();
    _validateStep1();
  }

  Future<void> selectWard() async {
    final province = selectedProvince.value;
    if (province == null) return;

    final selected = await VietnamAddressUtils.pickWard(province: province);
    if (selected == null) return;

    selectedWard.value = selected;
    wardController.text = selected.name;
    _validateStep1();
  }

  Future<void> selectRole() async {
    final selected = await showSelectBottomSheet<String>(
      title: 'role'.tr,
      items: [RescueTeamRoleUtils.volunteer, RescueTeamRoleUtils.leader],
      labelBuilder: (item) => item.rescueTeamRoleName,
      fitContent: true,
    );
    if (selected == null) return;

    selectedRole.value = selected;
    roleController.text = selected.rescueTeamRoleName;
    _validateStep2();
  }

  void onBack() {
    if (currentStep.value == RegisterRescueTeamStep.step1) {
      Get.back();
      return;
    }
    currentStep.value = RegisterRescueTeamStep.step1;
  }

  void onContinue() {
    if (currentStep.value == RegisterRescueTeamStep.step1) {
      if (!isStep1Valid.value) return;
      currentStep.value = RegisterRescueTeamStep.step2;
      return;
    }
    onSubmit();
  }

  Future<void> onSubmit() async {
    if (!isStep2Valid.value || isLoading.value) return;
    try {
      isLoading.value = true;
      // TODO: Call register rescue team API.
      await Future<void>.delayed(const Duration(milliseconds: 800));
      Get.back();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    teamNameController
      ..removeListener(_validateStep1)
      ..dispose();
    provinceController
      ..removeListener(_validateStep1)
      ..dispose();
    wardController
      ..removeListener(_validateStep1)
      ..dispose();
    memberCountController
      ..removeListener(_validateStep1)
      ..dispose();
    organizationController
      ..removeListener(_validateStep1)
      ..dispose();
    contactNameController
      ..removeListener(_validateStep2)
      ..dispose();
    contactPhoneController
      ..removeListener(_validateStep2)
      ..dispose();
    contactEmailController
      ..removeListener(_validateStep2)
      ..dispose();
    roleController
      ..removeListener(_validateStep2)
      ..dispose();
    super.onClose();
  }
}
