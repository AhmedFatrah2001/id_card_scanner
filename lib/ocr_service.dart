import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:id_card_scanner/config.dart';

class OcrService {
  final String _apiUrl = '$SERVER_IP/scan';

  /// Sends an image to the OCR API and returns the extracted text.
  ///
  /// [imageFile]: The image file to be processed.
  ///
  /// Returns a `Map<String, dynamic>` containing the OCR results or throws an exception on error.
  Future<Map<String, dynamic>> sendImage(File imageFile) async {
    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }

      // Create a multipart request for the image upload
      var request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
      request.headers['x-access-token'] = authToken;
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      // Send the request
      var response = await request.send();

      // Parse the response
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        return jsonDecode(responseData.body);
      } else {
        final responseData = await http.Response.fromStream(response);
        throw Exception(
          'Failed to process image. Server responded with status code: ${response.statusCode}, '
          'Message: ${responseData.body}',
        );
      }
    } catch (e) {
      throw Exception('Error occurred while sending image: $e');
    }
  }
}
