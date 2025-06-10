import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/repo/postrepository.dart';
import 'package:assignment_sem6/data/service/singlestreamservice.dart';
import 'package:assignment_sem6/util/sort.dart';

abstract class PostService extends SingleStreamService<Post, PostRepository> {
  @override
  final PostRepository repository;

  PostService({required this.repository});

  Future<List<Post>> getPosts({Sort sort, int limit, int page});
  Future<List<Post>> getPostsOfCreator(
    String creatorUUID, {
    Sort sort,
    int limit,
    int page,
  });
}
