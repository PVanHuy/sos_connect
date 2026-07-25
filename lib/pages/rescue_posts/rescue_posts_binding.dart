import 'package:get/get.dart';
import 'package:sos_connect/pages/rescue_posts/rescue_posts_controller.dart';

class RescuePostsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RescuePostsController());
  }
}
