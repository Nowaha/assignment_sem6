import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/repo/postrepository.dart';
import 'package:assignment_sem6/data/service/commentservice.dart';
import 'package:assignment_sem6/data/service/data/postview.dart';
import 'package:assignment_sem6/data/service/service.dart';
import 'package:assignment_sem6/data/service/singlestreamservice.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/util/sort.dart';

abstract class PostService extends LinkedService<Post, PostView, PostRepository>
    implements SingleStreamService<Post, PostRepository> {
  final UserService userService;
  final CommentService commentService;

  PostService({
    required super.repository,
    required this.userService,
    required this.commentService,
  });

  Future<List<Post>> getPosts({Sort sort, int limit, int page});

  Future<Map<String, PostView>> getPostsLinked({
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) async => linkAll(await getPosts(sort: sort, limit: limit, page: page));

  Future<List<Post>> getPostsOfCreator(
    String creatorUUID, {
    Sort sort,
    int limit,
    int page,
  });

  Future<Map<String, PostView>> getPostsOfCreatorLinked(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) async => linkAll(
    await getPostsOfCreator(creatorUUID, sort: sort, limit: limit, page: page),
  );

  Future<Post> createNewPost(Post post);

  Future<bool> deletePost(String uuid);
}
