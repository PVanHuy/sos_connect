import 'package:get/get.dart';
import 'package:sos_connect/language/en.dart';
import 'package:sos_connect/language/vi.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/shared_key.dart';

import '../../utils/app_enums.dart';

class LocalizationService extends Translations {
  static Languages get language => _language;

  static const Languages fallbackLanguage = Languages.vi;

  static const List<Languages> supportedLanguage = Languages.values;

  static Languages _language = _loadSavedLanguage() ?? Languages.vi;

  static void changeLanguage(Languages language) async {
    if (_language == language) return;
    _language = language;
    Get.updateLocale(language.locale);
    LocalStorage.setString(SharedKey.language, language.toString());
  }

  static Languages? _loadSavedLanguage() {
    String? savedLanguageString = LocalStorage.getString(SharedKey.language);
    try {
      return Languages.values.firstWhere((element) => element.toString() == savedLanguageString);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'vi_VN': vi};
}
