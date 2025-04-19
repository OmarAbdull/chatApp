import 'dart:async';

import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';
import '../../modle/data/ChatMessageData.dart';
import '../../modle/database/App_db.dart';

class ChatListController extends GetxController {
  var chatList = <ChatMessageData>[].obs;
  StreamSubscription? _dbUpdateSubscription;
  var isLoading = true.obs;
  final noScreenshot = NoScreenshot.instance;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
    _dbUpdateSubscription = AppDatabase().chatUpdates.listen((_) {
      fetchChats(); // Refresh chat list when DB changes
    });
    disableScreenshot();
  }

  @override
  void onClose() {
    _dbUpdateSubscription?.cancel(); // Proper cleanup here
    super.onClose();
  }

  void fetchChats() async {
    try {
      isLoading(true);
      final chats = await AppDatabase().getAllChats();
      chatList.assignAll(
          chats?.map((c) => ChatMessageData(
            id: c.id,
            senderName: c.senderName,
            userKey: c.userKey,
            avatarBase64: c.avatarBase64,
            messages: List.from(c.messages),
          )).toList() ?? []
      );
    } finally {
      isLoading(false);
    }
  }
  // Inside ChatListController
  void markMessagesAsRead(int chatId) async {
    try {
      // Update local state
      final index = chatList.indexWhere((chat) => chat.id == chatId);
      if (index != -1) {
        final chat = chatList[index];
        final updatedMessages = chat.messages.map((message) => message.copyWith(isRead: true)).toList();
        chatList[index] = chat.copyWith(messages: updatedMessages);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark messages as read');
    }
  }

  void disableScreenshot() async {
    noScreenshot.screenshotOff(); // Only handle screenshot
  }
}