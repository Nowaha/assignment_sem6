import 'package:assignment_sem6/data/dao/commentdao.dart';
import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/data/repo/repository.dart';
import 'package:assignment_sem6/util/sort.dart';

abstract class CommentRepository extends Repository<Comment, CommentDao> {
  CommentRepository({required super.dao});

  Future<List<Comment>> getCommentsOfCreator(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  });

  Future<List<Comment>> getCommentsOfPost(
    String postUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  });
}
