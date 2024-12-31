import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:id_card_scanner/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String registerUrl = '$SERVER_IP/register';
  final String loginUrl = '$SERVER_IP/login';

  /// Register a new user
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register. Server returned: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred during registration: $e');
    }
  }

  /// Log in an existing user
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await _storeTokenAndUserInfo(responseData['token'], responseData['user']);
        return responseData;
      } else {
        throw Exception('Failed to log in. Server returned: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred during login: $e');
    }
  }

  /// Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  /// Get the stored token
  Future<String?> getToken() async {
    return await _getToken();
  }

  /// Log out the user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userInfo');  // Remove user information
  }

  /// Store the authentication token and user information
  Future<void> _storeTokenAndUserInfo(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('userInfo', jsonEncode(user));
  }

  /// Retrieve the authentication token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  /// Retrieve the stored user information
  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString('userInfo');
    if (userInfoJson != null) {
      return jsonDecode(userInfoJson);
    }
    return null;
  }
}
