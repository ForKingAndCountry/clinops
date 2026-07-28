import 'dart:async';
import 'dart:math';
import '../auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  bool _isAuthenticated = false;
  final Random _random = Random();
  bool _simulateErrors = false;

  MockAuthRepository();

  Future<void> _simulateDelay() async {
    final delay = 300 + _random.nextInt(500);
    await Future.delayed(Duration(milliseconds: delay));
  }

  void _maybeThrowError() {
    if (_simulateErrors && _random.nextDouble() < 0.1) {
      throw Exception('Simulated network error');
    }
  }

  void setSimulateErrors(bool simulate) {
    _simulateErrors = simulate;
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    await _simulateDelay();
    _maybeThrowError();

    // Mock login - accept any valid email format and password >= 8 chars
    if (!email.contains('@') || email.isEmpty) {
      throw Exception('Invalid email format');
    }
    
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }

    _isAuthenticated = true;

    // Return mock user data
    return {
      'id': 1,
      'email': email,
      'name': 'Dr. Sarah Johnson',
      'role': 'doctor',
      'department': 'General Medicine',
    };
  }

  @override
  Future<void> logout() async {
    await _simulateDelay();
    _maybeThrowError();

    _isAuthenticated = false;
  }

  @override
  Future<Map<String, dynamic>> getMe() async {
    await _simulateDelay();
    _maybeThrowError();

    if (!_isAuthenticated) {
      throw Exception('Not authenticated');
    }

    return {
      'id': 1,
      'email': 'doctor@clinic.com',
      'name': 'Dr. Sarah Johnson',
      'role': 'doctor',
      'department': 'General Medicine',
    };
  }

  @override
  bool get isAuthenticated => _isAuthenticated;
}
