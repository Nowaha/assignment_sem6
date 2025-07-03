import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/util/fileutil.dart';
import 'package:assignment_sem6/widgets/image/postimageerrorbuilder.dart';
import 'package:assignment_sem6/widgets/image/postimageframebuilder.dart';
import 'package:flutter/material.dart';

class AttachmentWidget extends StatelessWidget {
  final String attachmentUUID;
  final Resource attachmentResource;
  final bool editable;
  final Function(String attachmentUUID)? onDelete;

  const AttachmentWidget({
    super.key,
    required this.attachmentUUID,
    required this.attachmentResource,
    this.editable = false,
    this.onDelete,
  }) : assert(
         editable == false || onDelete != null,
         "onDelete must be provided if editable is true",
       );

  @override
  Widget build(BuildContext context) {
    final String fullName =
        "${attachmentResource.name}.${attachmentResource.originalExtension}";

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 96,
        minHeight: 96,
        maxHeight: 96,
        maxWidth: 128,
      ),
      child: Tooltip(
        message: fullName,
        child: Material(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            onTap: () async {
              FileUtil.saveFile(attachmentResource.data, fullName);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (attachmentResource.type == ResourceType.image)
                    Image.memory(
                      attachmentResource.data,
                      fit: BoxFit.fitHeight,
                      frameBuilder: postImageFrameBuilder,
                      errorBuilder: postImageErrorBuilder,
                    )
                  else
                    Icon(
                      Icons.attachment,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),

                  IntrinsicWidth(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.black.withAlpha(100),
                        child: Text(
                          fullName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ),

                  if (editable)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton.filledTonal(
                        iconSize: 16,
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        tooltip: "Delete Attachment",
                        onPressed: () => onDelete!(attachmentUUID),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
