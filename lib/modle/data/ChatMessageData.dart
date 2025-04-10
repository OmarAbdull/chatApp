// lib/modle/data/ChatMessageData.dart

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'MessageData.dart';

class ChatMessageData {
  final int id;
  final String senderName;
  final String userKey;
  final String avatarBase64;
  final List<MessageData> messages;

  int get unreadCount => messages.where((msg) => !msg.isRead).length;

  ChatMessageData({
    required this.id,
    required this.userKey,
    required this.avatarBase64,
    required this.senderName,
    required this.messages,
  });

  ImageProvider get avatarImage {
    if (avatarBase64.isEmpty ) {
      return const AssetImage('default_avatar.png');
    }

    try {
      final cleanBase64 = avatarBase64.replaceFirst(RegExp(r'^.*?base64,'), '');
      final bytes = base64Decode(cleanBase64);
      return MemoryImage(bytes);
    } catch (e) {
      debugPrint('Error decoding avatar image: $e');
      return const AssetImage('assets/default_avatar.png');
    }
  }
}