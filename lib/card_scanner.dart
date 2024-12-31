import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'ocr_service.dart'; // Import the service file

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  List<String> _pictures = [];
  Map<String, String>? _ocrResults; // Map to store label and text only

  Future<void> _startScan() async {
    // Request permissions
    final status = await Permission.camera.request();

    if (status.isGranted) {
      try {
        List<String> pictures = await CunningDocumentScanner.getPictures() ?? [];
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

      // Extract label and text only from OCR results
      final ocrResults = <String, String>{};
      final ocrData = response['ocr_results'] as Map<String, dynamic>?;

      if (ocrData != null) {
        ocrData.forEach((key, value) {
          if (value is Map<String, dynamic> && value.containsKey('text')) {
            ocrResults[key] = value['text'];
          }
        });
      }

      setState(() {
        _ocrResults = ocrResults;
      });
    } catch (e) {
      setState(() {
        _ocrResults = {'error': 'Failed to process image: $e'};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan ID Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startScan,
              child: const Text('Open Camera'),
            ),
            const SizedBox(height: 20),
            if (_ocrResults != null)
              Expanded(
                child: ListView(
                  children: _ocrResults!.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          entry.key.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(entry.value),
                      ),
                    );
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
                      return Image.file(File(picture));
                    } else {
                      return Text(
                        picture,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center,
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
