import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key});

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
        const SizedBox(height: 8),
        Text("No comments yet.", style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
