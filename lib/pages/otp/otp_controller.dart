import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/create_new_password/create_new_password_parameter.dart';
import 'package:sos_connect/pages/otp/otp_parameter.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/easyloading_utils.dart';

class OtpController extends GetxController {
  OtpController({required this.parameter, required this.authRepository});

  final OtpParameter parameter;
  final IAuthRepository authRepository;
  final TextEditingController otpTextController = TextEditingController();

  var verificationCode = ''.obs;
  var otpError = ''.obs;
  var isOtpSuccess = false.obs;
  var countdown = AppConstants.timeOtp.obs;
  var canResend = false.obs;
  var isLoading = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpTextController.dispose();
    super.onClose();
  }

  void startCountdown() {
    canResend.value = false;
    countdown.value = AppConstants.timeOtp;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void updateVerificationCode(String value) {
    verificationCode.value = value;
    isOtpSuccess.value = false;
    if (otpError.value.isNotEmpty) {
      otpError.value = '';
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      showEasyLoading();

      final response = await authRepository.sendOtp({
        'phone': parameter.phoneNumber,
        'type': parameter.type == OtpType.signUp ? 'signup' : 'forgot-password',
      });

      if (response.statusCode == 200) {
        verificationCode.value = '';
        otpError.value = '';
        isOtpSuccess.value = false;
        otpTextController.clear();
        DialogUtils.showSuccessDialog(response.body['message'] ?? '');
        startCountdown();
      } else {
        DialogUtils.showErrorDialog(response.body['message'] ?? '');
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      dismissEasyLoading();
    }
  }

  Future<void> onConfirm() async {
    if (isLoading.value) return;

    if (verificationCode.value.trim().length < AppConstants.maxOtpLength) {
      isOtpSuccess.value = false;
      otpError.value = 'otp_invalid'.tr;
      return;
    }

    try {
      isLoading.value = true;
      showEasyLoading();

      final response = await authRepository.verifyOtp({
        'phone': parameter.phoneNumber,
        'type': parameter.type == OtpType.signUp ? 'signup' : 'forgot-password',
        'otp': verificationCode.value.trim(),
      });

      if (response.isOk) {
        otpError.value = '';
        isOtpSuccess.value = true;
        DialogUtils.showSuccessDialog(response.body['message'] ?? '');

        if (parameter.type == OtpType.forgetPassword) {
          Get.offNamed(
            Routes.CREATE_NEW_PASSWORD,
            arguments: CreateNewPasswordParameter(phoneNumber: parameter.phoneNumber),
          );
        } else {
          Get.offAllNamed(Routes.SIGN_IN);
        }
      } else {
        isOtpSuccess.value = false;
        otpError.value = DialogUtils.resolveMessage(response.body['message'], fallback: 'otp_invalid'.tr);
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      dismissEasyLoading();
    }
  }
}
