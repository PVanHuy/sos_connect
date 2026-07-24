import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/utils/calendar_config_util.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/image_utils.dart';

class PersonalInformationController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final cccdController = TextEditingController();
  final birthDateController = TextEditingController();

  var isFormValid = false.obs;
  var isLoading = false.obs;
  var avatarFile = Rxn<PostMedia>();
  var birthDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fullNameController.addListener(_updateFormValid);
    phoneController.addListener(_updateFormValid);
    emailController.addListener(_updateFormValid);
    roleController.addListener(_updateFormValid);
    cccdController.addListener(_updateFormValid);
    birthDateController.addListener(_updateFormValid);
    _updateFormValid();
  }

  Future<void> _updateFormValid() async {
    final fullNameValid = CustomValidator.validateFullName(fullNameController.text.trim()).isEmpty;
    final phoneValid = await CustomValidator.validatePhone(phoneController.text.trim());
    final emailValid = CustomValidator.validateEmail(emailController.text.trim(), isRequired: false).isEmpty;
    final roleValid = CustomValidator.validateRequiredField(roleController.text.trim(), 'role'.tr).isEmpty;
    final cccdValid = CustomValidator.validateRequiredField(cccdController.text.trim(), 'cccd'.tr).isEmpty;
    final birthDateValid = birthDate.value != null;

    isFormValid.value = fullNameValid && phoneValid.isEmpty && emailValid && roleValid && cccdValid && birthDateValid;
  }

  Future<void> pickImage() async {
    final file = await ImageUtils.pickImage();
    if (file == null) return;

    avatarFile.value = PostMedia(file: file);
    // TODO: Upload avatar to API when endpoint is available.
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
    if (!isFormValid.value) return;
    try {
      isLoading.value = true;
      // TODO: Call update personal information API.
      await Future<void>.delayed(const Duration(milliseconds: 600));
      Get.back();
    } finally {
      isLoading.value = false;
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
    roleController
      ..removeListener(_updateFormValid)
      ..dispose();
    cccdController
      ..removeListener(_updateFormValid)
      ..dispose();
    birthDateController
      ..removeListener(_updateFormValid)
      ..dispose();
    super.onClose();
  }
}
