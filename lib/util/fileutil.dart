import 'dart:io';
import 'dart:typed_data';

import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  static Future<Resource?> pickFileAsResource(
    FileType fileType, {
    List<String>? allowedExtensions,
  }) async {
    final file = await pickFile(fileType, allowedExtensions: allowedExtensions);
    if (file == null) {
      return null;
    }

    final fileName = file.name;
    final fileExtension = fileName.split(".").last.toLowerCase();
    return Resource.create(
      type: ResourceType.fromExtension(fileExtension),
      name: fileName.replaceAll(".$fileExtension", ""),
      originalExtension: fileExtension,
      data: file.bytes!,
    );
  }

  static Future<void> shareFile(Uint8List data, String suggestedName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$suggestedName');

      await file.writeAsBytes(data);

      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } catch (e) {
      print("Error sharing file: $e");
    }
  }

  static Future<void> saveFile(Uint8List data, String suggestedName) async {
    if (Platform.isAndroid || Platform.isIOS) {
      shareFile(data, suggestedName);
      return;
    }

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
