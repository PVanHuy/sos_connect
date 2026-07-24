import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/otp/otp_parameter.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/custom_validator.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController phoneController = TextEditingController();

  var isFormValid = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_validateForm);
    _validateForm();
  }

  void _validateForm() async {
    final phoneValid = await CustomValidator.validatePhone(phoneController.text.trim());
    isFormValid.value = phoneValid.isEmpty;
  }

  Future<void> onContinue() async {
    if (!isFormValid.value || isLoading.value) return;
    try {
      isLoading.value = true;
      await Future<void>.delayed(const Duration(seconds: 1));
      Get.toNamed(
        Routes.OTP,
        arguments: OtpParameter(phoneNumber: phoneController.text.trim(), type: OtpType.forgetPassword),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    phoneController
      ..removeListener(_validateForm)
      ..dispose();
    super.dispose();
  }
}
