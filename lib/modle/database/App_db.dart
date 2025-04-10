import 'dart:async';
import 'package:chat_app/modle/database/tables/Chat.dart';
import 'package:chat_app/modle/database/tables/ChatMessages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:chat_app/modle/data/ChatMessageData.dart';
import 'package:chat_app/modle/data/MessageData.dart';

// flutter pub run build_runner build
// flutter pub run build_runner watch --delete-conflicting-outputs
class AppDatabase {
  static Database? _database;
  final StreamController<int> _chatUpdateController =
      StreamController<int>.broadcast();

  Stream<int> get chatUpdates => _chatUpdateController.stream;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> deleteDatabase() async {
    await deleteDatabase();
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'chat.db');
    return openDatabase(
      path,
      version: 3, // Incremented version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<bool> chatExists(int chatId) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM ${Chat.tableName} WHERE ${Chat.columnId} = ?',
        [chatId]));
    return count != null && count > 0;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Migrate from old versions
      await db.execute('DROP TABLE IF EXISTS users'); // Remove users table
      await db.execute('''
        CREATE TABLE new_chats (
          id INTEGER PRIMARY KEY,
          sender_name TEXT NOT NULL,
          user_key TEXT NOT NULL,
          avatar_base64 TEXT
        )
      ''');
      await db.execute('''
        INSERT INTO new_chats (id, sender_name, user_key, avatar_base64)
        SELECT id, sender_name, '', avatar_url FROM chats
      ''');
      await db.execute('DROP TABLE chats');
      await db.execute('ALTER TABLE new_chats RENAME TO chats');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(Chat.createTableQuery);
    await db.execute(ChatMessage.createTableQuery);
  }

  Future<int> insertMessage(MessageData message) async {
    final db = await database;
    return await db.insert(
      ChatMessage.tableName,
      {
        ChatMessage.columnChatId: message.chatId,
        ChatMessage.columnContent: message.content,
        ChatMessage.columnTimestamp: message.timestamp.millisecondsSinceEpoch,
        ChatMessage.columnIsRead: message.isRead ? 1 : 0,
        ChatMessage.columnSenderIsMe: message.senderIsMe ? 1 : 0,
        ChatMessage.columnType: message.type.index,
      },
    ).then((id) {
      _chatUpdateController.add(message.chatId);
      return id;
    });
  }

  Future<ChatMessageData> insertOrUpdateChat({
    required int id,
    required String senderName,
    required String userKey,
    required String? avatarBase64,
  }) async {
    final db = await database;
    await db.insert(
      Chat.tableName,
      {
        Chat.columnId: id,
        Chat.columnSenderName: senderName,
        Chat.columnUserKey: userKey,
        Chat.columnAvatarBase64: avatarBase64,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return ChatMessageData(
      id: id,
      senderName: senderName,
      userKey: userKey,
      avatarBase64: avatarBase64 ?? '',
      messages: await _getMessagesForChat(id),
    );
  }

  Future<ChatMessageData?> getChatById(int chatId) async {
    final db = await database;
    final chatRow = await db.query(
      Chat.tableName,
      where: '${Chat.columnId} = ?',
      whereArgs: [chatId],
    );

    if (chatRow.isEmpty) return null;
    final messages = await _getMessagesForChat(chatId);

    return ChatMessageData(
      id: chatId,
      senderName: chatRow.first[Chat.columnSenderName] as String,
      userKey: chatRow.first[Chat.columnUserKey] as String,
      avatarBase64: chatRow.first[Chat.columnAvatarBase64] as String,
      messages: messages,
    );
  }

  Future<void> insertChatMessages(List<ChatMessageData> chatList) async {
    final db = await database;

    for (final chat in chatList) {
      final chatId = await db.insert(
        Chat.tableName,
        {
          Chat.columnSenderName: chat.senderName,
          Chat.columnAvatarBase64: chat.avatarBase64,
        },
      );

      final batch = db.batch();
      for (final message in chat.messages) {
        batch.insert(
          ChatMessage.tableName,
          {
            ChatMessage.columnChatId: chatId,
            ChatMessage.columnContent: message.content,
            ChatMessage.columnTimestamp:
                message.timestamp.millisecondsSinceEpoch,
            ChatMessage.columnIsRead: message.isRead ? 1 : 0,
            ChatMessage.columnSenderIsMe: message.senderIsMe ? 1 : 0,
            ChatMessage.columnType: message.type.index,
          },
        );
      }
      await batch.commit();
    }
  }

  Future<List<ChatMessageData>> getAllChats() async {
    final db = await database;
    final List<Map<String, dynamic>> chats = await db.query(
      Chat.tableName,
      orderBy: '${Chat.columnId} DESC',
    );

    final List<ChatMessageData> result = [];

    for (final chatRow in chats) {
      final chatId = chatRow[Chat.columnId] as int;
      final messages = await _getMessagesForChat(chatId);

      result.add(ChatMessageData(
        id: chatId,
        senderName: chatRow[Chat.columnSenderName] as String,
        userKey: chatRow[Chat.columnUserKey] as String,
        // Handle null values for avatar
        avatarBase64: (chatRow[Chat.columnAvatarBase64] as String?) ?? '',
        messages: messages,
      ));
    }

    result.sort((a, b) {
      final aLast = a.messages.lastOrNull?.timestamp ?? DateTime(0);
      final bLast = b.messages.lastOrNull?.timestamp ?? DateTime(0);
      return bLast.compareTo(aLast);
    });

    return result;
  }

  Future<List<MessageData>> _getMessagesForChat(int chatId) async {
    final db = await database;
    final messages = await db.query(
      ChatMessage.tableName,
      where: '${ChatMessage.columnChatId} = ?',
      whereArgs: [chatId],
      orderBy: ChatMessage.columnTimestamp,
    );

    return messages
        .map((msg) => MessageData(
              id: msg[ChatMessage.columnId] as int,
              chatId: msg[ChatMessage.columnChatId] as int,
              content: msg[ChatMessage.columnContent] as String,
              timestamp: DateTime.fromMillisecondsSinceEpoch(
                msg[ChatMessage.columnTimestamp] as int,
              ),
              isRead: (msg[ChatMessage.columnIsRead] as int) == 1,
              senderIsMe: (msg[ChatMessage.columnSenderIsMe] as int) == 1,
              type: MessageTypes.values[msg[ChatMessage.columnType] as int],
            ))
        .toList();
  }

  Future<int> markMessagesAsRead(int chatId) async {
    final db = await database;
    return await db.update(
      ChatMessage.tableName,
      {ChatMessage.columnIsRead: 1},
      where: '${ChatMessage.columnChatId} = ?',
      whereArgs: [chatId],
    );
  }
}
