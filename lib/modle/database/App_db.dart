// lib/modle/database/app_database.dart

import 'dart:async';
import 'package:chat_app/modle/database/tables/ChatMessages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:chat_app/modle/data/ChatMessageData.dart';
import 'package:chat_app/modle/data/MessageData.dart';

class AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If database doesn't exist, create one
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'chat.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create table schema using the imported table schema class
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(ChatMessages.createTableQuery);
  }

  // Insert messages into the database
  Future<void> insertChatMessages(List<ChatMessageData> chatList) async {
    final db = await database;

    Batch batch = db.batch();

    for (var chat in chatList) {
      for (var message in chat.messages) {
        batch.insert(
          ChatMessages.tableName,
          {
            ChatMessages.columnSender: chat.senderName,
            ChatMessages.columnMessage: message.text,
            ChatMessages.columnTimestamp: message.timestamp.millisecondsSinceEpoch,
            ChatMessages.columnIsRead: message.isRead ? 1 : 0
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    await batch.commit();
  }

  // Fetch all chats from the database
  Future<List<ChatMessageData>> getAllChats() async {
    final db = await database;
    final List<Map<String, dynamic>> messages = await db.query(ChatMessages.tableName);

    // Group messages by sender
    Map<String, List<ChatMessageData>> groupedMessages = {};

    for (var msg in messages) {
      groupedMessages.putIfAbsent(msg[ChatMessages.columnSender], () => []).add(ChatMessageData(
        id: msg[ChatMessages.columnId],
        senderName: msg[ChatMessages.columnSender],
        messages: [
          Message(
            text: msg[ChatMessages.columnMessage],
            timestamp: DateTime.fromMillisecondsSinceEpoch(msg[ChatMessages.columnTimestamp]),
            isRead: msg[ChatMessages.columnIsRead] == 1,
          )
        ],
        avatarUrl: 'https://picsum.photos/300/300',
      ));
    }

    return groupedMessages.values
        .map((msgList) => ChatMessageData(
      id: msgList.first.id,
      senderName: msgList.first.senderName,
      messages: msgList.expand((chat) => chat.messages).toList(),
      avatarUrl: msgList.first.avatarUrl,
    ))
        .toList();
  }
}
