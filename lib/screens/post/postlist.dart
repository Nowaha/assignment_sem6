import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/data/service/data/postview.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/widgets/dataholderstate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostList extends StatefulWidget {
  final Map<String, PostView>? posts;
  final String? creatorUUID;
  final int perPage;

  const PostList._({
    super.key,
    this.posts,
    this.creatorUUID,
    this.perPage = 10,
  });

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
  int _page = 0;

  void _nextPage() {
    if ((data?.length ?? 0) < widget.perPage) {
      return;
    }

    setState(() {
      _page++;
    });
    refreshData();
  }

  void _previousPage() {
    if (_page > 0) {
      setState(() {
        _page--;
      });
      refreshData();
    }
  }

  @override
  Widget build(BuildContext context) => getChild(context);

  @override
  Widget content(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Theme.of(context).colorScheme.primaryContainer,
        width: 2,
      ),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 2, bottom: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _page > 0 ? _previousPage : null,
                tooltip: "Previous Page",
              ),
              Text(
                "Page ${_page + 1}, ${widget.perPage} posts per page",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed:
                    (data?.length ?? 0) >= widget.perPage ? _nextPage : null,
                tooltip: "Next Page",
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (data == null || data!.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final PostView post = data!.values.elementAt(index);
            return ListTile(
              title: Text(post.post.title),
              subtitle: Text(
                "${post.creator?.firstName ?? "Loading..."} ${post.creator?.lastName ?? ""} - ${DateUtil.formatDateTime(post.post.creationTimestamp, false)}",
              ),
              onTap: () => context.push("/post/${post.post.uuid}"),
            );
          },
          itemCount: data?.length ?? 0,
        ),
      ],
    ),
  );

  @override
  Future<Map<String, PostView>?> getDataFromSource() async {
    if (widget.posts != null) {
      return widget.posts;
    }

    if (widget.creatorUUID != null) {
      final PostService postService = context.read<PostService>();
      final newPosts = await postService.getPostsOfCreatorLinked(
        widget.creatorUUID!,
        limit: widget.perPage,
        page: _page,
      );
      return newPosts;
    }

    throw Exception("No posts or creator UUID provided");
  }
}
