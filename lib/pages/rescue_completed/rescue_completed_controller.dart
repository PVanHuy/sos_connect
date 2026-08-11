import 'package:get/get.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/model/sos/sos_event_model.dart';
import 'package:sos_connect/pages/rescue_completed/rescue_completed_parameter.dart';
import 'package:sos_connect/resourese/sos/isos_repository.dart';
import 'package:sos_connect/resourese/team/iteam_repository.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/rescue_support_type_utils.dart';
import 'package:sos_connect/widget/dialog/show_confirm_dialog.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';

class RescueCompletedController extends GetxController {
  RescueCompletedController({
    required this.teamRepository,
    required this.sosRepository,
  });

  final ITeamRepository teamRepository;
  final ISosRepository sosRepository;

  late final RescueListType listType;
  late final LazyListController<SosEventModel> postsController;
  final markingSafeId = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    listType = args is RescueCompletedParameter ? args.type : RescueListType.received;

    postsController = LazyListController<SosEventModel>(
      onLoad: (page) async {
        if (listType == RescueListType.yourRequests) {
          return sosRepository.getMySosRequests(page: page);
        }
        if (listType != RescueListType.receiving && listType != RescueListType.received) {
          return PaginationModel<SosEventModel>();
        }
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
      onConfirm: () => _resolveMySos(item),
    );
  }

  Future<void> _resolveMySos(SosEventModel item) async {
    final sosId = item.id?.trim() ?? '';
    if (sosId.isEmpty || markingSafeId.value != null) return;

    try {
      markingSafeId.value = sosId;
      final response = item.hasAssignedTeam
          ? await sosRepository.completeMySosRequest(sosId)
          : await sosRepository.cancelMySosRequest(sosId);
      if (response.isOk) {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showSuccessDialog(message ?? 'mark_as_safe_success'.tr);
        postsController.removeWhere((e) => e.id == sosId);
      } else {
        final message = response.body is Map ? response.body['message'] : null;
        DialogUtils.showErrorDialog(message ?? '');
      }
    } catch (e) {
      loggerHelper.error('Resolve my SOS error: $e');
    } finally {
      markingSafeId.value = null;
    }
  }

  @override
  void onClose() {
    postsController.dispose();
    super.onClose();
  }
}
