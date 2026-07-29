import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/create_new_password/create_new_password_parameter.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/dialog_utils.dart';

class CreateNewPasswordController extends GetxController {
  final IAuthRepository authRepository;

  CreateNewPasswordController({required this.authRepository});

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
    final confirmRequired = CustomValidator.validateRequiredField(confirmPassword, 'confirm_new_password'.tr).isEmpty;
    final confirmMatched = confirmPassword == passwordController.text.trim();

    if (!isPasswordTouched.value && passwordController.text.trim().isNotEmpty) {
      isPasswordTouched.value = true;
    }

    isPasswordRuleValid.value = passwordValid;
    isFormValid.value = passwordValid && confirmRequired && confirmMatched;
  }

  Future<void> onConfirm() async {
    if (!isFormValid.value || isLoading.value) return;

    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    try {
      isLoading.value = true;

      final response = await authRepository.forgotPassword({
        'phone': phoneNumber,
        'password': password,
        'confirmPassword': confirmPassword,
      });

      if (isClosed) return;

      if (response.isOk) {
        DialogUtils.showSuccessDialog(response.body['message'] ?? 'create_new_password_success'.tr);
        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        DialogUtils.showErrorDialog(response.body['message'] ?? '');
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController
      ..removeListener(_validateForm)
      ..dispose();
    confirmPasswordController
      ..removeListener(_validateForm)
      ..dispose();
    super.onClose();
  }
}
