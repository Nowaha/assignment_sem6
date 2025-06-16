import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';

class ViewPost extends StatefulWidget {
  final Post post;

  const ViewPost({super.key, required this.post});

  @override
  State<StatefulWidget> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  @override
  Widget build(BuildContext context) {
    return Screen.center(
      title: Text(widget.post.title),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("hi :3"),
          const SizedBox(height: 10),
          Text("Author: ${widget.post.creatorUUID}"),
        ],
      ),
    );
  }
}
