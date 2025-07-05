import 'dart:io';
import 'dart:typed_data';

import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/util/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileUtil {
  /// If [context] is provided, it will show errors through toasts.
  static Future<PlatformFile?> pickFile(
    FileType fileType, {
    List<String>? allowedExtensions,
    BuildContext? context,
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
      } else {
        if (context != null && context.mounted) {
          Toast.showToast(context, "Selected file is empty.");
        }
      }
    }
    return null;
  }

  /// If [context] is provided, it will show errors through toasts.
  static Future<Resource?> pickFileAsResource(
    FileType fileType, {
    List<String>? allowedExtensions,
    BuildContext? context,
  }) async {
    final file = await pickFile(fileType, allowedExtensions: allowedExtensions);
    if (file == null) {
      return null;
    }

    final fileName = file.name;
    final fileExtension = fileName.split(".").last;
    final fileExtensionLower = fileExtension.toLowerCase();

    try {
      return Resource.create(
        type: ResourceType.fromExtension(fileExtensionLower),
        name: fileName.replaceAll(".$fileExtension", ""),
        originalExtension: fileExtensionLower,
        data: file.bytes!,
      );
    } on ArgumentError catch (error) {
      if (error.name == "ext") {
        if (context != null && context.mounted) {
          Toast.showToast(
            context,
            "Unsupported file type: $fileExtensionLower",
          );
        }
      }
      rethrow;
    } catch (e) {
      if (context != null && context.mounted) {
        Toast.showToast(context, "Failed to create resource from file.");
      }
    }
    return null;
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
