import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static String get baseUrl => _baseUrl;
  
  String? _sessionCookie;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      // Store session cookie from response
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        _sessionCookie = cookies;
      }
      return data;
    } else {
      final error = json.decode(response.body) as Map<String, dynamic>;
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/logout'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      _sessionCookie = null;
    } else {
      throw Exception('Logout failed');
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/auth/me'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      _sessionCookie = null;
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to get user info');
    }
  }

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

  Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_sessionCookie != null) {
      headers['Cookie'] = _sessionCookie!;
    }
    return headers;
  }

  Future<http.Response> get(String path) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 401) {
      _sessionCookie = null;
      throw Exception('Unauthorized - Please login again');
    }

    return response;
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _getHeaders(),
      body: json.encode(body),
    );

    if (response.statusCode == 401) {
      _sessionCookie = null;
      throw Exception('Unauthorized - Please login again');
    }

    return response;
  }
}
