import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/widgets/comment/commentwidget.dart';
import 'package:assignment_sem6/widgets/comment/replylinepainter.dart';
import 'package:assignment_sem6/widgets/comment/writecomment.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  static const replyLeftPadding = 42.0;

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
        const SizedBox(height: 8.0),
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
                final commentWidget = CommentWidget(
                  key: ValueKey(comment.comment.uuid),
                  comment: comment,
                  onDelete: () => widget.onDelete?.call(comment.comment.uuid),
                  onReply: () => widget.onReply?.call(),
                );
                if (comment.comment.replyToUUID == null) {
                  return commentWidget;
                }

                final nextIsReply =
                    index + 1 < widget.comments.length &&
                    widget.comments[index + 1].comment.replyToUUID != null;

                return Stack(
                  children: [
                    Positioned(
                      left: CommentSection.replyLeftPadding / 2,
                      top: 0,
                      bottom: 0,
                      child: CustomPaint(
                        painter: ReplyLinePainter(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withAlpha(100),
                          anotherReplyBelow: nextIsReply,
                        ),
                      ),
                    ),
                    commentWidget,
                  ],
                );
              },
              itemCount: widget.comments.length,
            ),
      ],
    );
  }
}
