import 'package:get/get.dart';
import 'package:sos_connect/pages/appeal_list/appeal_list_controller.dart';
import 'package:sos_connect/resourese/appeal/iappeal_repository.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/widget/dialog/show_appeal_dialog.dart';

class AppealSubmitHelper {
  static Future<bool> submit({required String targetType, required String targetId}) async {
    final type = targetType.trim();
    final id = targetId.trim();
    if (type.isEmpty || id.isEmpty || !Get.isRegistered<IAppealRepository>()) return false;

    final reason = await showAppealDialog();
    if (reason == null || reason.trim().isEmpty) return false;

    try {
      final response = await Get.find<IAppealRepository>().createAppeal(
        targetType: type,
        targetId: id,
        reason: reason.trim(),
      );

      if (response.isOk) {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showSuccessDialog(message ?? 'send_appeal_success'.tr);
        if (Get.isRegistered<AppealListController>()) {
          await Get.find<AppealListController>().listController.onRefresh();
        }
        return true;
      }

      final message = response.body is Map ? response.body['message'] : null;
      DialogUtils.showErrorDialog(message ?? '');
      return false;
    } catch (e) {
      loggerHelper.error('Error creating appeal: $e');
      return false;
    }
  }
}
