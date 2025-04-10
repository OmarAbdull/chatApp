// screens/chat_list_screen.dart
import 'package:chat_app/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../modle/data/ChatMessageData.dart';
import '../../modle/data/MessageData.dart';
import '../chat/ChatScreen.dart';
import '../new_message/NewMessageScreen.dart';
import 'ChatListController.dart';

class ChatListScreen extends StatelessWidget {
  final ChatListController _chatController = Get.put(ChatListController());

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back button
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(child: Text(AppLocale.chat.getString(context),style: TextStyle(color: Colors.white),)),
      ),
      body: Obx(() {
        if (_chatController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemCount: _chatController.chatList.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            ChatMessageData chat = _chatController.chatList[index];
            return // Updated ListTile in ChatListScreen
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: chat.avatarImage,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        chat.senderName,
                        style: TextStyle(
                          fontWeight: chat.unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(
                        chat.messages.isNotEmpty
                            ? chat.messages.last.timestamp
                            : DateTime.now(),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  chat.messages.isNotEmpty
                      ? (chat.messages.last.senderIsMe
                      ? 'You: ${chat.messages.last.type == MessageTypes.text ? chat.messages.last.content : "[Image]"}'
                      : (chat.messages.last.type == MessageTypes.text
                      ? chat.messages.last.content
                      : "[Image]"))
                      : 'No messages yet', // Show default text for empty chats
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: chat.unreadCount > 0
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: chat.unreadCount > 0
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
                trailing: chat.unreadCount > 0
                    ? Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${chat.unreadCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )
                    : null,
                onTap: () {
                  print("___________${chat.id}");
                  Get.toNamed("/Chat", arguments: {'chatId': chat.id},  preventDuplicates: true,
                  );
                },
              );

          },
        );
      }),

      // Floating Action Button at the Bottom
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(NewMessageScreen()); // Using GetX for navigation
        },
        child:  Icon(Icons.message,color: Colors.white,),
      ),
    );
  }
}
