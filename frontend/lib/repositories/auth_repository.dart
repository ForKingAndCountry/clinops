abstract class AuthRepository {
  // Login with email and password
  Future<Map<String, dynamic>> login(String email, String password);
  
  // Logout current user
  Future<void> logout();
  
  // Get current user info
  Future<Map<String, dynamic>> getMe();
  
  // Check if user is authenticated
  bool get isAuthenticated;
}
