import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/widgets/comment/commentwidget.dart';
import 'package:assignment_sem6/widgets/comment/writecomment.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  final String postUUID;
  final List<CommentView> comments;

  const CommentSection({
    super.key,
    required this.postUUID,
    required this.comments,
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
        WriteComment(postUUID: widget.postUUID),
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
                return CommentWidget(comment: comment);
              },
              itemCount: widget.comments.length,
            ),
      ],
    );
  }
}
