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
    return openDatabase(path, version: 1, onCreate: _onCreate); // Open/create database
  }

  // Create the necessary tables when the database is created
  Future<void> _onCreate(Database db, int version) async {
    // Executes the SQL query to create the ChatMessages table
    await db.execute(ChatMessages.createTableQuery);
  }

  // Insert a list of chat messages into the database
  Future<void> insertChatMessages(List<ChatMessageData> chatList) async {
    final db = await database; // Retrieve the database instance

    Batch batch = db.batch(); // Create a batch operation for bulk inserts

    // Loop through each chat in the chat list
    for (var chat in chatList) {
      // Loop through each message in the chat
      for (var message in chat.messages) {
        // Prepare the data to insert into the ChatMessages table
        batch.insert(
          ChatMessages.tableName, // Table name
          {
            ChatMessages.columnSender: chat.senderName, // Sender's name
            ChatMessages.columnMessage: message.text, // Message text
            ChatMessages.columnTimestamp: message.timestamp.millisecondsSinceEpoch, // Message timestamp
            ChatMessages.columnIsRead: message.isRead ? 1 : 0 // Read status (1 for true, 0 for false)
          },
          conflictAlgorithm: ConflictAlgorithm.replace, // Replace if conflict occurs
        );
      }
    }

    // Execute all batch insert operations
    await batch.commit();
  }

  // Fetch all chats from the database and return them grouped by sender
  Future<List<ChatMessageData>> getAllChats() async {
    final db = await database; // Retrieve the database instance
    final List<Map<String, dynamic>> messages = await db.query(ChatMessages.tableName); // Query all messages from the ChatMessages table

    // Group messages by sender's name using a map
    Map<String, List<ChatMessageData>> groupedMessages = {};

    for (var msg in messages) {
      // Group the messages by sender name
      groupedMessages.putIfAbsent(msg[ChatMessages.columnSender], () => []).add(ChatMessageData(
        id: msg[ChatMessages.columnId], // Message ID
        senderName: msg[ChatMessages.columnSender], // Sender's name
        messages: [
          // Create a Message object for each chat message
          Message(
            text: msg[ChatMessages.columnMessage], // Message text
            timestamp: DateTime.fromMillisecondsSinceEpoch(msg[ChatMessages.columnTimestamp]), // Convert timestamp to DateTime
            isRead: msg[ChatMessages.columnIsRead] == 1, // Determine if message is read
          )
        ],
        avatarUrl: 'https://picsum.photos/300/300', // Placeholder avatar URL
      ));
    }

    // Map the grouped messages back into a list of ChatMessageData objects
    return groupedMessages.values
        .map((msgList) => ChatMessageData(
      id: msgList.first.id, // Use the first message's ID
      senderName: msgList.first.senderName, // Use the first message's sender name
      messages: msgList.expand((chat) => chat.messages).toList(), // Combine all messages in the group
      avatarUrl: msgList.first.avatarUrl, // Use the first message's avatar URL
    ))
        .toList(); // Return the list of grouped ChatMessageData objects
  }
}
