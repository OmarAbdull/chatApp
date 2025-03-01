// controllers/chat_controller.dart
import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';
import '../../modle/data/ChatMessage.dart';

class ChatListController extends GetxController {
  var chatList = <ChatMessage>[].obs;
  var isLoading = true.obs;
  final noScreenshot = NoScreenshot.instance; // Add NoScreenshot instance

  @override
  void onInit() {
    fetchChats();
    disableScreenshot(); // Call disableScreenshot here
    super.onInit();
  }

  void fetchChats() async {
    try {
      isLoading(true);
      await Future.delayed(Duration(seconds: 2));
      chatList.assignAll([
        ChatMessage(
          id: '1',
          senderName: 'John Doe',
          lastMessage: 'Hey, how are you?',
          timestamp: DateTime.now().subtract(Duration(minutes: 5)),
          avatarUrl: 'https://picsum.photos/300/300',
          unreadCount: 2,
          isOnline: true,
        ),
        ChatMessage(
          id: '2',
          senderName: 'Jane Smith',
          lastMessage: 'See you tomorrow!',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          avatarUrl: 'https://picsum.photos/300/300',
          unreadCount: 0,
          isOnline: false,
        ),
        ChatMessage(
          id: '3',
          senderName: 'Alice Johnson',
          lastMessage: 'Let’s catch up later.',
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
          avatarUrl: 'https://picsum.photos/300/300',
          unreadCount: 1,
          isOnline: true,
        ),
        ChatMessage(
          id: '4',
          senderName: 'Bob Brown',
          lastMessage: 'Can you send me the files?',
          timestamp: DateTime.now().subtract(Duration(hours: 3, minutes: 15)),
          avatarUrl: 'https://picsum.photos/300/300',
          unreadCount: 3,
          isOnline: false,
        ),
        ChatMessage(
          id: '5',
          senderName: 'Emma Wilson',
          lastMessage: 'I’m at the meeting now.',
          timestamp: DateTime.now().subtract(Duration(minutes: 10)),
          avatarUrl: 'https://picsum.photos/300/300',
          unreadCount: 0,
          isOnline: true,
        ),
        ChatMessage(
          id: '6',
          senderName: 'Liam Martinez',
          lastMessage: 'Great job on the project!',
          timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
          avatarUrl: 'https://picsum.photos/300/300',
          unreadCount: 5,
          isOnline: false,
        ),
        ChatMessage(
          id: '7',
          senderName: 'Sophia Lee',
          lastMessage: 'Let’s meet up this weekend.',
          timestamp: DateTime.now().subtract(Duration(hours: 5)),
          avatarUrl: 'https://picsum.photos/300/300',
          unreadCount: 0,
          isOnline: true,
        ),
        ChatMessage(
          id: '8',
          senderName: 'William Davis',
          lastMessage: 'Call me when you’re free.',
          timestamp: DateTime.now().subtract(Duration(minutes: 45)),
          avatarUrl: 'https://picsum.photos/300/300',
          unreadCount: 2,
          isOnline: false,
        ),
      ]);
    } finally {
      isLoading(false);
    }
  }

  // Add disableScreenshot method
  void disableScreenshot() async {
    bool result = await noScreenshot.screenshotOff();
  }
}