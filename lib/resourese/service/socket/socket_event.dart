class SocketEvent {
  static const String userCashTopupRejected = 'user_cash_topup_rejected';
  static const String userOrderCancelled = 'user_order_cancelled';
  static const String userTopupPaymentResult = 'user_topup_payment_result';
  static const String userComputerCommand = 'user_computer_command';
  static const String userWalletUnicornUpdated = 'user_wallet_unicorn_updated';
  static const String commandTypeKey = 'commandType';

  static const String chatMessagesRead = 'chat:messages_read';
  static const String chatUserTyping = 'chat:user_typing';
  static const String chatSessionEnded = 'chat:session_ended';
  static const String chatNewMessage = 'chat:new_message';
  static const String chatJoinSession = 'chat:join_session';
  static const String chatTyping = 'chat:typing';

  static const String userSessionWarning = 'user_session_warning';

  static const String userAccountDeactivated = 'user_account_deactivated';
}

class SocketCommandType {
  static const String lock = 'lock';
  static const String restart = 'restart';
  static const String shutdown = 'shutdown';

  static const Set<String> logoutCommands = {lock, restart, shutdown};
}
