// models/chat_message.dart
class ChatMessage {
  final String id;
  final String senderName;
  final String lastMessage;
  final DateTime timestamp;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;
  final bool isSentByMe;

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.lastMessage,
    required this.timestamp,
    required this.avatarUrl,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isSentByMe = false,
  });

// Add fromJson method if needed
}