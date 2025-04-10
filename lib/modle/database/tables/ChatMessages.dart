import 'Chat.dart';

class ChatMessage {
  static const tableName = 'messages';
  static const columnId = 'id';
  static const columnChatId = 'chat_id';
  static const columnContent = 'content';
  static const columnTimestamp = 'timestamp';
  static const columnIsRead = 'is_read';
  static const columnSenderIsMe = 'sender_is_me';
  static const columnType = 'type';
  static String get createTableQuery => '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnChatId INTEGER NOT NULL,
      $columnContent TEXT NOT NULL,
      $columnTimestamp INTEGER NOT NULL,
      $columnIsRead INTEGER DEFAULT 0,
      $columnSenderIsMe INTEGER DEFAULT 0,
      $columnType INTEGER NOT NULL,
      FOREIGN KEY ($columnChatId) REFERENCES ${Chat.tableName}(${Chat.columnId})
    )
  ''';
}