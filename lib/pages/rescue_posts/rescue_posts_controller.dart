import 'package:get/get.dart';
import 'package:sos_connect/pages/rescue_posts/rescue_posts_parameter.dart';
import 'package:sos_connect/utils/rescue_support_type_utils.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';

class RescuePostsController extends GetxController {
  late final RescueListType listType;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    listType = args is RescuePostsParameter ? args.type : RescueListType.receiving;
  }

  void markAsSafe() {
    showConfirmDialog(
      title: 'mark_as_safe'.tr,
      content: 'mark_as_safe_confirm'.tr,
      titleBtn: 'confirm'.tr,
      onConfirm: () {},
    );
  }
}
