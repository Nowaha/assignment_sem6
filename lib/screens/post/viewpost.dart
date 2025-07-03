import 'package:assignment_sem6/config/postmarkdownconfig.dart';
import 'package:assignment_sem6/data/service/commentservice.dart';
import 'package:assignment_sem6/data/service/data/postview.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/screens/post/attachments/attachmentlist.dart';
import 'package:assignment_sem6/screens/profile/grouplist.dart';
import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/util/toast.dart';
import 'package:assignment_sem6/widgets/actualtextbutton.dart';
import 'package:assignment_sem6/widgets/comment/commentsection.dart';
import 'package:assignment_sem6/widgets/dataholderstate.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_widget/widget/markdown_block.dart';
import 'package:provider/provider.dart';

class ViewPost extends StatefulWidget {
  final String? postUUID;
  final Color? backgroundColor;
  final Widget? leading;
  final List<Widget>? actions;

  const ViewPost({
    super.key,
    this.postUUID,
    this.backgroundColor,
    this.leading,
    this.actions,
  });

  @override
  State<StatefulWidget> createState() => _ViewPostState();
}

class _ViewPostState extends DataHolderState<ViewPost, PostView> {
  @override
  Widget content(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 960),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            data?.post.title ?? "Loading...",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Wrap(
            children: [
              Text(
                "Written by ",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                ),
              ),
              ActualTextButton(
                text:
                    "${data?.creator?.firstName ?? "Unknown"} ${data?.creator?.lastName ?? ""} ",
                onTap: () {
                  if (data?.creator?.uuid != null) {
                    context.push("/profile/${data!.creator!.uuid}");
                  }
                },
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "on ${data?.post.creationTimestamp != null ? DateUtil.formatDateTime(data!.post.creationTimestamp, false) : "Unknown"}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          Divider(height: 8),

          MarkdownBlock(
            data: data?.post.postContents ?? "Loading...",
            config: postMarkdownConfig(context),
          ),

          SizedBox(height: 8),

          Divider(height: 8),

          SizedBox(height: 8),

          if (data?.post.attachments != null &&
              data!.post.attachments.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  "Attachments",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                AttachmentList(attachments: data!.post.attachments),
              ],
            ),

          SizedBox(height: 16),

          Divider(height: 8),

          SizedBox(height: 4),

          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 32,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Timeframe",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "Start: ${data?.post.startTimestamp != null ? DateUtil.formatDateTime(data!.post.startTimestamp, true) : "Unknown"}",
                    ),
                    Text(
                      "End: ${data?.post.endTimestamp != null ? DateUtil.formatDateTime(data!.post.endTimestamp!, true) : "Unknown"}",
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Total duration: ${data?.post.startTimestamp != null ? (data!.post.endTimestamp == null ? "Endless" : DateUtil.formatInterval(data!.post.endTimestamp! - data!.post.startTimestamp)) : "Unknown"}",
                    ),
                  ],
                ),

                SizedBox(height: 8),

                Column(
                  spacing: 4,
                  children: [
                    Text(
                      "Groups",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (widget.postUUID != null)
                      GroupList.ofPost(postUUID: widget.postUUID!),
                  ],
                ),

                SizedBox(height: 8),

                Column(
                  spacing: 4,
                  children: [
                    Text(
                      "Tags",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children:
                          data?.post.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              padding: EdgeInsets.zero,
                            );
                          }).toList() ??
                          [],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          Divider(height: 8),

          SizedBox(height: 8),

          CommentSection(
            postUUID: widget.postUUID ?? "",
            comments: data?.comments?.values.toList() ?? [],
            onCommentAdded: () => refreshData(),
            onDelete: (commentUUID) {
              try {
                final commentService = context.read<CommentService>();
                commentService.deleteComment(commentUUID);
                Toast.showToast(context, "Comment deleted successfully.");
              } catch (e) {
                Toast.showToast(context, "Failed to delete comment.");
              }
              refreshData();
            },
            onReply: () => refreshData(),
          ),
        ],
      ),
    ),
  );

  @override
  Future<PostView?> getDataFromSource() async {
    final postService = context.read<PostService>();
    return await postService.getByUUIDLinked(widget.postUUID!);
  }

  @override
  Widget build(BuildContext context) => Screen.scroll(
    title: Text(data?.post.title ?? "Loading..."),
    leading: widget.leading,
    appBarActions: widget.actions,
    alignment:
        loadingState == LoadingState.success
            ? Alignment.topLeft
            : Alignment.center,
    backgroundColor: widget.backgroundColor,
    child: getChild(context),
  );
}
