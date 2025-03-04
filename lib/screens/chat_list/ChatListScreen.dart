// screens/chat_list_screen.dart
import 'package:chat_app/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../modle/data/ChatMessageData.dart';
import '../new_message/NewMessageScreen.dart';
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
            ChatMessageData chat = _chatController.chatList[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(chat.avatarUrl),
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
                    ? (/* chat.isSentByMe */ false
                        ? 'You: ${chat.messages.last.text}'
                        : chat.messages.last.text)
                    : '', // Handle case when there are no messages
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
