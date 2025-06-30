import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/widgets/comment/commentwidget.dart';
import 'package:assignment_sem6/widgets/comment/writecomment.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  final String postUUID;
  final List<CommentView> comments;
  final VoidCallback? onCommentAdded;

  const CommentSection({
    super.key,
    required this.postUUID,
    required this.comments,
    this.onCommentAdded,
  });

  @override
  State<StatefulWidget> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Divider(thickness: 1, color: Theme.of(context).dividerColor),
        Text("Comments", style: Theme.of(context).textTheme.headlineSmall),
        WriteComment(
          postUUID: widget.postUUID,
          onCommentAdded: widget.onCommentAdded,
        ),
        Text("Post comments", style: Theme.of(context).textTheme.titleMedium),
        widget.comments.isEmpty
            ? Text(
              "No comments yet.",
              style: Theme.of(context).textTheme.bodyMedium,
            )
            : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 32),
              itemBuilder: (context, index) {
                final comment = widget.comments[index];
                return CommentWidget(comment: comment);
              },
              itemCount: widget.comments.length,
            ),
      ],
    );
  }
}
