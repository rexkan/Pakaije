import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class BackgroundRemovalService {
  static const String _apiKey = 'YjLRFZh6TbSrYjmsY3fqP6zh';
  static const String _baseUrl = 'https://api.remove.bg/v1.0/removebg';

  /// Remove background from image URL
  static Future<String?> removeBackgroundFromUrl(String imageUrl) async {
    try {
      print('🔄 Starting background removal for URL: $imageUrl');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'X-Api-Key': _apiKey,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'image_url': imageUrl,
          'size': 'auto',
          'type': 'product', // Optimized for clothing items
          'format': 'png', // PNG supports transparency
          'roi': '0% 0% 100% 100%', // Process entire image
          'crop': 'false', // Don't crop the image
        },
      );

      if (response.statusCode == 200) {
        print('✅ Background removal successful');

        // Upload processed image to Firebase Storage
        final processedUrl = await _uploadProcessedImage(response.bodyBytes);
        print('✅ Processed image uploaded: $processedUrl');

        return processedUrl;
      } else {
        print('❌ Background removal failed: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Background removal error: $e');
      return null;
    }
  }

  /// Remove background from local file
  static Future<String?> removeBackgroundFromFile(File imageFile) async {
    try {
      print('🔄 Starting background removal for file: ${imageFile.path}');

      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.headers['X-Api-Key'] = _apiKey;
      request.fields['size'] = 'auto';
      request.fields['type'] = 'product';
      request.fields['format'] = 'png';

      // Add image file
      request.files
          .add(await http.MultipartFile.fromPath('image_file', imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('✅ Background removal successful');

        // Upload processed image to Firebase Storage
        final processedUrl = await _uploadProcessedImage(response.bodyBytes);
        print('✅ Processed image uploaded: $processedUrl');

        return processedUrl;
      } else {
        print('❌ Background removal failed: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Background removal error: $e');
      return null;
    }
  }

  /// Upload processed image to Firebase Storage
  static Future<String> _uploadProcessedImage(List<int> imageBytes) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'processed_item_$timestamp.png';

      final ref = FirebaseStorage.instance
          .ref()
          .child('processed_wardrobe_items')
          .child(fileName);

      // Upload with proper metadata for PNG
      final metadata = SettableMetadata(
        contentType: 'image/png',
        customMetadata: {
          'processed_by': 'remove_bg',
          'timestamp': timestamp.toString(),
        },
      );

      await ref.putData(Uint8List.fromList(imageBytes), metadata);

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('❌ Error uploading processed image: $e');
      rethrow;
    }
  }

  /// Save processed image locally for preview
  static Future<File?> saveProcessedImageLocally(List<int> imageBytes) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName = 'processed_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(imageBytes);
      return file;
    } catch (e) {
      print('❌ Error saving processed image locally: $e');
      return null;
    }
  }

  /// Check API quota/usage
  static Future<Map<String, dynamic>?> checkApiUsage() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.remove.bg/v1.0/account'),
        headers: {
          'X-Api-Key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        // Note: Remove.bg doesn't provide usage info via API
        // This is a placeholder for future implementation
        return {'status': 'active'};
      }
      return null;
    } catch (e) {
      print('❌ Error checking API usage: $e');
      return null;
    }
  }

  /// Batch process multiple images (use carefully to avoid hitting rate limits)
  static Future<List<String?>> batchRemoveBackground(
      List<String> imageUrls) async {
    List<String?> results = [];

    for (int i = 0; i < imageUrls.length; i++) {
      print('🔄 Processing image ${i + 1}/${imageUrls.length}');

      final result = await removeBackgroundFromUrl(imageUrls[i]);
      results.add(result);

      // Add delay to respect rate limits (Remove.bg allows 1 request per second for free tier)
      if (i < imageUrls.length - 1) {
        await Future.delayed(Duration(seconds: 1));
      }
    }

    return results;
  }

  /// Validate image before processing
  static bool isValidImageUrl(String url) {
    if (url.isEmpty) return false;

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    // Check if it's a valid image URL
    final validExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
    final lowercaseUrl = url.toLowerCase();

    return validExtensions.any((ext) => lowercaseUrl.contains(ext)) ||
        url.contains('firebase') || // Firebase Storage URLs
        url.contains('cloudinary'); // Cloudinary URLs
  }
}
