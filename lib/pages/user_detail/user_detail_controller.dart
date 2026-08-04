import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/model/user/user_model.dart';
import 'package:sos_connect/pages/user_detail/user_detail_parameter.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/role_user.utils.dart';

class UserDetailController extends GetxController {
  UserDetailController({
    required this.profileRepository,
    required this.parameter,
  });

  final IProfileRepository profileRepository;
  final UserDetailParameter parameter;

  final isLoading = false.obs;
  final userModel = Rxn<UserModel>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final provinceController = TextEditingController();
  final roleController = TextEditingController();
  final cccdController = TextEditingController();
  final birthDateController = TextEditingController();

  String get avatarUrl => userModel.value?.avatar?.trim() ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchUserDetail();
  }

  Future<void> fetchUserDetail() async {
    try {
      isLoading.value = true;
      final user = await profileRepository.getUserById(parameter.userId);
      if (isClosed) return;

      userModel.value = user;
      if (user == null) return;

      fullNameController.text = user.username?.trim() ?? '';
      phoneController.text = user.phone?.trim() ?? '';
      emailController.text = user.email?.trim() ?? '';
      provinceController.text = user.province?.trim() ?? '';
      roleController.text = (user.roles ?? '').userRoleName;
      cccdController.text = user.cccd?.trim() ?? '';
      birthDateController.text = user.dob.toddMMyyyyNoEmpty;
    } catch (e) {
      loggerHelper.error('Error fetching user detail: $e');
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    provinceController.dispose();
    roleController.dispose();
    cccdController.dispose();
    birthDateController.dispose();
    super.onClose();
  }
}
