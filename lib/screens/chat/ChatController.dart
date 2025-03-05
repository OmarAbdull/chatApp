import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:no_screenshot/no_screenshot.dart';

class ChatController extends GetxController {
  var messages = <types.Message>[].obs;
  final noScreenshot = NoScreenshot.instance;

  @override
  void onInit() {
    disableScreenshot();
    super.onInit();
  }

  // Send a text message
  void sendMessage(types.Message message) {
    messages.add(message);
    // Simulate receiving a response after sending a message
    Future.delayed(Duration(seconds: 1), () {
      receiveMessage("This is an auto-reply!");
    });
    if (message is types.TextMessage) {
      // Ensure it's a TextMessage
      final encryptedText = encryptMessage(message.text, "ojughjvghj");
      print("__________________________");
      print(encryptedText);
      decryptMessage(encryptedText, "ojughjvghj");
      print("__________________________");
      print(decryptMessage(encryptedText, "ojughjvghj"));

    }
  }

  // Send an image message
  void sendImageMessage(String imagePath) {
    final imageMessage = types.ImageMessage(
      author: const types.User(id: '1'),
      // Current user
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      name: 'image.jpg',
      // Name of the image file
      size: 1024,
      // Size of the image in bytes
      uri: imagePath, // File path of the image
    );
    messages.add(imageMessage);
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
  }  // Receive a text message

  void receiveMessage(String text) {
    final receivedMessage = types.TextMessage(
      author: const types.User(id: '2', firstName: "Bot"),
      // Different user ID for received message
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text: text,
    );
    messages.add(receivedMessage);
  }

  // Disable screenshots
  void disableScreenshot() async {
    noScreenshot.screenshotOff();
  }
}
