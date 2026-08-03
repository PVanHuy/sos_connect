import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sos_connect/resourese/dashboard/idashboard_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';

class DashboardRepository extends IDashboardRepository {
  @override
  Future<Response> updateFcmToken(String fcmToken) async {
    try {
      // final deviceInfo = DeviceInfoPlugin();
      // String? deviceId;

      // if (Platform.isIOS) {
      //   final iosInfo = await deviceInfo.iosInfo;
      //   deviceId = iosInfo.identifierForVendor;
      // } else if (Platform.isAndroid) {
      //   final androidInfo = await deviceInfo.androidInfo;
      //   deviceId = androidInfo.id;
      // }

      final result = await clientPatchData(AppConstants.updateFcmTokenUri, {
        // 'device_id': deviceId.toString(),
        'platform': Platform.isIOS ? 'ios' : 'android',
        'fcm_token': fcmToken,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
