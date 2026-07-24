import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/otp/otp_parameter.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/custom_validator.dart';

class SignUpController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isFormValid = false.obs;
  var isLoading = false.obs;
  var isPasswordRuleValid = false.obs;
  var isPasswordTouched = false.obs;

  @override
  void onInit() {
    super.onInit();
    userNameController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() async {
    var userNameValid = CustomValidator.validateUserName(userNameController.text.trim()).isEmpty;
    var phoneValid = (await CustomValidator.validatePhone(phoneController.text.trim())).isEmpty;
    var passwordValid = CustomValidator.validatePassword(passwordController.text.trim()).isEmpty;

    if (!isPasswordTouched.value && passwordController.text.trim().isNotEmpty) {
      isPasswordTouched.value = true;
    }

    isPasswordRuleValid.value = passwordValid;
    isFormValid.value = userNameValid && phoneValid && passwordValid;
  }

  Future<void> onSignUp() async {
    if (!isFormValid.value || isLoading.value) return;
    try {
      isLoading.value = true;
      await Future<void>.delayed(const Duration(seconds: 1));
      Get.toNamed(
        Routes.OTP,
        arguments: OtpParameter(phoneNumber: phoneController.text.trim(), type: OtpType.signUp),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignIn() => Get.offNamed(Routes.SIGN_IN);

  @override
  void dispose() {
    userNameController
      ..removeListener(_validateForm)
      ..dispose();
    phoneController
      ..removeListener(_validateForm)
      ..dispose();
    passwordController
      ..removeListener(_validateForm)
      ..dispose();
    super.dispose();
  }
}
