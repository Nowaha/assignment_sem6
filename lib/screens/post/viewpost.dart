import 'package:assignment_sem6/data/service/data/postview.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/mixin/toastmixin.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewPost extends StatefulWidget {
  final String postUUID;

  const ViewPost({super.key, required this.postUUID});

  @override
  State<StatefulWidget> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> with ToastMixin {
  bool _isLoading = true;
  PostView? post;

  void fetchPost() async {
    _isLoading = true;
    setState(() {});

    final postService = context.read<PostService>();

    try {
      post = await postService.getByUUIDLinked(widget.postUUID);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print(error);

      if (mounted) {
        showToast("Post failed to load.");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Screen.center(
      title: Text(post?.post.title ?? "Loading..."),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children:
            _isLoading
                ? [Text("Fetching post..."), const CircularProgressIndicator()]
                : [
                  Text("hi :3"),
                  Text(
                    "Author: ${post?.creator?.firstName ?? "Unknown"} ${post?.creator?.lastName ?? ""}",
                  ),
                ],
      ),
    );
  }
}
