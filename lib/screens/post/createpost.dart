import 'package:assignment_sem6/mixin/formmixin.dart';
import 'package:assignment_sem6/screens/post/markdowneditor.dart';
import 'package:assignment_sem6/widgets/loadingiconbutton.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class CreatePost extends StatefulWidget {
  static const String routeName = "/post/create";

  const CreatePost({super.key});

  @override
  State<StatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> with FormMixin {
  final titleController = TextEditingController();
  final contentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    registerValidators({
      titleController:
          (input) => input.isEmpty ? "Title cannot be empty." : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screen.scroll(
      title: Text("Create Post"),
      child: SizedBox(
        width: 960,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            const Text("Create a new post here!"),

            buildFormTextInput("Title", titleController, autoFocus: true),

            // buildFormTextInput("Contents", contentsController, multiline: true),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300),
              child: MarkdownEditor(
                controller: contentsController,
                label: "Contents",
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 16,
              children: [
                OutlinedButton(child: const Text("Preview"), onPressed: () {}),
                LoadingIconButton(
                  icon: Icon(Icons.add),
                  label: "Create Post",
                  loading: true,
                  onPressed: validate,
                ),
              ],
            ),

            ListenableBuilder(
              listenable: contentsController,
              builder: (context, _) {
                if (contentsController.text.isEmpty) {
                  return const Text("No contents to preview.");
                }
                return MarkdownWidget(
                  shrinkWrap: true,
                  selectable: false,
                  data: contentsController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
