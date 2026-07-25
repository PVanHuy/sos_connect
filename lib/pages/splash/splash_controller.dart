import 'package:get/get.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/shared_key.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500)).then((value) => init());
  }

  void init() async {
    final token = LocalStorage.getString(SharedKey.token);

    if (token.isNotEmpty) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }
}
