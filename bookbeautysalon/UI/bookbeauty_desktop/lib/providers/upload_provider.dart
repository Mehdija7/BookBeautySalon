import 'dart:io';
import 'package:bookbeauty_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class FileUploadService {
  Future<void> uploadFileProduct(File file, int productId) async {
    final uri =
        Uri.parse('${BaseProvider.baseUrl}uploadproduct?productId=$productId');

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    print('Uploading to: $uri');
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Upload success.');
        print(response.body);
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during upload: $e');
    }
  }

  Future<void> uploadFileService(File file, int serviceId) async {
    final uri =
        Uri.parse('${BaseProvider.baseUrl}uploadservice?serviceId=$serviceId');

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    print('Uploading to: $uri');
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Upload success.');
        print(response.body);
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during upload: $e');
    }
  }
}
