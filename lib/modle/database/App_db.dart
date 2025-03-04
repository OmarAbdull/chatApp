import 'dart:async';
import 'dart:io';
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

  // Create table schema
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ChatMessages(
        id INTEGER PRIMARY KEY,
        sender TEXT,
        message TEXT,
        timestamp INTEGER,
        isRead INTEGER DEFAULT 0
      )
    ''');
  }

  // Insert messages into the database
  Future<void> insertChatMessages(List<ChatMessageData> chatList) async {
    final db = await database;

    Batch batch = db.batch();

    for (var chat in chatList) {
      for (var message in chat.messages) {
        batch.insert(
          'ChatMessages',
          {
            'sender': chat.senderName,
            'message': message.text,
            'timestamp': message.timestamp.millisecondsSinceEpoch,
            'isRead': message.isRead ? 1 : 0
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
    final List<Map<String, dynamic>> messages = await db.query('ChatMessages');

    // Group messages by sender
    Map<String, List<ChatMessageData>> groupedMessages = {};

    for (var msg in messages) {
      groupedMessages.putIfAbsent(msg['sender'], () => []).add(ChatMessageData(
        id: msg['id'],
        senderName: msg['sender'],
        messages: [
          Message(
            text: msg['message'],
            timestamp: DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
            isRead: msg['isRead'] == 1,
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
