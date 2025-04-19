// lib/modle/data/MessageData.dart

enum MessageTypes { text, image }

class MessageData {
  final int id;
  final int chatId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final bool senderIsMe;
  final MessageTypes type;

  MessageData({
    this.id = 0,
    required this.chatId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.senderIsMe,
    required this.type,
  });

  // Add copyWith method
  MessageData copyWith({
    int? id,
    int? chatId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    bool? senderIsMe,
    MessageTypes? type,
  }) {
    return MessageData(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      senderIsMe: senderIsMe ?? this.senderIsMe,
      type: type ?? this.type,
    );
  }
}