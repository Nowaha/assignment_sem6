import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/data/service/data/postview.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/widgets/dataholderstate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostList extends StatefulWidget {
  final Map<String, PostView>? posts;
  final String? creatorUUID;

  const PostList._({super.key, this.posts, this.creatorUUID});

  PostList.list({
    Key? key,
    required List<Post> posts,
    required User creator,
    Map<String, CommentView>? comments,
  }) : this._(
         key: key,
         posts: Map.fromEntries(
           posts.map(
             (post) => MapEntry(
               post.uuid,
               PostView(post: post, creator: creator, comments: comments),
             ),
           ),
         ),
       );

  const PostList.ofCreator({Key? key, required String creatorUUID})
    : this._(key: key, creatorUUID: creatorUUID);

  @override
  State<StatefulWidget> createState() => _PostListState();
}

class _PostListState extends DataHolderState<PostList, Map<String, PostView>?> {
  @override
  Widget build(BuildContext context) => getChild(context);

  @override
  Widget content(BuildContext context) => ListView.builder(
    shrinkWrap: true,
    itemBuilder: (context, index) {
      if (data == null || data!.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final post = data?.values.elementAt(index);
      if (post == null) {
        return const ListTile(
          title: Text("Loading..."),
          subtitle: Text("Please wait"),
        );
      }

      return ListTile(
        title: Text(post.post.title),
        subtitle: Text(post.creator?.username ?? "Loading..."),
        onTap: () => context.push("/post/${post.post.uuid}"),
      );
    },
    itemCount: data?.length ?? 0,
  );

  @override
  Future<Map<String, PostView>?> getDataFromSource() async {
    if (widget.posts != null) {
      return widget.posts;
    }

    if (widget.creatorUUID != null) {
      final PostService postService = context.read<PostService>();
      return await postService.getPostsOfCreatorLinked(widget.creatorUUID!);
    }

    throw Exception("No posts or creator UUID provided");
  }
}
