import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/pages/account/account_page.dart';
import 'package:sos_connect/pages/map/map_page.dart';
import 'package:sos_connect/pages/noti/noti_page.dart';
import 'package:sos_connect/pages/support/support_page.dart';
import 'package:sos_connect/pages/survival/survival_page.dart';

class DashboardController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  late final List<Widget> pages = [
    MapPage(),
    SurvivalPage(),
    SupportPage(),
    NotiPage(),
    AccountPage(),
  ];

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
