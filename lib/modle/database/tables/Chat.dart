class Chat {
  static const tableName = 'chats';
  static const columnId = 'id';
  static const columnSenderName = 'sender_name';
  static const columnUserKey = 'user_key';
  static const columnAvatarBase64 = 'avatar_base64';

  static String get createTableQuery => '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnSenderName TEXT NOT NULL,
      $columnUserKey TEXT NOT NULL,
      $columnAvatarBase64 TEXT
    )
  ''';
}