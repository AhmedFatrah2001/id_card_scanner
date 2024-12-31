import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'auth_service.dart';
import 'main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Login function
  Future<String?> _authUser(LoginData data) async {
    final authService = AuthService();
    try {
      await authService.login(data.name, data.password);
      return null; // Success
    } catch (e) {
      return 'Login failed: $e'; // Return error message to UI
    }
  }

  // Register function
  Future<String?> _registerUser(SignupData data) async {
    final authService = AuthService();
    if (data.name == null || data.password == null || data.additionalSignupData?['username'] == null) {
      return 'Please fill all fields';
    }
    try {
      await authService.register(
        data.additionalSignupData!['username']!,
        data.name!,
        data.password!,
      );
      return null; // Success
    } catch (e) {
      return 'Registration failed: $e'; // Return error message
    }
  }

  // Password recovery function
  Future<String?> _recoverPassword(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Password recovery not implemented yet';
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      theme: LoginTheme(
        primaryColor: const Color(0xFFA1DD70),
        accentColor: const Color(0xFF799351),
      ),
      title: 'IDCardScanner',
      onLogin: _authUser,
      onSignup: _registerUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        // Navigate to the HomePage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IDCardScannerApp()),
        );
      },
      additionalSignupFields: const [
        UserFormField(
          keyName: 'username',
          displayName: 'Username',
          userType: LoginUserType.name,
        ),
      ],
    );
  }
}
