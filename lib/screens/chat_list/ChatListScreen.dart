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
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            AppLocale.chat.getString(context),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Obx(() {
        if (_chatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemCount: _chatController.chatList.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final chat = _chatController.chatList[index];
            final lastMessage = chat.messages.lastOrNull;
            final unreadCount = chat.messages.where((m) => !m.isRead).length;

            return ListTile(
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
                        fontWeight: unreadCount > 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    lastMessage != null
                        ? DateFormat('HH:mm').format(lastMessage.timestamp)
                        : '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                _buildSubtitle(chat, lastMessage),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: unreadCount > 0
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: unreadCount > 0
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
              trailing: unreadCount > 0
                  ? Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              )
                  : null,
              onTap: () {
                Get.toNamed(
                  "/Chat",
                  arguments: {'chatId': chat.id},
                  preventDuplicates: true,
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const NewMessageScreen()),
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }

  String _buildSubtitle(ChatMessageData chat, MessageData? lastMessage) {
    if (lastMessage == null) return 'No messages yet';

    final content = lastMessage.type == MessageTypes.text
        ? lastMessage.content
        : "[Image]";

    return lastMessage.senderIsMe ? 'You: $content' : content;
  }
}