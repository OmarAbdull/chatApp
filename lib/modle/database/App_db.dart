// lib/modle/database/app_database.dart

import 'dart:async';
import 'package:chat_app/modle/database/tables/ChatMessages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:chat_app/modle/data/ChatMessageData.dart';
import 'package:chat_app/modle/data/MessageData.dart';

class AppDatabase {
  // Private static variable to hold the database instance
  static Database? _database;

  // Database getter - lazy loading of the database instance
  Future<Database> get database async {
    if (_database != null) return _database!; // If database already initialized, return it.

    // If the database is not initialized, create it
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database by getting the application's document directory
  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'chat.db'); // Database file path
    return openDatabase(
      path,
      version: 2, // Increase version for migration
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add migration logic
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE ${ChatMessages.tableName} ADD COLUMN ${ChatMessages.columnImage} TEXT");
    }
  }


  // Create the necessary tables when the database is created
  Future<void> _onCreate(Database db, int version) async {
    // Executes the SQL query to create the ChatMessages table
    await db.execute(ChatMessages.createTableQuery);
  }

  // Insert a list of chat messages into the database
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
            ChatMessages.columnIsRead: message.isRead ? 1 : 0,
            ChatMessages.columnImage: chat.avatarUrl, // Save avatar URL
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    await batch.commit();
  }

  // Fetch all chats from the database and return them grouped by sender
  Future<List<ChatMessageData>> getAllChats() async {
    final db = await database;
    final List<Map<String, dynamic>> messages = await db.query(ChatMessages.tableName);

    Map<String, ChatMessageData> chatDataMap = {};

    for (var msg in messages) {
      String sender = msg[ChatMessages.columnSender];

      if (!chatDataMap.containsKey(sender)) {
        chatDataMap[sender] = ChatMessageData(
          id: msg[ChatMessages.columnId],
          senderName: sender,
          messages: [],
          avatarUrl: msg[ChatMessages.columnImage] ?? '', // Retrieve avatar URL
        );
      }

      chatDataMap[sender]!.messages.add(Message(
        text: msg[ChatMessages.columnMessage],
        timestamp: DateTime.fromMillisecondsSinceEpoch(msg[ChatMessages.columnTimestamp]),
        isRead: msg[ChatMessages.columnIsRead] == 1,
      ));
    }

    return chatDataMap.values.toList();
  }
}
