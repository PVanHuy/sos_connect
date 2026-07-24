import 'package:get/get.dart';
import 'package:sos_connect/resourese/service/localization_service.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/app_enums.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/shared_key.dart';

class AccountController extends GetxController {
  var userName = 'Văn Huy'.obs;
  var phoneNumber = '0978410127'.obs;
  var currentLanguage = LocalizationService.language.obs;

  void changeLanguage(Languages language) {
    LocalizationService.changeLanguage(language);
    currentLanguage.value = language;
  }

  Future<void> logout() async {
    final savedLanguage = LocalStorage.getString(SharedKey.language);
    await LocalStorage.clearAll();
    if (savedLanguage.isNotEmpty) {
      await LocalStorage.setString(SharedKey.language, savedLanguage);
    }
    Get.offAllNamed(Routes.SIGN_IN);
  }
}
