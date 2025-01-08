import 'package:flutter/material.dart';

class ListItemComponent extends StatelessWidget {
  final String fieldKey; // e.g., 'bd_fr', 'fn_ar'
  final String text; // The extracted text
  final double confidence; // Confidence value between 0 and 1

  const ListItemComponent({
    super.key,
    required this.fieldKey,
    required this.text,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the field type and language
    final isArabic = fieldKey.endsWith('_ar');
    final fieldType = fieldKey.split('_').first;

    // Map field types to labels and icons
    final fieldData = {
      'bd': {'label': 'Birthday', 'icon': Icons.cake},
      'bp': {'label': 'Birthplace', 'icon': Icons.location_on},
      'cin': {'label': 'ID Number', 'icon': Icons.badge},
      'fn': {'label': 'First Name', 'icon': Icons.person},
      'ln': {'label': 'Last Name', 'icon': Icons.people_alt},
      'vd': {'label': 'Valid Date', 'icon': Icons.event},
    };

    final fieldLabel = fieldData[fieldType]?['label'] as String? ?? 'Unknown';
    final fieldIcon = fieldData[fieldType]?['icon'] as IconData? ?? Icons.info;

    return Card(
      color: const Color(0xFFA1DD70), // Primary color for the card
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon for the field
            Icon(
              fieldIcon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(width: 16.0),

            // Field details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Field label
                  Text(
                    isArabic ? '$fieldLabel - AR' : fieldLabel,
                    style: const TextStyle(
                      fontSize: 14.0, // Smaller font for the label
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 8.0),

                  // Field text
                  Directionality(
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    child: Text(
                      text,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 16.0, // Larger font for the extracted data
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: isArabic ? 'ArabicFont' : null, // Optional for Arabic styling
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Confidence progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: LinearProgressIndicator(
                      value: confidence,
                      minHeight: 8.0,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),

                  // Confidence percentage text
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(confidence * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
