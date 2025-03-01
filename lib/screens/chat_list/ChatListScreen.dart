// screens/chat_list_screen.dart
import 'package:chat_app/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../modle/data/ChatMessage.dart';
import '../newMessageScreen/NewMessageScreen.dart';
import 'ChatListController.dart';

class ChatListScreen extends StatelessWidget {
  final ChatListController _chatController = Get.put(ChatListController());

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.chat.getString(context)),
      ),
      body: Obx(() {
        if (_chatController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemCount: _chatController.chatList.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            ChatMessage chat = _chatController.chatList[index];
            return ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(chat.avatarUrl),
                  ),
                  if (chat.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    )
                ],
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
                    DateFormat('HH:mm').format(chat.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                chat.isSentByMe ? 'You: ${chat.lastMessage}' : chat.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: chat.unreadCount > 0 ? Colors.black : Colors.grey,
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
                // Navigate to chat detail screen
                // Get.to(ChatDetailScreen(chat: chat));
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
        child: const Icon(Icons.message),
      ),
    );
  }
}
