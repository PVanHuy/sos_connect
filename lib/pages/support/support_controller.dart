import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/image_utils.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/utils/vietnam_address_utils.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

enum SupportMode { request, list }

class SupportController extends GetxController {
  final mode = SupportMode.request.obs;
  final selectedType = SosEmergencyType.needRescue.obs;
  final selectedImage = Rxn<File>();
  final selectedProvince = Rxn<Province>();
  final isFormValid = false.obs;

  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();

  String get selectedProvinceName => selectedProvince.value?.name ?? 'select_province_city'.tr;

  @override
  void onInit() {
    super.onInit();
    locationController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    _validateForm();
  }

  Future<void> _validateForm() async {
    final locationValid = CustomValidator.validateRequiredField(
      locationController.text.trim(),
      'location'.tr,
    ).isEmpty;
    final phoneValid = (await CustomValidator.validatePhone(phoneController.text.trim())).isEmpty;
    isFormValid.value = locationValid && phoneValid;
  }

  void toggleMode() {
    mode.value = mode.value == SupportMode.request ? SupportMode.list : SupportMode.request;
  }

  void selectType(SosEmergencyType type) {
    selectedType.value = type;
  }

  Future<void> selectProvince() async {
    final selected = await VietnamAddressUtils.pickProvince();
    if (selected == null) return;
    selectedProvince.value = selected;
  }

  Future<void> pickImage() async {
    final file = await ImageUtils.pickImage();
    if (file == null) return;
    selectedImage.value = file;
  }

  void clearImage() => selectedImage.value = null;

  void sendSos() {
    if (!isFormValid.value) return;
    showConfirmDialog(
      title: 'send_sos'.tr,
      content: 'send_sos_confirm'.tr,
      titleBtn: 'confirm'.tr,
      onConfirm: () {},
    );
  }

  @override
  void dispose() {
    locationController.removeListener(_validateForm);
    phoneController.removeListener(_validateForm);
    descriptionController.dispose();
    locationController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
