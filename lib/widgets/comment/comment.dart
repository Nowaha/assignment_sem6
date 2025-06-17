import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final CommentView comment;

  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      comment.comment.creationTimestamp,
    );

    return ListTile(
      title: Text(comment.creator?.firstName ?? "Unknown"),
      subtitle: Text(comment.comment.contents),
      trailing: Text(
        '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
