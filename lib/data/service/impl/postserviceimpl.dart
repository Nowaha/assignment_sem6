import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/util/sort.dart';

class PostServiceImpl extends PostService {
  PostServiceImpl({required super.repository});

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
}
