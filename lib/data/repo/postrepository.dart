import 'package:assignment_sem6/data/dao/postdao.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/repo/singlestreamrepository.dart';
import 'package:assignment_sem6/util/sort.dart';

abstract class PostRepository extends SingleStreamRepository<Post, PostDao> {
  PostRepository({required super.dao});

  Future<List<Post>> getPosts({Sort sort, int limit, int page});
  Future<List<Post>> getPostsOfCreator(
    String creatorUUID, {
    Sort sort,
    int limit,
    int page,
  });
}
