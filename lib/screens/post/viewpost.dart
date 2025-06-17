import 'package:assignment_sem6/data/service/data/postview.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/mixin/toastmixin.dart';
import 'package:assignment_sem6/widgets/comment/commentsection.dart';
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

    await Future.delayed(const Duration(milliseconds: 2500));

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

  Widget _loadingIndicator() => Column(
    spacing: 16,
    children: [Text("Fetching post..."), const CircularProgressIndicator()],
  );

  Widget _errorIndicator() => Text("Failed to fetch post.");

  @override
  Widget build(BuildContext context) {
    final Widget child;

    if (_isLoading) {
      child = _loadingIndicator();
    } else if (post == null) {
      child = _errorIndicator();
    } else {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text("hi :3"),
          Text(
            "Author: ${post?.creator?.firstName ?? "Unknown"} ${post?.creator?.lastName ?? ""}",
          ),
          CommentSection(comments: post?.comments?.values.toList() ?? []),
        ],
      );
    }

    return Screen.scroll(
      title: Text(post?.post.title ?? "Loading..."),
      alignment:
          _isLoading || post == null ? Alignment.center : Alignment.topLeft,
      child: child,
    );
  }
}
