import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/custom_validator.dart';

class SignInController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    _validateForm();
  }

  Future<void> _validateForm() async {
    final phoneValid = await CustomValidator.validatePhone(phoneController.text.trim());
    final passwordValid = CustomValidator.validateRequiredField(passwordController.text, 'password'.tr);
    isFormValid.value = phoneValid.isEmpty && passwordValid.isEmpty;
  }

  void signIn() {
    if (!isFormValid.value || isLoading.value) return;
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
    });
  }

  void goToSignUp() => Get.toNamed(Routes.SIGN_UP);

  @override
  void onClose() {
    phoneController
      ..removeListener(_validateForm)
      ..dispose();
    passwordController
      ..removeListener(_validateForm)
      ..dispose();
    super.onClose();
  }
}
