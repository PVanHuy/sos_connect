import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/utils/custom_validator.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isFormValid = false.obs;
  var isLoading = false.obs;
  var isPasswordTouched = false.obs;
  var isPasswordRuleValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentPasswordController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
    _validateForm();
  }

  void _validateForm() {
    if (isClosed) return;

    final currentPasswordValid = CustomValidator.validateRequiredField(
      currentPasswordController.text,
      'current_password'.tr,
    ).isEmpty;
    final passwordValid = CustomValidator.validatePassword(passwordController.text.trim()).isEmpty;
    final confirmPassword = confirmPasswordController.text.trim();
    final confirmRequired = CustomValidator.validateRequiredField(confirmPassword, 'confirm_password'.tr).isEmpty;
    final confirmMatched = confirmPassword == passwordController.text.trim();

    if (!isPasswordTouched.value && passwordController.text.trim().isNotEmpty) {
      isPasswordTouched.value = true;
    }
    
    isPasswordRuleValid.value = passwordValid;

    isFormValid.value = currentPasswordValid && passwordValid && confirmRequired && confirmMatched;
  }

  Future<void> onConfirm() async {
    if (!isFormValid.value || isLoading.value) return;
    try {
      isLoading.value = true;
      // TODO: Call change password API.
      await Future<void>.delayed(const Duration(milliseconds: 800));
      Get.back();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void dispose() {
    currentPasswordController
      ..removeListener(_validateForm)
      ..dispose();
    passwordController
      ..removeListener(_validateForm)
      ..dispose();
    confirmPasswordController
      ..removeListener(_validateForm)
      ..dispose();
    super.dispose();
  }
}
