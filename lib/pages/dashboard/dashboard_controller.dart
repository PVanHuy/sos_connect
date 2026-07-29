import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/model/user/user_model.dart';
import 'package:sos_connect/pages/account/account_page.dart';
import 'package:sos_connect/pages/map/map_page.dart';
import 'package:sos_connect/pages/noti/noti_page.dart';
import 'package:sos_connect/pages/support/support_page.dart';
import 'package:sos_connect/pages/survival/survival_page.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';

class DashboardController extends GetxController {
  final IProfileRepository profileRepository;

  DashboardController({required this.profileRepository});

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);

  late final List<Widget> pages = [MapPage(), SurvivalPage(), SupportPage(), NotiPage(), AccountPage()];

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await profileRepository.profile();
      if (!response.isOk) return;

      userModel.value = UserModel.fromJson(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void updateUserModel(UserModel updatedModel) {
    userModel.value = updatedModel;
  }

  void goToTab(int index) {
    if (currentPage.value == index) return;
    currentPage.value = index;
    pageController.jumpToPage(index);
  }

  void animateToTab(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
