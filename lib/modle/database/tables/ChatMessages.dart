// lib/modle/database/chat_messages_table.dart

import 'package:sqflite/sqflite.dart';

class ChatMessages {
  static const String tableName = 'ChatMessages';

  static const String columnId = 'id';
  static const String columnSender = 'sender';
  static const String columnMessage = 'message';
  static const String columnTimestamp = 'timestamp';
  static const String columnIsRead = 'isRead';

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnSender TEXT,
      $columnMessage TEXT,
      $columnTimestamp INTEGER,
      $columnIsRead INTEGER DEFAULT 0
    )
  ''';
}
