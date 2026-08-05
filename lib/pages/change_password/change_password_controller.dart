import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController({required this.authRepository});

  final IAuthRepository authRepository;

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
      final response = await authRepository.changePassword(
        oldPassword: currentPasswordController.text,
        newPassword: passwordController.text.trim(),
        confirmNewPassword: confirmPasswordController.text.trim(),
      );

      if (isClosed) return;

      if (response.isOk) {
        DialogUtils.showSuccessDialog(response.body['message'] ?? 'change_password_success'.tr);
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message'] ?? '');
      }
    } catch (e) {
      loggerHelper.error('Change password error: $e');
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
