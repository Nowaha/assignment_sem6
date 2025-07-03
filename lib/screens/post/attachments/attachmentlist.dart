import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:assignment_sem6/screens/post/attachments/addattachmentwidget.dart';
import 'package:assignment_sem6/screens/post/attachments/attachmentwidget.dart';
import 'package:assignment_sem6/util/toast.dart';
import 'package:assignment_sem6/widgets/dataholderstate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttachmentList extends StatefulWidget {
  final List<String> attachments;
  final ResourceService? resourceService;
  final bool editable;
  final Function(Resource)? onAttachmentAdded;
  final Function(String)? onDelete;

  const AttachmentList._({
    super.key,
    required this.attachments,
    this.resourceService,
    this.editable = false,
    this.onAttachmentAdded,
    this.onDelete,
  });

  const AttachmentList({
    Key? key,
    ResourceService? resourceService,
    required List<String> attachments,
  }) : this._(
         key: key,
         attachments: attachments,
         resourceService: resourceService,
         editable: false,
       );

  const AttachmentList.editable({
    Key? key,
    ResourceService? resourceService,
    required List<String> attachments,
    required Function(Resource) onAttachmentAdded,
    required Function(String) onDelete,
  }) : this._(
         key: key,
         attachments: attachments,
         editable: true,
         resourceService: resourceService,
         onAttachmentAdded: onAttachmentAdded,
         onDelete: onDelete,
       );

  @override
  State<AttachmentList> createState() => _AttachmentListState();
}

class _AttachmentListState
    extends DataHolderState<AttachmentList, Map<String, Resource>> {
  @override
  Future<Map<String, Resource>?> getDataFromSource() async {
    final resourceService =
        widget.resourceService ?? context.read<ResourceService>();
    if (widget.attachments.isEmpty) {
      return {};
    }
    return await resourceService.getByUUIDs(widget.attachments);
  }

  void _onFilePicked(PlatformFile file) async {
    final resourceService =
        widget.resourceService ?? context.read<ResourceService>();
    final fileExtension = file.name.split(".").last.toLowerCase();

    if (!ResourceType.allExtensions.contains(fileExtension)) {
      Toast.showToast(context, "Unsupported file type: $fileExtension");
      return;
    }

    final resource = Resource.create(
      type: ResourceType.fromExtension(fileExtension),
      name: file.name.replaceAll(".$fileExtension", ""),
      originalExtension: fileExtension,
      data: file.bytes!,
    );
    try {
      await resourceService.addResource(resource);

      widget.onAttachmentAdded!(resource);
      refreshData();

      Toast.showToast(
        context,
        "Added attachment: ${resource.name}.${resource.originalExtension}",
      );
    } catch (e) {
      Toast.showToast(context, "Failed to add attachment, please try again.");
      return;
    }
  }

  @override
  Widget content(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final attachment in data?.entries ?? <MapEntry<String, Resource>>[])
        AttachmentWidget(
          attachmentUUID: attachment.key,
          attachmentResource: attachment.value,
          editable: widget.editable,
          onDelete:
              widget.editable
                  ? (uuid) {
                    widget.onDelete?.call(uuid);
                    refreshData();
                  }
                  : null,
        ),

      if (widget.editable) AddAttachmentWidget(onFilePicked: _onFilePicked),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return getChild(context);
  }
}
