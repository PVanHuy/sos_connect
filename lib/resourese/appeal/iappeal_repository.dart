import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/appeal/appeal_model.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class IAppealRepository extends IBaseRepository {
  Future<PaginationModel<AppealModel>> getAppeals({int page = 1});

  Future<AppealModel?> getAppealDetail(String appealId);

  Future<Response> createAppeal({required String targetType, required String targetId, required String reason});
}
