import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatePostFab extends StatelessWidget {
  final double bottomOffset;
  final User? user;

  const CreatePostFab({super.key, this.bottomOffset = 0, this.user});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: bottomOffset),
    child: FloatingActionButton(
      tooltip: "Create Post",
      onPressed: () {
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You must be logged in to post.")),
          );
          return;
        }

        context.goNamed("createPost");
      },
      child: Icon(Icons.add),
    ),
  );
}
