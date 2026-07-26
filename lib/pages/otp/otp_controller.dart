import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/create_new_password/create_new_password_parameter.dart';
import 'package:sos_connect/pages/otp/otp_parameter.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/easyloading_utils.dart';

class OtpController extends GetxController {
  final OtpParameter parameter;

  OtpController({required this.parameter});

  final TextEditingController otpTextController = TextEditingController();

  var verificationCode = ''.obs;
  var otpError = ''.obs;
  var otpToken = ''.obs;
  var isOtpSuccess = false.obs;

  var countdown = AppConstants.timeOtp.obs;
  var canResend = false.obs;
  var isLoading = false.obs;

  String get phoneNumber => parameter.phoneNumber;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
    otpToken.value = '';
  }

  void updateVerificationCode(String value) {
    verificationCode.value = value;
    isOtpSuccess.value = false;
    if (otpError.value.isNotEmpty) {
      otpError.value = '';
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
      // TODO: Call verify OTP API with otpToken + verificationCode
      await Future.delayed(const Duration(milliseconds: 800));
      if (verificationCode.value.trim() == '1234') {
        otpError.value = '';
        isOtpSuccess.value = true;
        dismissEasyLoading();
        if (parameter.type == OtpType.forgetPassword) {
          Get.offNamed(
            Routes.CREATE_NEW_PASSWORD,
            arguments: CreateNewPasswordParameter(phoneNumber: phoneNumber),
          );
        } else {
          Get.offAllNamed(Routes.SIGN_IN);
        }
      } else {
        isOtpSuccess.value = false;
        otpError.value = 'otp_invalid'.tr;
      }
    } finally {
      dismissEasyLoading();
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    // TODO: Call resend OTP API and update otpToken from response
    otpError.value = '';
    isOtpSuccess.value = false;
    verificationCode.value = '';
    otpTextController.clear();
    startCountdown();
  }

  void startCountdown() {
    canResend.value = false;
    countdown.value = 60;
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

  @override
  void dispose() {
    _timer?.cancel();
    dismissEasyLoading();
    otpTextController.dispose();
    super.dispose();
  }
}
