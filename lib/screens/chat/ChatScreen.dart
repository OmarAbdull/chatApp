import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'ChatController.dart';

class ChatScreen extends StatelessWidget {
  final ChatController _chatController = Get.put(ChatController());
  final _user = const types.User(id: '1'); // Current user
  final ImagePicker _imagePicker = ImagePicker(); // Image picker instance
  final TextEditingController _textController = TextEditingController(); // Controller for text input

  ChatScreen({super.key, required String conversationId});

  // Function to pick an image from the gallery
  Future<void> _pickAndSendImage() async {
    // Pick an image from the gallery
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Send the image file path to the chat
      _chatController.sendImageMessage(pickedFile.path);
    }
  }

  // Function to send a text message
  void _sendTextMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      final textMessage = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().toString(),
        text: text,
      );
      _chatController.sendMessage(textMessage);
      _textController.clear(); // Clear the text field
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Username'),
      ),
      body: Obx(
            () => Chat(
              theme: DefaultChatTheme(secondaryColor: Colors.grey),
          messages: _chatController.messages.reversed.toList(), // Reverse messages
          onSendPressed: (types.PartialText message) {
            final textMessage = types.TextMessage(
              author: _user,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: DateTime.now().toString(),
              text: message.text,
            );
            _chatController.sendMessage(textMessage);
          },
          user: _user,
          // Replace the default input area with a custom widget
          customBottomWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Button to pick an image from the gallery
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickAndSendImage,
                ),
                // Button to take a photo
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      _chatController.sendImageMessage(pickedFile.path);
                    }
                  },
                ),
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onSubmitted: (text) => _sendTextMessage(),
                  ),
                ),
                // Button to send the text message
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendTextMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}