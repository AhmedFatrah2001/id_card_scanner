import 'package:flutter/material.dart';

class LandingComponent extends StatelessWidget {
  const LandingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Icon or Logo
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Icon(
                Icons.document_scanner,
                size: 100,
                color: Color(0xFFA1DD70),
              ),
            ),

            // App Purpose
            const Text(
              'Scan, Extract, and Simplify!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Our app makes scanning ID cards fast, secure, and hassle-free. Extract data with confidence and efficiency.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),

            // Advantages Section
            _buildSectionTitle('Why Use ID Scanner?'),
            const SizedBox(height: 10),
            _buildFeature(
              icon: Icons.speed,
              title: 'Fast and Efficient',
              description:
                  'Quickly scan ID cards and extract information in seconds.',
            ),
            _buildFeature(
              icon: Icons.security,
              title: 'Secure and Private',
              description:
                  'Your data is never stored or shared. We value your privacy.',
            ),
            _buildFeature(
              icon: Icons.language,
              title: 'Multilingual Support',
              description: 'Extract data in both Arabic and English.',
            ),
            _buildFeature(
              icon: Icons.check_circle,
              title: 'Accurate Results',
              description: 'Our advanced OCR ensures high accuracy in data extraction.',
            ),

            const SizedBox(height: 30),

            // Security Section
            _buildSectionTitle('Your Security Matters'),
            const SizedBox(height: 10),
            const Text(
              'We are committed to protecting your data. All information extracted is processed securely and never saved. Feel confident using ID Scanner for all your needs.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            // Decorative Icons
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.lock, size: 50, color: Color(0xFFA1DD70)),
                Icon(Icons.privacy_tip, size: 50, color: Color(0xFFA1DD70)),
                Icon(Icons.shield, size: 50, color: Color(0xFFA1DD70)),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: const Color(0xFFA1DD70)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
