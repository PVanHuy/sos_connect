import 'package:get/get.dart';
import 'package:sos_connect/model/appeal/appeal_model.dart';
import 'package:sos_connect/resourese/appeal/iappeal_repository.dart';
import 'package:sos_connect/widget/lazy_list/lazy_list_controller.dart';

class AppealListController extends GetxController {
  AppealListController({required this.appealRepository});

  final IAppealRepository appealRepository;

  late final LazyListController<AppealModel> listController;

  @override
  void onInit() {
    super.onInit();
    listController = LazyListController<AppealModel>(onLoad: (page) => appealRepository.getAppeals(page: page));
  }

  @override
  void onClose() {
    listController.dispose();
    super.onClose();
  }
}
