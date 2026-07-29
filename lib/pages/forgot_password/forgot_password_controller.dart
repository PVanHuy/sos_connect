import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/otp/otp_parameter.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/dialog_utils.dart';

class ForgotPasswordController extends GetxController {
  final IAuthRepository authRepository;

  ForgotPasswordController({required this.authRepository});

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
    if (isClosed) return;
    final phoneValid = await CustomValidator.validatePhone(phoneController.text.trim());
    if (isClosed) return;
    isFormValid.value = phoneValid.isEmpty;
  }

  Future<void> onContinue() async {
    if (!isFormValid.value || isLoading.value) return;

    final phone = phoneController.text.trim();

    try {
      isLoading.value = true;

      final response = await authRepository.sendOtp({'phone': phone, 'type': 'forgot-password'});

      if (isClosed) return;

      if (response.isOk) {
        DialogUtils.showSuccessDialog(response.body['message'] ?? '');
        Get.toNamed(
          Routes.OTP,
          arguments: OtpParameter(phoneNumber: phone, type: OtpType.forgetPassword),
        );
      } else {
        DialogUtils.showErrorDialog(response.body['message'] ?? '');
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    phoneController
      ..removeListener(_validateForm)
      ..dispose();
    super.onClose();
  }
}
