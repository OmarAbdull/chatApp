import 'dart:async';

import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';
import '../../modle/data/ChatMessageData.dart';
import '../../modle/data/MessageData.dart';
import '../../modle/database/App_db.dart';

import 'dart:async';
import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';
import '../../modle/data/ChatMessageData.dart';
import '../../modle/data/MessageData.dart';
import '../../modle/database/App_db.dart';

class ChatListController extends GetxController {
  var chatList = <ChatMessageData>[].obs;
  StreamSubscription? _dbUpdateSubscription;
  var isLoading = true.obs;
  final noScreenshot = NoScreenshot.instance;

  @override
  void onInit() {
    super.onInit();
    final db = AppDatabase();
    _dbUpdateSubscription = db.chatUpdates.listen((chatId) {
      fetchChats(); // Refresh whenever any chat updates
    });
    fetchChats();
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
          ))?.toList() ?? []
      );
    } finally {
      isLoading(false);
    }
  }

  void disableScreenshot() async {
    noScreenshot.screenshotOff(); // Only handle screenshot
  }
}