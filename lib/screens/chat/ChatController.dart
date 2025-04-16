import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:no_screenshot/no_screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modle/api/ApiServixe.dart';
import '../../modle/data/ChatMessageData.dart';
import '../../modle/data/MessageData.dart';
import '../../modle/database/App_db.dart';

class ChatController extends GetxController {
  var messages = <types.Message>[].obs;
  var sender = "".obs;
  final noScreenshot = NoScreenshot.instance;
  final AppDatabase _database = AppDatabase();
  int? currentChatId;
  SharedPreferences? _prefs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    disableScreenshot();
    _database.chatUpdates.listen((chatId) {
      if (currentChatId == chatId) {
        loadMessages(chatId);
      }
    });
    _initializeSharedPreferences();
    super.onInit();
  }

  void setCurrentChatId(int chatId) {
    currentChatId = chatId;
  }

  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  ///Send Message
  void sendMessage(types.Message message) async {
    print("image :${MessageTypes.image}");
    final userKey = _prefs?.getString("user_key");
    if (message is types.TextMessage) {

      // final encryptedText = encryptMessage(message.text, userKey!);

      final requestBody = {
        "receiverID": currentChatId,
        "messageContent": message.text,
        "messageType": 0,
        "messageState": 1,
        "isRead": false,
        "isText": true,
      };
      // Save text message to database

      try {

        final messageData = MessageData(
          chatId: currentChatId!,
          content: message.text,
          timestamp: DateTime.now(),
          isRead: true,
          senderIsMe: true,
          type: MessageTypes.text,
        );
        await _database.insertMessage(messageData);
        loadMessages(currentChatId!);

        await _apiService.authenticatedPost('Chat/SendMessage', requestBody);

      } catch (e) {
        print('Error sending text message: $e');
      }
    }
    update();
  }
  void sendImageMessage(String imagePath) async {
    final userKey = _prefs?.getString("user_key");

    // final imageMessage = types.ImageMessage(
    //   author: const types.User(id: '0'),
    //   createdAt: DateTime.now().millisecondsSinceEpoch,
    //   id: DateTime.now().toString(),
    //   name: 'image.jpg',
    //   size: 1024,
    //   uri: 'file://$imagePath',
    // );

    // Save image message to database
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);
      final messageData = MessageData(
        chatId: currentChatId!,
        content: imagePath,
        timestamp: DateTime.now(),
        isRead: true,
        senderIsMe: true,
        type: MessageTypes.image,
      );
      await _database.insertMessage(messageData);
      loadMessages(currentChatId!);

      final requestBody = {
        "receiverID": currentChatId,
        "messageContent": base64Image,
        "messageType": 1, // Adjust based on your API's requirements
        "messageState": 1,
        "isRead": false,
        "isText": false,
      };

      await _apiService.authenticatedPost('Chat/SendMessage', requestBody);

    } catch (e) {
      print('Error sending image message: $e');
    }

  }

  ///Get Message
  void loadMessages(int id) async {
    try {
       await _database.markMessagesAsRead(id);
      print("id__ $id");
      ChatMessageData? chat = await _database.getChatById(id);
      print("sender ${chat?.senderName}");
      sender.value = chat?.senderName ?? "Unknown";
       print("sender $sender}");

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

  /// Encryption and Decryption
  String encryptMessage(String text, String key) {
    final keyBytes = Key.fromUtf8(key.padRight(32, ' ')); // 32-byte key
    final encrypter = Encrypter(AES(keyBytes, mode: AESMode.ecb)); // ECB mode
    final encrypted = encrypter.encrypt(text);
    return encrypted.base64;
  }

  void disableScreenshot() async {
    noScreenshot.screenshotOff();
  }
}
