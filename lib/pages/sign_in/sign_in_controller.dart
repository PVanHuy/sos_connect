import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/model/auth/login_response_model.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/custom_validator.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/shared_key.dart';

class SignInController extends GetxController {
  final IAuthRepository authRepository;

  SignInController({required this.authRepository});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    _validateForm();
  }

  Future<void> _validateForm() async {
    if (isClosed) return;
    final phoneValid = await CustomValidator.validatePhone(phoneController.text.trim());
    final passwordValid = CustomValidator.validateRequiredField(passwordController.text, 'password'.tr);
    if (isClosed) return;
    isFormValid.value = phoneValid.isEmpty && passwordValid.isEmpty;
  }

  Future<void> signIn() async {
    if (!isFormValid.value || isLoading.value) return;

    try {
      isLoading.value = true;

      final response = await authRepository.signIn({
        'phone': phoneController.text.trim(),
        'password': passwordController.text.trim(),
      });

      if (isClosed) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginData = LoginResponseModel.fromJson(response.body);
        final token = loginData.accessToken ?? '';

        if (token.isNotEmpty) {
          await LocalStorage.setString(SharedKey.token, token);
          await LocalStorage.setBool(SharedKey.isLoggedIn, true);
        }

        DialogUtils.showSuccessDialog(loginData.message ?? '');
        Get.offAllNamed(Routes.DASHBOARD);
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
