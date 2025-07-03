import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/widgets/comment/commentwidget.dart';
import 'package:assignment_sem6/widgets/comment/writecomment.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  final String postUUID;
  final List<CommentView> comments;
  final VoidCallback? onCommentAdded;
  final Function(String)? onDelete;
  final VoidCallback? onReply;

  const CommentSection({
    super.key,
    required this.postUUID,
    required this.comments,
    this.onCommentAdded,
    this.onDelete,
    this.onReply,
  });

  @override
  State<StatefulWidget> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Comments", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16.0),
        WriteComment(
          postUUID: widget.postUUID,
          onCommentAdded: widget.onCommentAdded,
        ),
        const SizedBox(height: 16.0),
        Divider(),
        Text("Post comments", style: Theme.of(context).textTheme.titleMedium),
        widget.comments.isEmpty
            ? Text(
              "No comments yet.",
              style: Theme.of(context).textTheme.bodyMedium,
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final comment = widget.comments[index];
                return CommentWidget(
                  comment: comment,
                  onDelete: () => widget.onDelete?.call(comment.comment.uuid),
                  onReply: () => widget.onReply?.call(),
                );
              },
              itemCount: widget.comments.length,
            ),
      ],
    );
  }
}
