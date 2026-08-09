import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/model/user/user_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/personal_information/personal_information_parameter.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/utils/calendar_config_util.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/image_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/role_user.utils.dart';
import 'package:sos_connect/utils/vietnam_address_utils.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

class PersonalInformationController extends GetxController {
  final PersonalInformationParameter parameter;
  final IProfileRepository profileRepository;

  PersonalInformationController({required this.parameter, required this.profileRepository});

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final cccdController = TextEditingController();
  final birthDateController = TextEditingController();
  final provinceController = TextEditingController();

  var isFormValid = false.obs;
  var isLoading = false.obs;
  var avatarUrl = ''.obs;
  var avatarFile = Rxn<PostMedia>();
  var birthDate = Rxn<DateTime>();
  var selectedProvince = Rxn<Province>();

  @override
  void onInit() {
    super.onInit();
    final user = parameter.userModel;

    fullNameController.text = user?.username ?? '';
    phoneController.text = user?.phone ?? '';
    emailController.text = user?.email ?? '';
    roleController.text = (user?.roles ?? '').userRoleName;
    cccdController.text = user?.cccd ?? '';
    provinceController.text = user?.province ?? '';
    avatarUrl.value = user?.avatar ?? '';

    final dob = user?.dob.toDateTime;
    if (dob != null) {
      birthDate.value = dob;
      birthDateController.text = dob.toddMMyyyy;
    }

    fullNameController.addListener(_updateFormValid);
    phoneController.addListener(_updateFormValid);
    emailController.addListener(_updateFormValid);
    cccdController.addListener(_updateFormValid);
    birthDateController.addListener(_updateFormValid);
    provinceController.addListener(_updateFormValid);
    _updateFormValid();
  }

  Future<void> _updateFormValid() async {
    if (isClosed) return;
    final fullNameValid = CustomValidator.validateFullName(fullNameController.text.trim()).isEmpty;
    final phoneValid = CustomValidator.validatePhone(phoneController.text.trim());
    final emailValid = CustomValidator.validateEmail(emailController.text.trim(), isRequired: false).isEmpty;
    final cccdValid = CustomValidator.validateCCCD(cccdController.text.trim(), isRequired: false).isEmpty;
    final provinceValid = CustomValidator.validateRequiredField(
      provinceController.text.trim(),
      'province_city'.tr,
    ).isEmpty;
    if (isClosed) return;

    isFormValid.value = fullNameValid && phoneValid.isEmpty && emailValid && cccdValid && provinceValid;
  }

  Future<void> pickImage() async {
    final file = await ImageUtils.pickImage();
    if (file == null) return;
    avatarFile.value = PostMedia(file: file);
  }

  Future<void> selectProvince() async {
    final selected = await VietnamAddressUtils.pickProvince();
    if (selected == null) return;

    selectedProvince.value = selected;
    provinceController.text = selected.name;
    _updateFormValid();
  }

  Future<void> pickBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await CalendarConfigUtil.showDatePicker(
      context: context,
      initialDate: birthDate.value ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null) return;

    birthDate.value = picked;
    birthDateController.text = picked.toddMMyyyy;
    _updateFormValid();
  }

  Future<void> savePersonalInformation() async {
    if (!isFormValid.value || isLoading.value) return;

    try {
      isLoading.value = true;

      final province = selectedProvince.value?.name ?? provinceController.text.trim();

      final params = <String, dynamic>{
        'username': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        if (emailController.text.trim().isNotEmpty) 'email': emailController.text.trim(),
        if (cccdController.text.trim().isNotEmpty) 'cccd': cccdController.text.trim(),
        if (birthDate.value != null) 'dob': birthDate.value!.toyyyyMMdd,
        if (province.isNotEmpty) 'province': province,
      };

      final response = await profileRepository.updateProfile(params, avatar: avatarFile.value);

      if (response.statusCode == 200 || response.statusCode == 201) {
        DialogUtils.showSuccessDialog(response.body['message'] ?? 'update_profile'.tr);
        final userJson = Map<String, dynamic>.from(response.body['user'] ?? response.body);
        final parsed = UserModel.fromJson(userJson);
        final current = parameter.userModel;

        Get.find<DashboardController>().updateUserModel(
          UserModel(
            id: parsed.id ?? current?.id,
            username: fullNameController.text.trim(),
            phone: phoneController.text.trim(),
            email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
            roles: parsed.roles ?? current?.roles,
            cccd: cccdController.text.trim().isEmpty ? null : cccdController.text.trim(),
            dob: birthDate.value?.toyyyyMMdd ?? parsed.dob,
            avatar: parsed.avatar ?? avatarUrl.value,
            address: parsed.address ?? current?.address,
            teamId: parsed.teamId ?? current?.teamId,
            province: province.isEmpty ? parsed.province ?? current?.province : province,
          ),
        );
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message'] ?? '');
      }
    } catch (e) {
      loggerHelper.log('Error updating profile: $e');
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController
      ..removeListener(_updateFormValid)
      ..dispose();
    phoneController
      ..removeListener(_updateFormValid)
      ..dispose();
    emailController
      ..removeListener(_updateFormValid)
      ..dispose();
    roleController.dispose();
    cccdController
      ..removeListener(_updateFormValid)
      ..dispose();
    birthDateController
      ..removeListener(_updateFormValid)
      ..dispose();
    provinceController
      ..removeListener(_updateFormValid)
      ..dispose();
    super.onClose();
  }
}
