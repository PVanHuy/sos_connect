import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/model/chat/sos_chat_history_model.dart';
import 'package:sos_connect/model/chat/sos_chat_message_model.dart';
import 'package:sos_connect/model/chat/sos_chat_other_party_model.dart';
import 'package:sos_connect/pages/dashboard/dashboard_controller.dart';
import 'package:sos_connect/pages/sos_chat/sos_chat_parameter.dart';
import 'package:sos_connect/resourese/service/socket/sos_chat_socket_service.dart';
import 'package:sos_connect/resourese/sos_chat/isos_chat_repository.dart';
import 'package:sos_connect/utils/app_constants.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';

class SosChatController extends GetxController {
  SosChatController({required this.sosChatRepository, required this.chatSocketService, required this.parameter});

  final ISosChatRepository sosChatRepository;
  final SosChatSocketService chatSocketService;
  final SosChatParameter parameter;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final messages = <SosChatMessageModel>[].obs;
  final otherParty = Rxn<SosChatOtherPartyModel>();
  final pagination = Rxn<SosChatPaginationModel>();

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isSending = false.obs;
  final inputValue = ''.obs;
  final isShowScrollToBottom = false.obs;
  final isShowNewMessScroll = false.obs;

  String get sosId => parameter.sosId.trim();

  String get title {
    final otherName = otherParty.value?.name?.trim() ?? '';
    if (otherName.isNotEmpty) return otherName;
    if (parameter.title?.trim().isNotEmpty == true) return parameter.title!.trim();
    return 'sos_chat_title'.tr;
  }

  String get otherPartyAvatar => otherParty.value?.avatar?.trim() ?? '';

  String get currentUserId {
    if (!Get.isRegistered<DashboardController>()) return '';
    return Get.find<DashboardController>().userModel.value?.id?.trim() ?? '';
  }

  bool get hasNextPage => pagination.value?.hasNext ?? false;

  bool isMine(SosChatMessageModel message) {
    final me = currentUserId;
    if (me.isEmpty) return false;
    return (message.senderId?.trim() ?? '') == me;
  }

  @override
  void onInit() {
    super.onInit();
    messageController.addListener(() {
      inputValue.value = messageController.text;
    });
    scrollController.addListener(_scrollListener);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (sosId.isEmpty) {
      DialogUtils.showErrorDialog('sos_chat_invalid_sos'.tr);
      return;
    }

    isLoading.value = true;
    try {
      await fetchMessages();
      await chatSocketService.ensureConnected();
      chatSocketService.onNewMessage(_onNewMessage);
      chatSocketService.onJoined(_onJoined);
      chatSocketService.joinRoom(sosId);
      scrollToBottom();
    } catch (e) {
      loggerHelper.error('SosChat bootstrap error: $e');
      DialogUtils.showErrorDialog('sos_chat_connect_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void _onJoined(String joinedSosId, SosChatOtherPartyModel? party) {
    if (isClosed) return;
    if (joinedSosId.isNotEmpty && joinedSosId != sosId) return;
    if (party == null) return;
    otherParty.value = party;
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;

    final position = scrollController.position;
    // reverse:true → pixels ~0 is bottom (newest); maxScrollExtent is top (oldest)
    final nearBottom = position.pixels <= 80;
    if (!nearBottom && !isShowScrollToBottom.value) {
      isShowScrollToBottom.value = true;
    } else if (nearBottom && isShowScrollToBottom.value) {
      isShowScrollToBottom.value = false;
      isShowNewMessScroll.value = false;
    }

    if (position.maxScrollExtent <= 0) return;
    if (position.pixels >= position.maxScrollExtent - 80) {
      fetchMessages(isRefresh: false);
    }
  }

  Future<void> fetchMessages({bool isRefresh = true}) async {
    try {
      if (!isRefresh) {
        if (isLoadingMore.value || isLoading.value || !hasNextPage) return;
        isLoadingMore.value = true;
      }

      final nextPage = isRefresh ? 1 : ((pagination.value?.page ?? 1) + 1);
      final result = await sosChatRepository.getChatHistory(sosId, page: nextPage);

      if (isRefresh) {
        messages.assignAll(result.models);
        otherParty.value = result.otherParty;
      } else {
        final existingIds = messages.map((m) => m.id).whereType<String>().toSet();
        final older = result.models.where((m) {
          final id = m.id?.trim() ?? '';
          return id.isNotEmpty && !existingIds.contains(id);
        });
        messages.addAll(older);
      }
      pagination.value = result.pagination;
    } catch (e) {
      loggerHelper.error('SosChat fetchMessages error: $e');
      if (isRefresh) {
        DialogUtils.showErrorDialog('sos_chat_load_failed'.tr);
      }
    } finally {
      if (!isRefresh) {
        isLoadingMore.value = false;
      }
    }
  }

  void _onNewMessage(SosChatMessageModel message) {
    if (isClosed) return;
    final messageSosId = message.sosId?.trim() ?? '';
    final messageId = message.id?.trim() ?? '';
    if (messageSosId.isNotEmpty && messageSosId != sosId) return;
    if (messageId.isEmpty) return;
    if (messages.any((m) => m.id == messageId)) return;

    messages.insert(0, message);

    if (isShowScrollToBottom.value) {
      isShowNewMessScroll.value = true;
    } else {
      scrollToBottom();
    }
  }

  void sendMessage() {
    final content = messageController.text.trim();
    if (content.isEmpty || isSending.value || sosId.isEmpty) return;

    final limitedContent = content.length > AppConstants.maxSosChatMessageLength
        ? content.substring(0, AppConstants.maxSosChatMessageLength)
        : content;

    isSending.value = true;
    try {
      chatSocketService.sendMessage(sosId: sosId, content: limitedContent);
      messageController.clear();
      inputValue.value = '';
      scrollToBottom();
    } catch (e) {
      loggerHelper.error('SosChat sendMessage error: $e');
      DialogUtils.showErrorDialog('sos_chat_send_failed'.tr);
    } finally {
      isSending.value = false;
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      isShowNewMessScroll.value = false;
      isShowScrollToBottom.value = false;
    });
  }

  @override
  void onClose() {
    chatSocketService.offNewMessage(_onNewMessage);
    chatSocketService.offJoined(_onJoined);
    unawaited(chatSocketService.disconnect());
    scrollController.removeListener(_scrollListener);
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
