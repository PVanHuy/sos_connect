import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sos_connect/model/notification/fcm_notification_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/join_request_detail/join_request_detail_parameter.dart';
import 'package:sos_connect/pages/join_team_request_list/join_team_request_list_controller.dart';
import 'package:sos_connect/pages/noti/noti_controller.dart';
import 'package:sos_connect/pages/notification_detail/notification_detail_parameter.dart';
import 'package:sos_connect/pages/rescue_team_detail/rescue_team_detail_parameter.dart';
import 'package:sos_connect/pages/rescue_team_list/rescue_team_list_controller.dart';
import 'package:sos_connect/resourese/dashboard/idashboard_repository.dart';
import 'package:sos_connect/routes/pages.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/join_team_request_status_utils.dart';
import 'package:sos_connect/utils/local_storage.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:sos_connect/utils/noti_type_utils.dart';
import 'package:sos_connect/utils/shared_key.dart';
import 'package:sos_connect/widget/dialog/show_alert_dialog.dart';

class NotificationService {
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenAppSub;
  StreamSubscription<String>? _onTokenRefresh;

  final _messaging = FirebaseMessaging.instance;
  final _plugin = FlutterLocalNotificationsPlugin();

  /// Chỉ xử lý initial launch 1 lần / process.
  bool _didHandleInitialMessage = false;

  void onClose() {
    _onTokenRefresh?.cancel();
    _onMessageSub?.cancel();
    _onMessageOpenAppSub?.cancel();
  }

  Future<bool?> onRequestPermission() async {
    if (Platform.isAndroid) {
      final granted = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();

      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              AppConstants.notificationChannelId,
              'Normal SOS Connect channel',
              description: 'This channel is used for normal notifications.',
              importance: Importance.high,
            ),
          );

