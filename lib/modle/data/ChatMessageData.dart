import 'MessageData.dart';

class ChatMessageData {
  final int id;
  final String senderName;
  final List<Message> messages;  // List of messages
  final String avatarUrl;

  // Calculate unread count based on the number of unread messages
  int get unreadCount => messages.where((msg) => !msg.isRead).length;

  ChatMessageData({
    required this.id,
    required this.senderName,
    required this.messages,
    required this.avatarUrl,
  });
  // Constructor to create a ChatMessage from the API JSON data
  factory ChatMessageData.fromApiJson(Map<String, dynamic> json) {
    var messageList = (json['messages'] as List)
        .map((messageJson) => Message.fromJson(messageJson))
        .toList();

    return ChatMessageData(
      id: json['id'],
      senderName: json['senderName'],
      avatarUrl: json['avatarUrl'],
      messages: messageList,
    );
  }

  factory ChatMessageData.fromJson(Map<String, dynamic> json) {
    return ChatMessageData(
      id: json['id'],
      senderName: json['sender'],
      messages: (json['messages'] as List)
          .map((msg) => Message.fromJson(msg))
          .toList(),
      avatarUrl: json['avatarUrl'],
    );
  }
}

