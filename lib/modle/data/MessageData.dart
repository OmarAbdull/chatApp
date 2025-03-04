class Message {
  final String text;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'],
    );
  }
}