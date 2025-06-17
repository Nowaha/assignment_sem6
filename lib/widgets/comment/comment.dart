import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final User poster;
  final Comment comment;

  const CommentWidget({super.key, required this.poster, required this.comment});

  @override
  Widget build(BuildContext context) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      comment.creationTimestamp,
    );

    return ListTile(
      title: Text(poster.firstName),
      subtitle: Text(comment.contents),
      trailing: Text(
        '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
