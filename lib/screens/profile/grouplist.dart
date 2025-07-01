import 'package:assignment_sem6/allinputscrollbehavior.dart';
import 'package:assignment_sem6/data/service/groupservice.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/extension/entityiterable.dart';
import 'package:assignment_sem6/widgets/dataholderstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/entity/impl/group.dart';

class GroupList extends StatefulWidget {
  final Map<String, Group>? groups;
  final String? userUUID;
  final String? postUUID;

  const GroupList._({super.key, this.groups, this.userUUID, this.postUUID})
    : assert(
        groups != null || userUUID != null || postUUID != null,
        "Either groups, userUUID or postUUID must be provided",
      );

  GroupList.list({Key? key, required List<Group> groups})
    : this._(key: key, groups: groups.toUuidMap());

  const GroupList.ofUser({Key? key, required String userUUID})
    : this._(key: key, userUUID: userUUID);

  const GroupList.ofPost({Key? key, required String postUUID})
    : this._(key: key, postUUID: postUUID);

  @override
  State<StatefulWidget> createState() => _GroupListState();
}

class _GroupListState extends DataHolderState<GroupList, Map<String, Group>?> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) => getChild(context);

  @override
  Widget content(BuildContext context) => ScrollConfiguration(
    behavior: AllInputScrollBehavior(),
    child: SingleChildScrollView(
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          for (final group in data?.values ?? <Group>[])
            Container(
              decoration: BoxDecoration(
                color: group.color.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: group.color, width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(group.name),
            ),
        ],
      ),
    ),
  );

  @override
  Future<Map<String, Group>?> getDataFromSource() async {
    if (widget.groups != null) {
      return widget.groups;
    }

    if (widget.userUUID != null) {
      final GroupService groupService = context.read<GroupService>();
      return await groupService.getUserGroups(widget.userUUID!);
    }

    if (widget.postUUID != null) {
      final PostService postService = context.read<PostService>();
      return await postService
          .getByUUIDLinked(widget.postUUID!)
          .then((postView) => postView?.groups);
    }

    throw ArgumentError("Either groups, userUUID or postUUID must be provided");
  }
}
