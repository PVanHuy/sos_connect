import 'package:sos_connect/pages/chat/models/chat_message_model.dart';
import 'package:sos_connect/resourese/chat/ichat_repository.dart';
import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:sos_connect/utils/logger_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final IChatRepository chatRepository;

  ChatController({required this.chatRepository});

  final TextEditingController messageController = TextEditingController();
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final ScrollController scrollController = ScrollController();
  List<String> get suggestedQuestions => [
        'chat_suggested_question_1'.tr,
        'chat_suggested_question_2'.tr,
        'chat_suggested_question_3'.tr,
        'chat_suggested_question_4'.tr,
        'chat_suggested_question_5'.tr,
        'chat_suggested_question_6'.tr,
        'chat_suggested_question_7'.tr,
        'chat_suggested_question_8'.tr,
        'chat_suggested_question_9'.tr,
        'chat_suggested_question_10'.tr,
        'chat_suggested_question_11'.tr,
        'chat_suggested_question_12'.tr,
      ];

  @override
  void onInit() {
    super.onInit();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    messages.add(
      ChatMessageModel(
        text: 'chat_welcome_message'.tr,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> sendMessage() async {
    if (isClosed) return;

    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final userMessage = ChatMessageModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);
    if (!isClosed) {
      messageController.clear();
    }
    _scrollToBottom();

    isLoading.value = true;

    try {
      final response = await chatRepository.sendChatMessage(message: text);

      if (isClosed) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        String botResponse = '';

        if (response.body is Map) {
          botResponse = response.body['answer'] ?? '';
        } else if (response.body is String) {
          botResponse = response.body;
        }

        if (botResponse.isEmpty) {
          botResponse = 'chat_bot_default_response'.tr;
        }

        final botMessage = ChatMessageModel(
          text: botResponse,
          isUser: false,
          timestamp: DateTime.now(),
        );

        messages.add(botMessage);
      } else {
        String errorMessage = 'chat_bot_error'.tr;
        if (response.body is Map && response.body['message'] != null) {
          errorMessage = response.body['message'];
        }
        DialogUtils.showErrorDialog(errorMessage);

        final errorBotMessage = ChatMessageModel(
          text: errorMessage,
          isUser: false,
          timestamp: DateTime.now(),
        );
        messages.add(errorBotMessage);
      }
    } catch (e) {
      if (isClosed) return;

      loggerHelper.error('Error sending chat message: $e');
      String errorMessage = 'chat_bot_error'.tr;
      DialogUtils.showErrorDialog(errorMessage);

      final errorBotMessage = ChatMessageModel(
        text: errorMessage,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(errorBotMessage);
    } finally {
      if (!isClosed) {
        isLoading.value = false;
        _scrollToBottom();
      }
    }
  }

  void selectSuggestedQuestion(String question) {
    if (isLoading.value || isClosed) return;
    // if (!messageController.hasListeners) return;
    messageController.text = question;
    sendMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
