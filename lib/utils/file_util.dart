import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Function to handle file upload
Future<void> fileUploadPicker(WebViewController controller) async {
  // Use FilePicker or other methods to select a file
  final result = await FilePicker.platform.pickFiles();
  if (result != null && result.files.isNotEmpty) {
    final filePath = result.files.single.path!;
    final file = File(filePath);

    final bytes = await file.readAsBytes();
    final base64Content = base64Encode(bytes);

    final fileName = result.files.single.name;
    final script = """
        processUploadedFile('$fileName', 'data:image/${fileName.split('.').last};base64,$base64Content');
      """;

    controller.runJavaScript(script);
  } else {
    // print("No file selected");
  }
}
