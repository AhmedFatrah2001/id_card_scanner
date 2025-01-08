import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'auth_service.dart';
import 'otp_verification_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Login function
  Future<String?> _authUser(LoginData data) async {
    final authService = AuthService();
    try {
      await authService.login(data.name, data.password);
      
      return "OTP required";
    } catch (e) {
      return 'Invalid Email or Password'; // Return error message to UI
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
      return 'User Already exists'; // Return error message
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
      onLogin: (LoginData data) async {
        final result = await _authUser(data);

        // Check if the result requires OTP
        if (result == 'OTP required') {
          // Navigate to OTP Verification Page
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(identifier: data.name),
            ),
          );
          return "Resend email";
        }

        return result;
      },
      onSignup: _registerUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        // You might not use this anymore since OTP requires navigation
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
