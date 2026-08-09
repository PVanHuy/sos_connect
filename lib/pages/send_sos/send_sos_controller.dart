import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos_connect/main.dart';
import 'package:sos_connect/model/media/post_media.dart';
import 'package:sos_connect/pages/map/map_controller.dart';
import 'package:sos_connect/pages/support/support_controller.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/image_utils.dart';
import 'package:sos_connect/utils/location_util.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/sos_emergency_type_utils.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';

class SendSosController extends GetxController {
  SendSosController({required this.sosRepository});

  final ISosRepository sosRepository;

  final selectedType = SosEmergencyType.needRescue.obs;
  final selectedImage = Rxn<File>();
  final isFormValid = false.obs;
  final currentLatLng = Rxn<LatLng>();
  final isSendingSos = false.obs;

  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _unfocusAfterFrame() {
    _unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) => _unfocus());
  }

  @override
  void onInit() {
    super.onInit();
    locationController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    descriptionController.addListener(_validateForm);
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
    final descriptionValid = CustomValidator.validateRequiredField(
      descriptionController.text.trim(),
      'situation_description'.tr,
    ).isEmpty;
    final locationValid = CustomValidator.validateRequiredField(locationController.text.trim(), 'location'.tr).isEmpty;
    final phoneValid = CustomValidator.validatePhone(phoneController.text.trim()).isEmpty;
    final imageValid = selectedImage.value != null;
    isFormValid.value = descriptionValid && locationValid && phoneValid && imageValid;
  }

  void selectType(SosEmergencyType type) {
    if (selectedType.value == type) return;
    selectedType.value = type;
  }

  Future<void> pickImage() async {
    _unfocus();
    final file = await ImageUtils.pickImage();
    _unfocusAfterFrame();
    if (file == null) return;
    selectedImage.value = file;
    _validateForm();
  }

  void clearImage() {
    selectedImage.value = null;
    _validateForm();
  }

  void sendSos() {
    if (!isFormValid.value || isSendingSos.value) return;
    _unfocus();
    showConfirmDialog(
      title: 'send_sos'.tr,
      content: 'send_sos_confirm'.tr,
      titleBtn: 'confirm'.tr,
      titleColor: appTheme.red1AColor,
      onConfirm: _submitSosRequest,
    );
  }

  Future<void> _submitSosRequest() async {
    if (isSendingSos.value) return;

    try {
      isSendingSos.value = true;
      _unfocus();

      var position = currentLatLng.value;
      if (position == null) {
        final result = await LocationUtil.getCurrentLatLng();
        if (result.isSuccess && result.position != null) {
          position = result.position;
          currentLatLng.value = position;
        }
      }

      final image = selectedImage.value;
      final response = await sosRepository.createSosRequest(
        type: selectedType.value.apiType,
        description: descriptionController.text.trim(),
        lat: position?.latitude,
        lon: position?.longitude,
        addressText: locationController.text.trim(),
        phone: phoneController.text.trim(),
        image: image != null ? PostMedia(file: image) : null,
      );

      if (response.isOk) {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showSuccessDialog(message ?? 'send_sos_success'.tr);
        if (Get.isRegistered<SupportController>()) {
          Get.find<SupportController>().refreshList();
        }
        Get.back();
      } else {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showErrorDialog(message ?? '');
        _unfocusAfterFrame();
      }
    } catch (e) {
      loggerHelper.error('Send SOS error: $e');
    } finally {
      isSendingSos.value = false;
    }
  }

  @override
  void onClose() {
    locationController.removeListener(_validateForm);
    phoneController.removeListener(_validateForm);
    descriptionController.removeListener(_validateForm);
    descriptionController.dispose();
    locationController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
