import 'package:assignment_sem6/data/service/data/postview.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/widgets/comment/commentsection.dart';
import 'package:assignment_sem6/widgets/dataholderstate.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewPost extends StatefulWidget {
  final String? postUUID;
  final Color? backgroundColor;

  const ViewPost({super.key, this.postUUID, this.backgroundColor});

  @override
  State<StatefulWidget> createState() => _ViewPostState();
}

class _ViewPostState extends DataHolderState<ViewPost, PostView> {
  @override
  Widget content(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 16,
    children: [
      Text("Post Contents"),
      Text(
        "Author: ${data?.creator?.firstName ?? "Unknown"} ${data?.creator?.lastName ?? ""}",
      ),
      CommentSection(comments: data?.comments?.values.toList() ?? []),
    ],
  );

  @override
  Future<PostView?> getDataFromSource() async {
    final postService = context.read<PostService>();
    return await postService.getByUUIDLinked(widget.postUUID!);
  }

  @override
  Widget build(BuildContext context) => Screen.scroll(
    title: Text(data?.post.title ?? "Loading..."),
    alignment:
        loadingState == LoadingState.success
            ? Alignment.topLeft
            : Alignment.center,
    backgroundColor: widget.backgroundColor,
    child: getChild(context),
  );
}
