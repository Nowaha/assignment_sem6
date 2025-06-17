import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/data/repo/commentrepository.dart';
import 'package:assignment_sem6/util/sort.dart';
import 'package:assignment_sem6/util/uuid.dart';

class CommentRepositoryImpl extends CommentRepository {
  CommentRepositoryImpl({required super.dao});

  @override
  Future<List<Comment>> getCommentsOfCreator(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) {
    if (!UUIDv4.isValid(creatorUUID)) {
      throw ArgumentError("Invalid UUID", "postUUID");
    }

    if (limit <= 0) {
      throw ArgumentError("Limit must be > 0", "limit");
    }

    if (page < 0) {
      throw ArgumentError("Page must be >= 0", "page");
    }

    return dao.findOfCreator(creatorUUID, sort: sort, limit: limit, page: page);
  }

  @override
  Future<List<Comment>> getCommentsOfPost(
    String postUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) {
    if (!UUIDv4.isValid(postUUID)) {
      throw ArgumentError("Invalid UUID", "postUUID");
    }

    if (limit <= 0) {
      throw ArgumentError("Limit must be > 0", "limit");
    }

    if (page < 0) {
      throw ArgumentError("Page must be >= 0", "page");
    }

    return dao.findOfPost(postUUID, sort: sort, limit: limit, page: page);
  }
}
