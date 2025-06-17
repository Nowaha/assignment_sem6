import 'package:assignment_sem6/data/dao/dao.dart';
import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/util/sort.dart';

abstract class CommentDao extends Dao<Comment> {
  Future<List<Comment>> findOfCreator(
    String creatorUUID, {
    Sort sort,
    int limit,
    int page,
  });
  Future<List<Comment>> findOfPost(
    String postUUID, {
    Sort sort,
    int limit,
    int page,
  });
}
