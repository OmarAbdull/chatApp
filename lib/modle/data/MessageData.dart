// lib/modle/data/MessageData.dart

enum MessageTypes { text, image }
class MessageData {
  final int id; // Add this
  final int chatId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final bool senderIsMe;
  final MessageTypes type;

  MessageData({
    this.id = 0, // Add this
    required this.chatId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.senderIsMe,
    required this.type,
  });
}