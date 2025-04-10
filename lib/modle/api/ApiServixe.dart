import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/ChatMessageData.dart';

/// A service class for making API requests.
class ApiService {
  /// Base URL for API requests, loaded from environment variables.
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];

  /// Sends a POST request to the given [endpoint] with the provided [body].
// In ApiService class
  Future<dynamic> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    print("Api Response ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Failed to load data');
    }
  }

  Future<dynamic> authenticatedPost(String endpoint, dynamic body) async {
    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl/$endpoint');
    print("Url$_baseUrl/$endpoint");
    print("body$body");

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      final responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        throw Exception(
            responseBody['message'] ?? 'API request failed with status ${response.statusCode}'
        );
      }
    } on FormatException catch (e) {
      throw Exception('Invalid JSON response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

}
