import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/image_utils.dart';
import 'package:sos_connect/utils/location_util.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/utils/vietnam_address_utils.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

enum SupportMode { request, list }

class SupportController extends GetxController {
  SupportController({required this.sosRepository});

  final ISosRepository sosRepository;

  final mode = SupportMode.request.obs;
  final selectedType = SosEmergencyType.needRescue.obs;
  final selectedImage = Rxn<File>();
  final selectedProvince = Rxn<Province>();
  final isFormValid = false.obs;
  final currentLatLng = Rxn<LatLng>();

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
    _prefillLocation();
  }

  Future<void> _prefillLocation() async {
    try {
      LatLng? position;
      if (Get.isRegistered<MapController>()) {
        position = Get.find<MapController>().currentPosition.value;
      }

      if (position == null) {
        final result = await LocationUtil.getCurrentLatLng();
        if (!result.isSuccess || result.position == null) return;
        position = result.position;
      }

      currentLatLng.value = position;

      if (locationController.text.trim().isNotEmpty) return;

      final address = await sosRepository.convertLocation(position!);
      if (isClosed || locationController.text.trim().isNotEmpty) return;
      if (address == null || address.trim().isEmpty) return;

      locationController.text = address;
    } catch (e) {
      loggerHelper.error('Prefill SOS location error: $e');
    }
  }

  Future<void> _validateForm() async {
    final locationValid = CustomValidator.validateRequiredField(locationController.text.trim(), 'location'.tr).isEmpty;
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
    showConfirmDialog(title: 'send_sos'.tr, content: 'send_sos_confirm'.tr, titleBtn: 'confirm'.tr, onConfirm: () {});
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
