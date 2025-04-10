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
    super.onInit();
    final db = AppDatabase();
    // Listen for database updates
    db.chatUpdates.listen((_) => fetchChats());
    fetchChats();
    disableScreenshot();
  }

  void fetchChats() async {
    try {
      isLoading(true);
      chatList.assignAll(await AppDatabase().getAllChats());
      chatList.forEach((chat){
        chat.messages.forEach((message){
          print("chat Id : ${message.id} chat message : ${message.content}");
        });
      });


    } finally {
      isLoading(false);
    }
    print("Chat List :$chatList");
  }

  void saveChats() async {
    try {
      // List<ChatMessageData> chats = [
      //   ChatMessageData(
      //
      //     id: 1,
      //     senderName: 'John Doe',
      //     messages: [
      //       MessageData(
      //         chatId: 2,
      //         content: 'Hey, how are you?',
      //         timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      //         isRead: false,
      //         senderIsMe: false,
      //         type: MessageTypes.text,
      //       ),
      //       MessageData(
      //         chatId: 2,
      //         content: 'What’s up?',
      //         timestamp: DateTime.now().subtract(Duration(minutes: 3)),
      //         isRead: false,
      //         senderIsMe: false,
      //         type: MessageTypes.text,
      //       ),
      //     ],
      //   ),
      // ];

      // await AppDatabase().insertChatMessages();

      List<ChatMessageData> savedChats = await AppDatabase().getAllChats();
      print("Saved chats in the database: $savedChats");
    } finally {
      isLoading(false);
    }
  }

  void disableScreenshot() async {
    noScreenshot.screenshotOff();
  }
}
