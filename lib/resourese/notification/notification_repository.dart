import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/notification/notification_model.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/resourese/notification/inotification_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';

class NotificationRepository extends INotificationRepository {
  @override
  Future<PaginationModel<NotificationModel>> getNotifications({int page = 1}) async {
    try {
      final query = <String, String>{'page': page.toString(), 'limit': AppConstants.LIMIT.toString()};
      final response = await clientGetData('${AppConstants.notificationUri}?${Uri(queryParameters: query).query}');

      if (response.isOk) {
        return PaginationModel.fromApi(response.body, NotificationModel.fromJson);
      }

      return PaginationModel();
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<NotificationModel?> getNotificationDetail(String notificationId) async {
    try {
      final response = await clientGetData(AppConstants.notificationDetailUri(notificationId));
      if (!response.isOk) return null;

      final data = response.body is Map && response.body['data'] != null ? response.body['data'] : response.body;
      if (data is! Map) return null;
      return NotificationModel.fromJson(Map<String, dynamic>.from(data));
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> markNotificationAsRead({required String id}) async {
    try {
      return await clientPatchData(AppConstants.markNotificationAsReadUri(id), {});
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
