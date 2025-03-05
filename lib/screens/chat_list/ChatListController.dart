import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';
import '../../modle/data/ChatMessageData.dart';
import '../../modle/data/MessageData.dart';
import '../../modle/database/App_db.dart';

class ChatListController extends GetxController {
  var chatList = <ChatMessageData>[].obs;
  var isLoading = true.obs;
  final noScreenshot = NoScreenshot.instance;

  @override
  void onInit() {
    saveChats();
    fetchChats();
    disableScreenshot();
    super.onInit();
  }

  void fetchChats() async {
    try {
      isLoading(true);
      chatList.assignAll(await AppDatabase().getAllChats());
      print(chatList);
    } finally {
      isLoading(false);
    }
  }

  void saveChats() async {
    try {
      isLoading(true);
      await Future.delayed(Duration(seconds: 2));

      List<ChatMessageData> chats = [
        ChatMessageData(
          id: 1,
          senderName: 'John Doe',
          messages: [
            Message(text: 'Hey, how are you?', timestamp: DateTime.now().subtract(Duration(minutes: 5)), isRead: false),
            Message(text: 'What’s up?', timestamp: DateTime.now().subtract(Duration(minutes: 3)), isRead: false),
          ],
          avatarUrl: 'https://picsum.photos/200/200', // Avatar for John Doe
        ),
        ChatMessageData(
          id: 2,
          senderName: 'Jane Smith',
          messages: [
            Message(text: 'See you tomorrow!', timestamp: DateTime.now().subtract(Duration(hours: 2)), isRead: true),
          ],
          avatarUrl: 'https://picsum.photos/201/201', // Avatar for Jane Smith
        ),
      ];

      await AppDatabase().insertChatMessages(chats);

      List<ChatMessageData> savedChats = await AppDatabase().getAllChats();
      print("Saved chats in the database: $savedChats");

      chatList.assignAll(savedChats);
    } finally {
      isLoading(false);
    }
  }

  void disableScreenshot() async {
    noScreenshot.screenshotOff();
  }
}
