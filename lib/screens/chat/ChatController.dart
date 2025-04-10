import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:no_screenshot/no_screenshot.dart';

import '../../modle/data/ChatMessageData.dart';
import '../../modle/data/MessageData.dart';
import '../../modle/database/App_db.dart';

class ChatController extends GetxController {
  var messages = <types.Message>[].obs;
  final noScreenshot = NoScreenshot.instance;
  final AppDatabase _database = AppDatabase();
  int? currentChatId;

  @override
  void onInit() {
    disableScreenshot();
    _database.chatUpdates.listen((chatId) {
      if (currentChatId == chatId) {
        loadMessages(chatId);
      }
    });
    super.onInit();
  }
  void setCurrentChatId(int chatId) {
    currentChatId = chatId;
  }
  void sendMessage(types.Message message) async {
    if (message is types.TextMessage) {
      // Save text message to database
      final messageData = MessageData(
        chatId: currentChatId!,
        content: message.text,
        timestamp: DateTime.now(),
        isRead: true,
        senderIsMe: true,
        type: MessageTypes.text,
      );
      await _database.insertMessage(messageData);

      final encryptedText = encryptMessage(message.text, "ojughjvghj");
      print(encryptedText);
      decryptMessage(encryptedText, "ojughjvghj");
    }
    update();
    receiveMessage("Hi");

  }
  void loadMessages(int id) async {

    try {
      print("id__ $id");
      ChatMessageData? chat = await _database.getChatById(id);
      chat?.messages.forEach((message) {
        print("Chat Id : ${message.id} Chat Message : ${message.content}");
      });

      if (chat != null) {
        final sortedMessages = chat.messages.toList()
          ..sort((b, a) => a.timestamp.compareTo(b.timestamp));
        final convertedMessages = sortedMessages.map((message) {
          // Determine the author based on senderIsMe flag
          final author = message.senderIsMe
              ? const types.User(id: '0') // Current user
              : types.User(id: '2', firstName: chat.senderName); // Other user

          // Handle different message types
          if (message.type == MessageTypes.text) {
            return types.TextMessage(
              author: author,
              createdAt: message.timestamp.millisecondsSinceEpoch,
              id: message.id.toString(),
              text: message.content,
            );
          } else {
            return types.ImageMessage(
              author: author,
              createdAt: message.timestamp.millisecondsSinceEpoch,
              id: message.id.toString(),
              uri: message.content,
              name: 'image.jpg',
              size: 1024,
            );
          }
        }).toList();

        print("++++++++++");
        print(convertedMessages);
        messages.assignAll(convertedMessages);
        update(); // Notify UI to rebuild
      }
    } catch (e) {
      print('Error loading messages: $e');
      messages.assignAll([]); // Fallback to empty list
    }
  }
  void sendImageMessage(String imagePath) async {
    final imageMessage = types.ImageMessage(
      author: const types.User(id: '0'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      name: 'image.jpg',
      size: 1024,
      uri: 'file://$imagePath',
    );

    // Save image message to database
    final messageData = MessageData(
      chatId: currentChatId!,
      content: imagePath,
      timestamp: DateTime.now(),
      isRead: true,
      senderIsMe: true,
      type: MessageTypes.image,
    );
    await _database.insertMessage(messageData);
  }
  String encryptMessage(String text, String key) {
    final keyBytes = Key.fromUtf8(key.padRight(32, ' ')); // 32-byte key
    final encrypter = Encrypter(AES(keyBytes, mode: AESMode.ecb)); // ECB mode
    final encrypted = encrypter.encrypt(text);
    return encrypted.base64;
  }
  String decryptMessage(String encryptedBase64, String key) {
    final keyBytes = Key.fromUtf8(key.padRight(32, ' ')); // 32-byte key
    final encrypter = Encrypter(AES(keyBytes, mode: AESMode.ecb)); // ECB mode
    final encrypted = Encrypted.fromBase64(encryptedBase64);
    return encrypter.decrypt(encrypted);
  }
  void receiveMessage(String text) async {
    // Save received message to database
    final messageData = MessageData(
      chatId: currentChatId!,
      content: text,
      timestamp: DateTime.now(),
      isRead: false,
      senderIsMe: false,
      type: MessageTypes.text,
    );
    await _database.insertMessage(messageData);
    update();
  }
  void disableScreenshot() async {
    noScreenshot.screenshotOff();
  }
}
