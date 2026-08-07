import 'package:get/get.dart';
import 'package:sos_connect/extension/date_time_extension.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/pages/rescue_posts/rescue_posts_parameter.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/rescue_support_type_utils.dart';
import 'package:sos_connect/utils/sos_status_utils.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';

class RescuePostsController extends GetxController {
  RescuePostsController({
    required this.teamRepository,
    required this.sosRepository,
  });

  final ITeamRepository teamRepository;
  final ISosRepository sosRepository;

  late final RescueListType listType;
  late final LazyListController<SosEventModel> postsController;
  final markingSafeId = RxnString();

  bool get usesTeamSupportApi =>
      listType == RescueListType.receiving || listType == RescueListType.received;

  bool get usesMySosApi => listType == RescueListType.yourRequests;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    listType = args is RescuePostsParameter ? args.type : RescueListType.receiving;

    postsController = LazyListController<SosEventModel>(
      onLoad: (page) async {
        if (usesMySosApi) {
          return sosRepository.getMySosRequests(page: page);
        }
        if (!usesTeamSupportApi) return PaginationModel<SosEventModel>();
        if (page > 1) return PaginationModel<SosEventModel>();
        return teamRepository.getAllSupport(status: listType.apiStatus);
      },
    );
  }

  void markAsSafe(SosEventModel item) {
    final sosId = item.id?.trim() ?? '';
    if (sosId.isEmpty || markingSafeId.value != null) return;

    showConfirmDialog(
      title: 'mark_as_safe'.tr,
      content: 'mark_as_safe_confirm'.tr,
      titleBtn: 'confirm'.tr,
      onConfirm: () => _cancelMySos(sosId),
    );
  }

  Future<void> _cancelMySos(String sosId) async {
    if (markingSafeId.value != null) return;

    try {
      markingSafeId.value = sosId;
      final response = await sosRepository.cancelMySosRequest(sosId);
      if (response.isOk) {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showSuccessDialog(message ?? 'mark_as_safe_success'.tr);
        postsController.removeWhere((item) => item.id == sosId);
      } else {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showErrorDialog(message ?? '');
      }
    } catch (e) {
      loggerHelper.error('Cancel my SOS error: $e');
    } finally {
      markingSafeId.value = null;
    }
  }

  String formatTime(String? createdAt) {
    final relative = createdAt.toRelativeTime;
    if (relative.isEmpty) return '';
    return 'posted_time'.trParams({'time': relative});
  }

  String statusLabel(SosEventModel item) {
    if (listType == RescueListType.received) return 'completed'.tr;
    final status = item.status ?? '';
    if (status.isNotEmpty) return status.sosStatusName;
    return SosStatusUtils.inProgress.sosStatusName;
  }

  @override
  void onClose() {
    postsController.dispose();
    super.onClose();
  }
}
