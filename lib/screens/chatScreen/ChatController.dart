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
  }

  // Send an image message
  void sendImageMessage(String imagePath) {
    final imageMessage = types.ImageMessage(
      author: const types.User(id: '1'), // Current user
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      name: 'image.jpg', // Name of the image file
      size: 1024, // Size of the image in bytes
      uri: imagePath, // File path of the image
    );
    messages.add(imageMessage);
  }

  // Receive a text message
  void receiveMessage(String text) {
    final receivedMessage = types.TextMessage(
      author: const types.User(id: '2', firstName: "Bot"), // Different user ID for received message
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text: text,
    );
    messages.add(receivedMessage);
  }

  // Disable screenshots
  void disableScreenshot() async {
    bool result = await noScreenshot.screenshotOff();
  }
}