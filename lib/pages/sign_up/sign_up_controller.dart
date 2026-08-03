import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/otp/otp_parameter.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/vietnam_address_utils.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

class SignUpController extends GetxController {
  final IAuthRepository authRepository;

  SignUpController({required this.authRepository});

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();

  var isFormValid = false.obs;
  var isLoading = false.obs;
  var isPasswordRuleValid = false.obs;
  var isPasswordTouched = false.obs;
  var selectedProvince = Rxn<Province>();

  @override
  void onInit() {
    super.onInit();
    userNameController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    provinceController.addListener(_validateForm);
  }

  void _validateForm() async {
    if (isClosed) return;
    var userNameValid = CustomValidator.validateUserName(userNameController.text.trim()).isEmpty;
    var phoneValid = (await CustomValidator.validatePhone(phoneController.text.trim())).isEmpty;
    var passwordValid = CustomValidator.validatePassword(passwordController.text.trim()).isEmpty;
    var provinceValid = CustomValidator.validateRequiredField(
      provinceController.text.trim(),
      'province_city'.tr,
    ).isEmpty;

    if (isClosed) return;

    if (!isPasswordTouched.value && passwordController.text.trim().isNotEmpty) {
      isPasswordTouched.value = true;
    }

    isPasswordRuleValid.value = passwordValid;
    isFormValid.value = userNameValid && phoneValid && passwordValid && provinceValid && selectedProvince.value != null;
  }

  Future<void> selectProvince() async {
    final selected = await VietnamAddressUtils.pickProvince();
    if (selected == null) return;

    selectedProvince.value = selected;
    provinceController.text = selected.name;
    _validateForm();
  }

  Future<void> onSignUp() async {
    if (!isFormValid.value || isLoading.value) return;

    final phone = phoneController.text.trim();
    final username = userNameController.text.trim();
    final password = passwordController.text.trim();
    final province = selectedProvince.value?.name ?? provinceController.text.trim();

    try {
      isLoading.value = true;

      final response = await authRepository.signUp({
        'phone': phone,
        'username': username,
        'password': password,
        'province': province,
      });

      if (isClosed) return;

      if (response.isOk) {
        DialogUtils.showSuccessDialog(response.body['message'] ?? '');
        Get.toNamed(
          Routes.OTP,
          arguments: OtpParameter(phoneNumber: phone, type: OtpType.signUp),
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
    userNameController
      ..removeListener(_validateForm)
      ..dispose();
    phoneController
      ..removeListener(_validateForm)
      ..dispose();
    passwordController
      ..removeListener(_validateForm)
      ..dispose();
    provinceController
      ..removeListener(_validateForm)
      ..dispose();
    super.onClose();
  }
}
