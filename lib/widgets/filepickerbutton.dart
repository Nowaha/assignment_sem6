import 'dart:typed_data';

import 'package:assignment_sem6/util/fileutil.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerButton extends StatelessWidget {
  final Function(Uint8List bytes, String name) onFilePicked;
  final FilePickerButtonType type;
  final FileType fileType;
  final String? tooltip;
  final Widget? child;

  const FilePickerButton({
    super.key,
    required this.onFilePicked,
    required this.fileType,
    this.type = FilePickerButtonType.elevated,
    this.tooltip,
    this.child,
  });

  void _pickFile() async {
    final file = await FileUtil.pickFile(fileType);
    if (file != null) {
      onFilePicked(file.bytes!, file.name);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      switch (type) {
        FilePickerButtonType.elevated => ElevatedButton(
          onPressed: () => _pickFile(),
          child: child ?? const Text("Pick File"),
        ),
        FilePickerButtonType.icon => IconButton(
          onPressed: () => _pickFile(),
          icon: child ?? const Icon(Icons.file_upload),
          tooltip: tooltip ?? "Pick File",
        ),
        FilePickerButtonType.iconTonal => IconButton.filledTonal(
          onPressed: () => _pickFile(),
          icon: child ?? const Icon(Icons.file_upload_outlined),
          tooltip: tooltip ?? "Pick File",
        ),
        FilePickerButtonType.iconFilled => IconButton.filled(
          onPressed: () => _pickFile(),
          icon: child ?? const Icon(Icons.file_upload),
          tooltip: tooltip ?? "Pick File",
        ),
      },
    ],
  );
}

enum FilePickerButtonType { elevated, icon, iconTonal, iconFilled }
