import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/data/service/data/postview.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/util/sort.dart';

class PostServiceImpl extends PostService {
  PostServiceImpl({
    required super.repository,
    required super.userService,
    required super.commentService,
  });

  @override
  Future<PostView?> link(Post? entity) async {
    if (entity == null) return null;

    return PostView(
      post: entity,
      creator: await userService.getByUUID(entity.creatorUUID),
      comments: await commentService.getCommentsOfPostLinked(entity.uuid),
    );
  }

  @override
  Future<Map<String, PostView>> linkAll(Iterable<Post> entities) async {
    Map<String, User> creators = await userService.getByUUIDs(
      entities.map((post) => post.creatorUUID),
    );

    Map<String, Map<String, CommentView>> comments = {};
    for (Post post in entities) {
      comments[post.uuid] = await commentService.getCommentsOfPostLinked(
        post.uuid,
      );
    }

    Map<String, PostView> linkedPosts = {};
    for (Post post in entities) {
      linkedPosts[post.uuid] = PostView(
        post: post,
        creator: creators[post.creatorUUID],
        comments: comments[post.uuid],
      );
    }
    return linkedPosts;
  }

  @override
  Future<List<Post>> getPosts({
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => repository.getPosts(sort: sort, limit: limit, page: page);

  @override
  Future<List<Post>> getPostsOfCreator(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => repository.getPosts(sort: sort, limit: limit, page: page);

  @override
  void dispose() => repository.dispose();

  @override
  Stream<List<Post>> get stream => repository.stream;
}
