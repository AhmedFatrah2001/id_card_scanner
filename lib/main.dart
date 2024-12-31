import 'package:flutter/material.dart';
import 'package:id_card_scanner/auth_service.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() {
  runApp(const IDCardScannerApp());
}

class IDCardScannerApp extends StatelessWidget {
  const IDCardScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
          );
        }
      },
    );
  }
}
