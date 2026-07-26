import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/create_new_password/create_new_password_parameter.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/dialog_utils.dart';

class CreateNewPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isFormValid = false.obs;
  var isLoading = false.obs;
  var isPasswordTouched = false.obs;
  var isPasswordRuleValid = false.obs;

  String phoneNumber = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is CreateNewPasswordParameter) {
      phoneNumber = args.phoneNumber;
    }

    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    if (isClosed) return;

    final passwordValid = CustomValidator.validatePassword(passwordController.text.trim()).isEmpty;
    final confirmPassword = confirmPasswordController.text.trim();
    final confirmRequired = CustomValidator.validateRequiredField(
      confirmPassword,
      'confirm_new_password'.tr,
    ).isEmpty;
    final confirmMatched = confirmPassword == passwordController.text.trim();

    if (!isPasswordTouched.value && passwordController.text.trim().isNotEmpty) {
      isPasswordTouched.value = true;
    }

    isPasswordRuleValid.value = passwordValid;
    isFormValid.value = passwordValid && confirmRequired && confirmMatched;
  }

  Future<void> onConfirm() async {
    if (!isFormValid.value || isLoading.value) return;

    try {
      isLoading.value = true;
      // TODO: Call create/reset password API with phoneNumber.
      await Future<void>.delayed(const Duration(milliseconds: 800));
      DialogUtils.showSuccessDialog('create_new_password_success'.tr);
      Get.offAllNamed(Routes.SIGN_IN);
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  void goToSignIn() => Get.offAllNamed(Routes.SIGN_IN);

  @override
  void dispose() {
    passwordController
      ..removeListener(_validateForm)
      ..dispose();
    confirmPasswordController
      ..removeListener(_validateForm)
      ..dispose();
    super.dispose();
  }
}
