import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/util/fileutil.dart';
import 'package:assignment_sem6/widgets/media/image/postimageerrorbuilder.dart';
import 'package:assignment_sem6/widgets/media/image/postimageframebuilder.dart';
import 'package:flutter/material.dart';

class AttachmentWidget extends StatefulWidget {
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
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final String fullName =
        "${widget.attachmentResource.name}.${widget.attachmentResource.originalExtension}";

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
              FileUtil.saveFile(widget.attachmentResource.data, fullName);
            },
            onHover: (hovered) {
              setState(() {
                _hovered = hovered;
              });
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
                  if (widget.attachmentResource.type == ResourceType.image)
                    Image.memory(
                      widget.attachmentResource.data,
                      fit: BoxFit.fitHeight,
                      frameBuilder: postImageFrameBuilder,
                      errorBuilder: postImageErrorBuilder,
                    )
                  else if (widget.attachmentResource.type == ResourceType.video)
                    Icon(
                      Icons.video_file,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  else
                    Icon(
                      Icons.file_present_rounded,
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

                  if (widget.editable)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: IconButton.filledTonal(
                          iconSize: 16,
                          padding: EdgeInsets.all(4),
                          icon: Icon(Icons.delete),
                          tooltip: "Delete Attachment",
                          onPressed:
                              () => widget.onDelete!(widget.attachmentUUID),
                        ),
                      ),
                    ),

                  if (_hovered)
                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.download,
                          size: 24,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              color: Colors.black,
                              blurRadius: 4,
                            ),
                          ],
                        ),
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
