import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/util/fileutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddAttachmentWidget extends StatelessWidget {
  final Function(PlatformFile file) onFilePicked;

  const AddAttachmentWidget({super.key, required this.onFilePicked});

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerHigh,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      width: 196,
      height: 96,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 8,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Tooltip(
                    message: "Attach Image",
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      onTap: () async {
                        final result = await FileUtil.pickFile(
                          FileType.image,
                          context: context,
                        );
                        if (result != null) {
                          onFilePicked(result);
                        }
                      },
                      child: Center(
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 32,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(200),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
                  width: 2,
                  height: 24,
                ),
                Expanded(
                  child: Tooltip(
                    message: "Attach Video",
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      onTap: () async {
                        final result = await FileUtil.pickFile(
                          FileType.video,
                          context: context,
                        );
                        if (result != null) {
                          onFilePicked(result);
                        }
                      },
                      child: Center(
                        child: Icon(
                          Icons.video_file,
                          size: 32,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(200),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
                  width: 2,
                  height: 24,
                ),
                Expanded(
                  child: Tooltip(
                    message: "Attach File",
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      onTap: () async {
                        final result = await FileUtil.pickFile(
                          FileType.custom,
                          allowedExtensions: ResourceType.allExtensions,
                          context: context,
                        );
                        if (result != null) {
                          onFilePicked(result);
                        }
                      },
                      child: Center(
                        child: Icon(
                          Icons.file_present_rounded,
                          size: 32,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(200),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 12,
            right: 0,
            child: Center(
              child: Text(
                "Add Attachment",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
