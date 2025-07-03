import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/util/fileutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddAttachmentWidget extends StatelessWidget {
  final Function(PlatformFile file) onFilePicked;

  const AddAttachmentWidget({super.key, required this.onFilePicked});

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    child: Tooltip(
      message: "Add Attachment",
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        onTap: () async {
          final result = await FileUtil.pickFile(
            FileType.custom,
            allowedExtensions: ResourceType.allExtensions,
          );
          if (result != null) {
            onFilePicked(result);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          width: 96,
          height: 96,
          child: Icon(
            Icons.add,
            size: 32,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    ),
  );
}
