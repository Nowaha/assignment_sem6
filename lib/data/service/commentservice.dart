import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/data/repo/commentrepository.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';
import 'package:assignment_sem6/data/service/service.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/util/sort.dart';

abstract class CommentService
    extends LinkedService<Comment, CommentView, CommentRepository> {
  final UserService userService;

  CommentService({required super.repository, required this.userService});

  Future<Iterable<Comment>> getCommentsOfCreator(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => repository.getCommentsOfCreator(
    creatorUUID,
    sort: sort,
    limit: limit,
    page: page,
  );

  Future<Map<String, CommentView>> getCommentsOfCreatorLinked(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) async => linkAll(
    await getCommentsOfCreator(
      creatorUUID,
      sort: sort,
      limit: limit,
      page: page,
    ),
  );

  Future<Iterable<Comment>> getCommentsOfPost(
    String postUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => repository.getCommentsOfPost(
    postUUID,
    sort: sort,
    limit: limit,
    page: page,
  );

  Future<Map<String, CommentView>> getCommentsOfPostLinked(
    String postUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) async => linkAll(
    await getCommentsOfPost(postUUID, sort: sort, limit: limit, page: page),
  );

  Future<void> addComment(
    String postUUID, {
    required String creatorUUID,
    required String contents,
  }) async {
    final comment = Comment.create(
      postUUID: postUUID,
      contents: contents,
      creatorUUID: creatorUUID,
    );
    return repository.add(comment);
  }

  Future<bool> deleteComment(String commentUUID) =>
      repository.remove(commentUUID);
}
