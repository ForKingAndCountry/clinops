import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:80',
  );

  static String get baseUrl => _baseUrl;

  Future<Map<String, dynamic>> getHealth() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/health'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load health status');
    }
  }
}
