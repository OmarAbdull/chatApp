import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'ChatController.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    _chatController.setCurrentChatId(widget.chatId);
    _chatController.loadMessages(widget.chatId);
  }

  final _user = const types.User(id: '0');

  // Current user
  final ImagePicker _imagePicker = ImagePicker();

  // Image picker instance
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Username'),
      ),
      body: GetBuilder<ChatController>(builder: (controller) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
        return Chat(
          theme: DefaultChatTheme(
            primaryColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              secondaryColor: Colors.grey),
          messages: controller.messages,
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
          customBottomWidget: _buildInputArea(),
        );
      }),
    );
  }

  Widget _buildInputArea() {
    return Padding(
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
              final pickedFile =
                  await _imagePicker.pickImage(source: ImageSource.camera);
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
    );
  }

  // Function to pick an image from the gallery
  Future<void> _pickAndSendImage() async {
    // Pick an image from the gallery
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

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
}
