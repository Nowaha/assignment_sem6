import 'package:assignment_sem6/mixin/formmixin.dart';
import 'package:assignment_sem6/widgets/loadingiconbutton.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  static const String routeName = "/post";

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

            buildFormTextInput("Contents", contentsController, multiline: true),

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
          ],
        ),
      ),
    );
  }
}
