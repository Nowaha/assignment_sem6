import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class FileUtil {
  static Future<PlatformFile?> pickFile(
    FileType fileType, {
    List<String>? allowedExtensions,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.bytes != null) {
        return file;
      }
    }
    return null;
  }

  static Future<void> saveFile(Uint8List data, String suggestedName) async {
    final output = await FilePicker.platform.saveFile(
      dialogTitle: "Select a location to save the file",
      fileName: suggestedName,
    );

    if (output != null) {
      final file = File(output);
      await file.writeAsBytes(data);
    }
  }
}
