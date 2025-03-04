import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/ChatMessageData.dart';

/// A service class for making API requests.
class ApiService {
  /// Base URL for API requests, loaded from environment variables.
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];

  /// Sends a POST request to the given [endpoint] with the provided [body].
  Future<dynamic> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    /// Returns decoded JSON response if the request is successful (status code 200).
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    /// - Throws an exception with a message if the status code is 400.
    else if (response.statusCode == 400) {
      throw Exception(jsonDecode(response.body)['message']);
    }
    /// - Throws a general exception if the request fails.
    else {
      throw Exception('Failed to load data');
    }
  }
  Future<List<ChatMessageData>> fetchChatMessages() async {
    final response = await http.get(Uri.parse('$_baseUrl/chats'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ChatMessageData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }
}
