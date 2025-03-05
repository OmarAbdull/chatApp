class ChatMessages {
  static const String tableName = 'ChatMessages';

  static const String columnId = 'id';
  static const String columnSender = 'sender';
  static const String columnMessage = 'message';
  static const String columnTimestamp = 'timestamp';
  static const String columnIsRead = 'isRead';
  static const String columnImage = 'image'; // New column for image

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnSender TEXT,
      $columnMessage TEXT,
      $columnTimestamp INTEGER,
      $columnIsRead INTEGER DEFAULT 0,
      $columnImage TEXT  -- Store image path or URL
    )
  ''';
}
