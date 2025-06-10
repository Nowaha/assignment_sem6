import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/repo/postrepository.dart';
import 'package:assignment_sem6/util/sort.dart';
import 'package:assignment_sem6/util/validation.dart';

class PostRepositoryImpl extends PostRepository {
  PostRepositoryImpl({required super.dao});

  @override
  Future<List<Post>> getPosts({
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) {
    if (limit <= 0) {
      throw ArgumentError("Limit must be > 0", "limit");
    }

    if (page < 0) {
      throw ArgumentError("Page must be >= 0", "page");
    }

    return dao.get(sort: sort, limit: limit, page: page);
  }

  @override
  Future<List<Post>> getPostsOfCreator(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) {
    if (!Validation.isValidUUID(creatorUUID)) {
      throw ArgumentError("Invalid UUID", "creatorUUID");
    }

    if (limit <= 0) {
      throw ArgumentError("Limit must be > 0", "limit");
    }

    if (page < 0) {
      throw ArgumentError("Page must be >= 0", "page");
    }

    return dao.findOfCreator(creatorUUID, sort: sort, limit: limit, page: page);
  }
}
