import 'package:get/get.dart';
import 'package:sos_connect/pages/personal_information/personal_information_controller.dart';

class PersonalInformationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalInformationController());
  }
}
