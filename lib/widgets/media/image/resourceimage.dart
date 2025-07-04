import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:assignment_sem6/widgets/dataholderstate.dart';
import 'package:assignment_sem6/widgets/media/mediaerror.dart';
import 'package:assignment_sem6/widgets/media/image/postimageerrorbuilder.dart';
import 'package:assignment_sem6/widgets/media/image/postimageframebuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourceImage extends StatefulWidget {
  final String resourceUUID;
  final ResourceService? resourceService;

  const ResourceImage({
    super.key,
    required this.resourceUUID,
    this.resourceService,
  });

  @override
  State<StatefulWidget> createState() => _ResourceImageState();
}

class _ResourceImageState extends DataHolderState<ResourceImage, Resource> {
  @override
  bool silent = true;

  @override
  Widget errorIndicator(BuildContext context) =>
      MediaError(message: "Failed to load image.");

  @override
  Widget content(BuildContext context) {
    if (data == null) {
      return postImageErrorBuilder(context, "Image not found", null);
    }

    return Image.memory(
      data!.data,
      frameBuilder: postImageFrameBuilder,
      errorBuilder: postImageErrorBuilder,
    );
  }

  @override
  Widget build(BuildContext context) => getChild(context);

  @override
  Future<Resource?> getDataFromSource() async {
    final resourceService =
        widget.resourceService ?? context.read<ResourceService>();

    final res = await resourceService.getByUUID(widget.resourceUUID);

    if (res == null) return null;
    if (res.type != ResourceType.image) return null;
    return res;
  }
}
