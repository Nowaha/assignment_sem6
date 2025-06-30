import 'package:assignment_sem6/widgets/input/text/textinput.dart';
import 'package:flutter/material.dart';

class WriteComment extends StatefulWidget {
  const WriteComment({super.key});

  @override
  State<StatefulWidget> createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 120),
          child: TextInput(
            label: "Write a comment",
            controller: _controller,
            minLines: 2,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle comment submission logic here
            final comment = _controller.text;
            if (comment.isNotEmpty) {
              // Submit the comment
              print('Comment submitted: $comment');
              _controller.clear(); // Clear the input field after submission
            }
          },
          child: const Text('Submit Comment'),
        ),
      ],
    );
  }
}
