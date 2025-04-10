// bottom_nav_controller.dart
import 'dart:async';

import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import '../../modle/WebSocketService.dart';
import '../../modle/api/ApiServixe.dart';
import '../../modle/data/ChatMessageData.dart';
import '../../modle/data/MessageData.dart';
import '../../modle/database/App_db.dart';

class BottomNavController extends GetxController {
  final ApiService _apiService = ApiService();

  final currentIndex = 0.obs;
  final WebSocketService webSocketService = WebSocketService();
  late final StreamSubscription _messageSubscription;

  @override
  void onInit() {
    super.onInit();
    _initWebSocket();
  }

  Future<void> _initWebSocket() async {
    try {
      await webSocketService.connect();
      _messageSubscription = webSocketService.messages.listen(_handleMessage);
    } catch (e) {
      Get.snackbar('Connection Error', 'Failed to connect to chat service');
    }
  }

  Future<void> checkUserAndStartChat(int userId) async {
    try {
      final response = await _apiService.authenticatedPost(
        'Users/getUserData',
        {"ID": userId, "PhoneNumber": null},
      );

      if (response['code'] == 1000) {
        final userData = response['result'];
        final userKey = userData['userKey'] as String;
        final String base64image = userData['userImage'] ?? '';
        final senderName = userData['name'] ?? 'Unknown';

        String? processedImage = base64image;
        if (base64image.contains(',')) {
          processedImage = base64image.split(',').last;
        }

        final appDatabase = AppDatabase();
        await appDatabase.insertOrUpdateChat(
          id: userId,
          senderName: senderName,
          userKey: userKey,
          avatarBase64: processedImage,
        );

        print("Successfully added user ID: $userId");
        Get.toNamed("/Chat", arguments: userId, preventDuplicates: true);
      } else {
        Get.snackbar('Error', 'User not found on the server');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start chat: ${e.toString()}');
    }
  }

  void _handleMessage(Map<String, dynamic> message) async {
    print('\nReceived message breakdown:');

    // Validate message structure
    if (!message.containsKey('type')) {
      print('Invalid message: Missing type field');
      return;
    }

    // Handle type with type checking
    final messageType = message['type'];
    print('Type: ${messageType ?? "Null"} (${messageType.runtimeType})');

    // Handle target with fallback
    final target = message['target']?.toString() ?? 'No target specified';
    print('Target: $target');

    // Handle arguments with structured validation
    final arguments = message['arguments'];
    if (arguments is! List || arguments.length < 3) {
      print(' Invalid arguments format - expected at least 3 elements');
      return;
    }

    // Extract and validate individual arguments
    try {
      final name = arguments[0]?.toString() ?? 'Unknown';
      final phoneNumber = arguments[1]?.toString() ?? 'Not provided';
      final id = (arguments[2] is num ? arguments[2].toInt() : 0);

      print('Name: $name ');
      print('Phone: $phoneNumber ');
      print('ID: $id ');

      // Database check and handling
      if (id != 0) {
        final appDatabase = AppDatabase();
        ChatMessageData? existingChat = await appDatabase.getChatById(id);
        String? decryptedContent;
        String? userKey;

        if (existingChat == null) {
          await checkUserAndStartChat(id);
          existingChat = await appDatabase.getChatById(id);
        }
        if (existingChat != null) {
          userKey = existingChat.userKey;
          if (userKey.isNotEmpty) {
            try {
              decryptedContent = decryptMessage(message['target'], userKey);
            } catch (e) {
              print('Decryption error: $e');
              Get.snackbar('Error', 'Failed to decrypt message');
              decryptedContent =
                  message['target']?.toString() ?? 'Undecryptable message';
            }
          }
        }

        final newMessage = MessageData(
          chatId: id,
          content: decryptedContent ??
              message['target']?.toString() ??
              'Unknown message',
          timestamp: DateTime.now(),
          isRead: false,
          senderIsMe: false,
          type:
              MessageTypes.values[message['type'] is int ? message['type'] : 0],
        );
        await appDatabase.insertMessage(newMessage);
      }
    } catch (e) {
      print('Error handling message: $e');
      Get.snackbar('Error', 'Failed to process chat message');
    }
  }

  String decryptMessage(String encryptedBase64, String key) {
    final keyBytes = Key.fromUtf8(key.padRight(32, ' ')); // 32-byte key
    final encrypter = Encrypter(AES(keyBytes, mode: AESMode.ecb)); // ECB mode
    final encrypted = Encrypted.fromBase64(encryptedBase64);
    return encrypter.decrypt(encrypted);
  }

  @override
  void onClose() {
    _messageSubscription.cancel();
    webSocketService.disconnect();
    super.onClose();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
