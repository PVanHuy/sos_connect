import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/appeal/appeal_model.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/resourese/appeal/iappeal_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';

class AppealRepository extends IAppealRepository {
  @override
  Future<PaginationModel<AppealModel>> getAppeals({int page = 1}) async {
    try {
      final query = <String, String>{'page': page.toString(), 'limit': AppConstants.LIMIT.toString()};
      final response = await clientGetData('${AppConstants.userAppealsUri}?${Uri(queryParameters: query).query}');

      if (response.isOk) {
        return PaginationModel.fromApi(response.body, AppealModel.fromJson);
      }

      return PaginationModel();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<AppealModel?> getAppealDetail(String appealId) async {
    try {
      final response = await clientGetData(AppConstants.userAppealDetailUri(appealId));
      if (!response.isOk) return null;

      final data = response.body is Map && response.body['data'] != null ? response.body['data'] : response.body;
      if (data is! Map) return null;
      return AppealModel.fromJson(Map<String, dynamic>.from(data));
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> createAppeal({
    required String targetType,
    required String targetId,
    required String reason,
  }) async {
    try {
      return await clientPostData(AppConstants.userAppealsUri, {
        'target_type': targetType,
        'target_id': targetId,
        'reason': reason,
      });
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
