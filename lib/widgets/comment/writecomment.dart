import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/validation.dart';
import 'package:assignment_sem6/widgets/comment/commentwidget.dart';
import 'package:assignment_sem6/widgets/input/text/markdowneditor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteComment extends StatefulWidget {
  final String postUUID;

  const WriteComment({super.key, required this.postUUID});

  @override
  State<StatefulWidget> createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  final TextEditingController _controller = TextEditingController();
  bool _isPreviewing = false;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: MarkdownEditor(
            controller: _controller,
            label: "Write a comment",
            maxLength: Validation.maxCommentLength,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 16,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _isPreviewing = !_isPreviewing;
                });
              },
              child: const Text("Preview"),
            ),
            FilledButton(
              onPressed: () {
                final comment = _controller.text;
                if (comment.isNotEmpty) {
                  _controller.clear();
                }
              },
              child: const Text("Post Comment"),
            ),
          ],
        ),
        if (_isPreviewing)
          ListenableBuilder(
            listenable: _controller,
            builder:
                (context, _) => CommentWidget(
                  comment: CommentView(
                    comment: Comment.create(
                      creatorUUID: authState.getCurrentUser!.uuid,
                      postUUID: widget.postUUID,
                      contents: _controller.text,
                    ),
                    creator: authState.getCurrentUser,
                  ),
                ),
          ),
      ],
    );
  }
}
