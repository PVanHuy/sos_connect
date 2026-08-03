import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/model/notification/notification_model.dart';
import 'package:sos_connect/model/pagination_model.dart';
import 'package:sos_connect/resourese/ibase_repository.dart';

abstract class INotificationRepository extends IBaseRepository {
  Future<PaginationModel<NotificationModel>> getNotifications({int page = 1});

  Future<NotificationModel?> getNotificationDetail(String notificationId);

  Future<Response> markNotificationAsRead({required String id});
}
