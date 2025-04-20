// websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  String? _token;
  final StreamController<Map<String, dynamic>> _messageController =
  StreamController.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;


  Future<void> connect() async {
    _token = await _getToken();
    if (_token == null) {
      throw Exception('No authentication token found');
    }

    const url = 'ws://salmansh-001-site1.otempurl.com/chat';

    try {
      // Create WebSocket connection with authorization header
      _channel = IOWebSocketChannel.connect(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $_token'},
      );

      // Send initial protocol message
      _sendInitialMessage();

      // Listen for incoming messages
      _channel?.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );
    } catch (e) {
      throw Exception('WebSocket connection failed: $e');
    }
  }

  void _sendInitialMessage() {
    const initialMessage = '{"protocol":"json","version":1}\u001E';
    _channel?.sink.add(initialMessage);
  }


// websocket_service.dart
  void _handleMessage(dynamic message) {
    try {
      final messages = message.toString().split('\u001E');

      for (final msg in messages) {
        final trimmed = msg.trim();
        if (trimmed.isEmpty) continue;

        print('Processing raw message: "$trimmed"');

        final parsed = jsonDecode(trimmed);
        if (parsed is Map<String, dynamic>) {
          // Validate and sanitize the message
          final sanitized = {
            'type': parsed['type'],
            'target': parsed['target'],
            'arguments': parsed['arguments'],
          };
            print("Sanitized $sanitized");
          _messageController.add(sanitized);
        }
      }
    } catch (e) {
      print('Error parsing message: $e');
      _messageController.addError(e);
    }
  }
  void _handleError(error) {
    // Handle errors
    print('WebSocket error: $error');
  }

  void _handleDisconnect() {
    // Handle connection closure
    print('WebSocket disconnected');
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  void disconnect() {
    _channel?.sink.close();
  }
}