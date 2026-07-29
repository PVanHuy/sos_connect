import 'package:get/get.dart';
import 'package:sos_connect/resourese/auth/auth_repository.dart';
import 'package:sos_connect/resourese/auth/iauth_repository.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';
import 'package:sos_connect/resourese/profile/profile_repository.dart';

class AppService {
  static Future<void> initAppService() async {
    Get.put<IAuthRepository>(AuthRepository());
    Get.put<IProfileRepository>(ProfileRepository());
  }
}
