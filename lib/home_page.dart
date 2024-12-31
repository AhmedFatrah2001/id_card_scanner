import 'package:flutter/material.dart';
import 'package:id_card_scanner/auth_service.dart';
import 'package:id_card_scanner/card_scanner.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await AuthService().getUserInfo();
    if (userInfo != null) {
      setState(() {
        userEmail = userInfo['email'] ?? userInfo['username'];
      });
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA1DD70),
        title: const Text('Home Page'),
        actions: [
          if (userEmail != null)
            PopupMenuButton(
              onSelected: (value) {
                if (value == 'logout') {
                  _logout();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'email',
                  child: Text(userEmail!),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
              icon: const Icon(Icons.account_circle),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Text
            const Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),

            // Camera Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to the ScanPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanPage()),
                );
              },
              icon: const Icon(Icons.camera_alt, size: 50),
              label: const Text(
                'Open Card Scanner',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
