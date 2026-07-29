import 'package:get/get.dart';
import 'package:sos_connect/pages/personal_information/personal_information_controller.dart';
import 'package:sos_connect/resourese/profile/iprofile_repository.dart';

class PersonalInformationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PersonalInformationController(parameter: Get.arguments, profileRepository: Get.find<IProfileRepository>()),
    );
  }
}
