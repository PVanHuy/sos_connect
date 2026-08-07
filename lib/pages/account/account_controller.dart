import 'package:get/get.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/resourese/service/localization_service.dart';
import 'package:sos_connect/resourese/service/socket/team_live_mode_service.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/app_enums.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/easyloading_utils.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/shared_key.dart';

class AccountController extends GetxController {
  AccountController({required this.profileRepository});

  final IProfileRepository profileRepository;

  DashboardController get dashboardController => Get.find<DashboardController>();

  var currentLanguage = LocalizationService.language.obs;

  void changeLanguage(Languages language) {
    LocalizationService.changeLanguage(language);
    currentLanguage.value = language;
  }

  Future<void> logout() async {
    try {
      showEasyLoading();

      if (Get.isRegistered<TeamLiveModeService>()) {
        await Get.find<TeamLiveModeService>().stopLiveMode();
      }

      final response = await profileRepository.logOut();

      if (response == true) {
        DialogUtils.showSuccessDialog('logout_successful'.tr);
        final savedLanguage = LocalStorage.getString(SharedKey.language);
        await LocalStorage.clearAll();
        if (savedLanguage.isNotEmpty) {
          await LocalStorage.setString(SharedKey.language, savedLanguage);
        }

        Get.offAllNamed(Routes.SIGN_IN);
      }
    } catch (e) {
      loggerHelper.error('Logout error: $e');
    } finally {
      dismissEasyLoading();
    }
  }
}
