import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'list_item_component.dart';
import 'ocr_service.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  List<String> _pictures = [];
  Map<String, dynamic>? _ocrResults; // Map to store OCR results

  Future<void> _startScan() async {
    // Request permissions
    final status = await Permission.camera.request();

    if (status.isGranted) {
      try {
        List<String> pictures =
            await CunningDocumentScanner.getPictures() ?? [];
        setState(() {
          _pictures = pictures;
        });

        if (pictures.isNotEmpty) {
          // Send the first image to the API
          await _sendToApi(File(pictures[0]));
        }
      } catch (e) {
        setState(() {
          _pictures = ['An error occurred: $e'];
        });
      }
    } else {
      setState(() {
        _pictures = ['Camera permission denied. Please enable it in settings.'];
      });
    }
  }

  Future<void> _sendToApi(File imageFile) async {
    try {
      final OcrService ocrService = OcrService();
      final response = await ocrService.sendImage(imageFile);

      setState(() {
        _ocrResults = response['ocr_results'] as Map<String, dynamic>?;
      });
    } catch (e) {
      setState(() {
        _ocrResults = {
          'error': 'Failed to process image: $e',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header Instructions
        const Text(
          "Get Ready to Scan Your ID!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),

        const ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
          "Instructions",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
              ),
              SizedBox(width: 8),
            ],
          ),
          children: [
            Text(
              "1. Place your ID card on a flat surface with good lighting.\n"
              "2. Hold your phone steady for a clear capture.\n"
              "3. You can choose between automatic detection or manual capture.\n"
              "   - Automatic: The app detects and captures the ID card automatically.\n"
              "   - Manual: You manually capture the ID, and the app will crop it for you.",
              textAlign: TextAlign.center,
              style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
          height: 1.5,
              ),
            ),
            SizedBox(height: 30),
          ],
        ),

        // Camera button
        GestureDetector(
          onTap: _startScan,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFA1DD70), // Primary color
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20.0),
            child: const Icon(
              Icons.camera_alt,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Results or Images
        if (_ocrResults != null)
          Expanded(
            child: ListView(
              children: _ocrResults!.entries.map((entry) {
                final value = entry.value;
                if (value is Map<String, dynamic> &&
                    value.containsKey('text') &&
                    value.containsKey('confidence')) {
                  return ListItemComponent(
                    fieldKey: entry.key,
                    text: value['text'] as String? ?? 'N/A',
                    confidence: value['confidence'] as double? ?? 0.0,
                  );
                } else {
                  return ListTile(
                    title: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Invalid data'),
                  );
                }
              }).toList(),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: _pictures.length,
              itemBuilder: (context, index) {
                final picture = _pictures[index];
                if (File(picture).existsSync()) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.file(
                        File(picture),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      picture,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
          ),
      ],
    ),
  ),
);

  }
}
