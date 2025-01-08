import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:id_card_scanner/auth_service.dart';
import 'package:id_card_scanner/card_scanner.dart';
import 'package:id_card_scanner/landing_component.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;
  int _currentIndex = 0; // Current index for bottom navigation bar

  // Pages to display
  final List<Widget> _pages = [
    const LandingComponent(), // Landing page
    const ScanPage(), // Card Scanner page
  ];

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
        title: const Center(
          child: Text(
        'MA-ID Scanner',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
          ),
        ),
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
          child: Text(
            userEmail!,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
            ),
            const PopupMenuItem(
          value: 'logout',
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
            ),
          ],
          icon: const Icon(Icons.account_circle, color: Colors.white),
        ),
        ],
      ),
      body: _pages[_currentIndex], // Display the current page based on the selected index
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex, // Set the initial index
        height: 60.0,
        backgroundColor: Colors.white, // Background color of the main content
        color: const Color(0xFFA1DD70), // Navigation bar color
        buttonBackgroundColor: const Color(0xFFA1DD70), // Highlighted button color
        animationDuration: const Duration(milliseconds: 300), // Animation speed
        animationCurve: Curves.easeInOut, // Animation curve
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white), // Home icon
          Icon(Icons.camera_alt, size: 30, color: Colors.white), // Camera icon
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index when a tab is selected
          });
        },
      ),
    );
  }
}