      return granted;
    } else if (Platform.isMacOS) {
      final settings = await _plugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      loggerHelper.logBlue('notification permission: $settings');
      return settings;
    } else {
      return _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> onInit() async {
    _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestSoundPermission: true,
          requestBadgePermission: true,
        ),
        macOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestSoundPermission: true,
          requestBadgePermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    _onMessageOpenAppSub = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onHandleNotification(message.data);
    });

    _onMessageSub = FirebaseMessaging.onMessage.listen((message) {
      loggerHelper.success('FCM Message Data: ${message.data}');
      if (message.notification != null) {
        showNotification(message);
      }

      final notificationData = message.data['data'] is Map
          ? Map<String, dynamic>.from(message.data['data'] as Map)
          : Map<String, dynamic>.from(message.data);
      _hardReloadService(notificationData);
    });

    _onTokenRefresh = _messaging.onTokenRefresh.listen((token) async {
      loggerHelper.logBlue('FCM Token Refresh: $token');
      try {
        if (Get.isRegistered<IDashboardRepository>()) {
          await Get.find<IDashboardRepository>().updateFcmToken(token);
        }
      } catch (e) {
        loggerHelper.error('Error updating refreshed FCM token: $e');
      }
    });
  }

  Future<void> onHandleInitialMessage() async {
    if (_didHandleInitialMessage) return;
    _didHandleInitialMessage = true;

    final lastMessage = await _messaging.getInitialMessage();
    if (lastMessage != null) {
      final launchKey = _buildLaunchKey(lastMessage.data);
      if (_isLaunchAlreadyHandled(launchKey)) return;

      await _markLaunchHandled(launchKey);
      onHandleNotification(lastMessage.data);
      return;
    }

    // Android: getNotificationAppLaunchDetails() hay trả lại notification cũ
    // sau mỗi lần mở app dù user không tap → phải dedupe bằng LocalStorage.
    final lastNotification = await _plugin.getNotificationAppLaunchDetails();
    if (lastNotification == null ||
        !lastNotification.didNotificationLaunchApp ||
        lastNotification.notificationResponse == null) {
      return;
    }

    final response = lastNotification.notificationResponse!;
    final data = _payloadMapFromResponse(response);
    final launchKey = _buildLaunchKey(data, fallback: response.payload);
    if (_isLaunchAlreadyHandled(launchKey)) return;

    await _markLaunchHandled(launchKey);
    onDidReceiveNotificationResponse(response);
  }

  Map<String, dynamic> _payloadMapFromResponse(NotificationResponse response) {
    try {
      final decoded = jsonDecode(response.payload ?? '{}');
      if (decoded is! Map) return {};
      final map = Map<String, dynamic>.from(decoded);
      final data = map['data'];
      if (data is Map) return Map<String, dynamic>.from(data);
      return map;
    } catch (_) {
      return {};
    }
  }

  String _buildLaunchKey(Map<String, dynamic> data, {String? fallback}) {
    final notificationId = data['notification_id']?.toString() ?? data['id']?.toString() ?? '';
    final time = data['time']?.toString() ?? data['created_at']?.toString() ?? '';
    if (notificationId.isNotEmpty) {
      return time.isNotEmpty ? '$notificationId|$time' : notificationId;
    }
    return fallback?.trim() ?? '';
  }

  bool _isLaunchAlreadyHandled(String launchKey) {
    if (launchKey.isEmpty) return true;
    return LocalStorage.getString(SharedKey.lastHandledNotificationLaunch) == launchKey;
  }

  Future<void> _markLaunchHandled(String launchKey) async {
    if (launchKey.isEmpty) return;
    await LocalStorage.setString(SharedKey.lastHandledNotificationLaunch, launchKey);
  }

  Future<String?> getFcmToken() async {
    try {
      if (Platform.isIOS) {
        await onRequestPermission();
      } else if (Platform.isMacOS) {
        await onRequestPermission();

        final apnsToken = await _messaging.getAPNSToken();
        loggerHelper.success('APNs token: $apnsToken');

        return apnsToken;
      }
      return _messaging.getToken();
    } catch (e) {
      loggerHelper.error('Error getting FCM token: $e');
      return null;
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    final payload = jsonDecode(notificationResponse.payload ?? '{}');
    if (payload is! Map) return;

    final map = Map<String, dynamic>.from(payload);
    final data = map['data'];
    onHandleNotification(data is Map ? Map<String, dynamic>.from(data) : map);
  }

  void showNotification(RemoteMessage message) {
    _plugin.show(
      id: message.notification.hashCode,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          '',
          color: Color(0xFF434336),
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(presentBadge: true, presentAlert: true, presentSound: true),
      ),
      payload: jsonEncode(message.toMap()),
    );
  }

  void onHandleNotification(Map<String, dynamic> payload) {
    loggerHelper.logWhite('Handle notification: $payload', name: 'NotificationService - CLICK');

    try {
      final data = payload['data'] is Map ? Map<String, dynamic>.from(payload['data'] as Map) : payload;
      final fcmNotification = FcmNotificationModel.fromJson(data);

      navigateByNotification(
        type: fcmNotification.type,
        action: fcmNotification.action,
        notificationId: fcmNotification.notificationId,
        teamId: fcmNotification.teamId,
        requestId: fcmNotification.requestId,
        reasonKicked: fcmNotification.resolvedReasonKicked,
        content: fcmNotification.content,
      );
    } catch (e) {
      loggerHelper.error('Error handling notification: $e', name: 'NotificationService - CLICK');
    }
  }

  void navigateByNotification({
    required String? type,
    required String? action,
    String? notificationId,
    String? teamId,
    String? requestId,
    String? reasonKicked,
    String? content,
  }) {
    final id = notificationId?.trim() ?? '';
    final targetTeamId = teamId?.trim() ?? '';
    final targetRequestId = requestId?.trim() ?? '';

    switch (type) {
      case NotiTypeUtils.joinRequest:
        switch (action) {
          case NotiActionUtils.created:
            Get.toNamed(Routes.JOIN_TEAM_REQUEST_LIST);
            break;
          case NotiActionUtils.rejected:
          case NotiActionUtils.accepted:
            if (targetRequestId.isNotEmpty || id.isNotEmpty) {
              Get.toNamed(
                Routes.JOIN_REQUEST_DETAIL,
                arguments: JoinRequestDetailParameter(
                  requestId: targetRequestId.isNotEmpty ? targetRequestId : null,
                  notificationId: id.isNotEmpty ? id : null,
                ),
              );
            } else if (targetTeamId.isNotEmpty) {
              Get.toNamed(Routes.RESCUE_TEAM_DETAIL, arguments: RescueTeamDetailParameter(teamId: targetTeamId));
            } else {
              Get.toNamed(Routes.JOIN_TEAM_REQUEST_LIST);
            }
            break;
          default:
            Get.toNamed(Routes.JOIN_TEAM_REQUEST_LIST);
            break;
        }
        break;
      case NotiTypeUtils.announcement:
        if (id.isEmpty) return;
        Get.toNamed(Routes.NOTIFICATION_DETAIL, arguments: NotificationDetailParameter(notificationId: id));
        break;
      case NotiTypeUtils.teamMembership:
        if (action == NotiActionUtils.kicked) {
          final wasOnTeamPage = _isOnTeamRelatedPage();
          _handleKickedFromTeam(showDialogIfNeeded: true, reasonKicked: reasonKicked, content: content);
          if (!wasOnTeamPage && id.isNotEmpty) {
            Get.toNamed(Routes.NOTIFICATION_DETAIL, arguments: NotificationDetailParameter(notificationId: id));
          }
        } else if (id.isNotEmpty) {
          Get.toNamed(Routes.NOTIFICATION_DETAIL, arguments: NotificationDetailParameter(notificationId: id));
        }
        break;
      default:
        if (id.isNotEmpty) {
          Get.toNamed(Routes.NOTIFICATION_DETAIL, arguments: NotificationDetailParameter(notificationId: id));
        }
        break;
    }
  }

  void _hardReloadService(Map<String, dynamic> payload) {
    final data = payload['data'] is Map ? Map<String, dynamic>.from(payload['data'] as Map) : payload;
    final type = data['type']?.toString() ?? '';
    loggerHelper.log('Hard reload service for type: $type');

    switch (type) {
      case NotiTypeUtils.announcement:
        _addIncomingNotification(data);
        break;
      case NotiTypeUtils.joinRequest:
        _addIncomingNotification(data);
        _handleJoinRequestRealtime(FcmNotificationModel.fromJson(data));
        break;
      case NotiTypeUtils.teamMembership:
        _addIncomingNotification(data);
        _handleTeamMembershipRealtime(FcmNotificationModel.fromJson(data));
        break;
      default:
        break;
    }
  }

  void _handleJoinRequestRealtime(FcmNotificationModel fcm) {
    final requestId = fcm.requestId?.trim() ?? '';
    final action = fcm.action;

    if (Get.isRegistered<JoinTeamRequestListController>()) {
      final joinController = Get.find<JoinTeamRequestListController>();

      switch (action) {
        case NotiActionUtils.accepted:
          joinController.updateMyRequestStatus(requestId: requestId, status: JoinTeamRequestStatusUtils.accepted);
          break;
        case NotiActionUtils.rejected:
          joinController.updateMyRequestStatus(requestId: requestId, status: JoinTeamRequestStatusUtils.rejected);
          break;
        case NotiActionUtils.created:
          joinController.requestListController.onRefresh();
          break;
      }
    }

    if (action == NotiActionUtils.created && Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().fetchJoinRequestCount();
    }

    if (action == NotiActionUtils.accepted && Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().fetchProfile();
    }

    if ((action == NotiActionUtils.accepted || action == NotiActionUtils.rejected) &&
        Get.isRegistered<RescueTeamListController>()) {
      Get.find<RescueTeamListController>().fetchCurrentJoinRequests();
    }
  }

  void _handleTeamMembershipRealtime(FcmNotificationModel fcm) {
    if (fcm.action != NotiActionUtils.kicked) return;
    _handleKickedFromTeam(showDialogIfNeeded: true, reasonKicked: fcm.resolvedReasonKicked, content: fcm.content);
  }

  Future<void> _handleKickedFromTeam({required bool showDialogIfNeeded, String? reasonKicked, String? content}) async {
    final isOnTeamPage = _isOnTeamRelatedPage();

    if (isOnTeamPage) {
      Get.until((route) => route.settings.name == Routes.DASHBOARD || route.isFirst);
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().goToTab(4);
      }
    }

    if (Get.isRegistered<DashboardController>()) {
      await Get.find<DashboardController>().fetchProfile();
    }

    if (showDialogIfNeeded && isOnTeamPage) {
      final reason = reasonKicked?.trim() ?? '';
      final dialogContent = reason.isNotEmpty
          ? '${content?.trim().isNotEmpty == true ? content!.trim() : 'kicked_from_team_content'.tr}\n\n${'kicked_from_team_reason'.trParams({'reason': reason})}'
          : (content?.trim().isNotEmpty == true ? content!.trim() : 'kicked_from_team_content'.tr);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isDialogOpen == true) return;
        showAlertDialog(title: 'kicked_from_team_title'.tr, content: dialogContent);
      });
    }
  }

  bool _isOnTeamRelatedPage() {
    final route = Get.currentRoute;
    return route == Routes.REGISTER_RESCUE_TEAM || route == Routes.TEAM_MEMBER_LIST || route == Routes.USER_DETAIL;
  }

  void _addIncomingNotification(Map<String, dynamic> data) {
    if (!Get.isRegistered<NotiController>()) return;

    final payload = Map<String, dynamic>.from(data);
    // Normalize id field so list item has a stable key for dedupe/update.
    final notificationId = payload['notification_id']?.toString().trim() ?? '';
    final id = payload['id']?.toString().trim() ?? '';
    if (notificationId.isEmpty && id.isNotEmpty) {
      payload['notification_id'] = id;
    }
    if ((payload['created_at']?.toString().trim() ?? '').isNotEmpty &&
        (payload['time']?.toString().trim() ?? '').isEmpty) {
      payload['time'] = payload['created_at'];
    }

    final fcmNotification = FcmNotificationModel.fromJson(payload);
    // Routes into system/app list based on notification type (announcement vs others).
    Get.find<NotiController>().addNotification(fcmNotification.toNotificationModel());
  }
}
