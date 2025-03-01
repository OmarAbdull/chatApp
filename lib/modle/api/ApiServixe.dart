import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];

  Future<dynamic> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to load data');
    }
  }
}