import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:assignment_sem6/widgets/dataholderstate.dart';
import 'package:assignment_sem6/widgets/media/mediaerror.dart';
import 'package:assignment_sem6/widgets/media/image/postimageerrorbuilder.dart';
import 'package:assignment_sem6/widgets/media/video/customvideoplayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourceVideo extends StatefulWidget {
  final String resourceUUID;
  final ResourceService? resourceService;

  const ResourceVideo({
    super.key,
    required this.resourceUUID,
    this.resourceService,
  });

  @override
  State<StatefulWidget> createState() => _ResourceVideoState();
}

class _ResourceVideoState extends DataHolderState<ResourceVideo, Resource> {
  @override
  bool silent = true;

  @override
  Widget errorIndicator(BuildContext context) =>
      MediaError(message: "Failed to load video.");

  @override
  Widget content(BuildContext context) {
    if (data == null) {
      return postImageErrorBuilder(context, "Video not found", null);
    }

    return CustomVideoPlayer(resource: data!);
  }

  @override
  Widget build(BuildContext context) => getChild(context);

  @override
  Future<Resource?> getDataFromSource() async {
    final resourceService =
        widget.resourceService ?? context.read<ResourceService>();

    final res = await resourceService.getByUUID(widget.resourceUUID);

    if (res == null) return null;
    if (res.type != ResourceType.video) return null;
    return res;
  }
}
