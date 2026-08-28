import 'package:get/get.dart';
import 'package:sos_connect/model/appeal/appeal_model.dart';
import 'package:sos_connect/pages/appeal_detail/appeal_detail_parameter.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/resourese/appeal/iappeal_repository.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';
import 'package:sos_connect/utils/logger_helper.dart';

class AppealDetailController extends GetxController {
  AppealDetailController({
    required this.appealRepository,
    required this.notificationRepository,
    required this.parameter,
  });

  final IAppealRepository appealRepository;
  final INotificationRepository notificationRepository;
  final AppealDetailParameter parameter;

  final isLoading = false.obs;
  final appeal = Rxn<AppealModel>();

  @override
  void onInit() {
    super.onInit();
    fetchAppealDetail();
  }

  Future<void> fetchAppealDetail() async {
    try {
      isLoading.value = true;

      var appealId = parameter.appealId?.trim() ?? '';
      final notificationId = parameter.notificationId?.trim() ?? '';

      if (appealId.isEmpty && notificationId.isNotEmpty) {
        final notification = await notificationRepository.getNotificationDetail(notificationId);
        if (isClosed) return;
        appealId = notification?.data?.appealId?.trim() ?? notification?.requestId?.trim() ?? '';
        if (!(notification?.isRead ?? true) && Get.isRegistered<NotiController>()) {
          await Get.find<NotiController>().markNotificationAsRead(notificationId);
        }
      }

      if (appealId.isEmpty) return;

      final detail = await appealRepository.getAppealDetail(appealId);
      if (isClosed) return;
      appeal.value = detail;
    } catch (e) {
      loggerHelper.error('Error fetching appeal detail: $e');
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
