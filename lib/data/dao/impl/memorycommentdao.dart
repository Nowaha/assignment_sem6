import 'package:assignment_sem6/data/dao/commentdao.dart';
import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/extension/list.dart';
import 'package:assignment_sem6/extension/map.dart';
import 'package:assignment_sem6/mixin/mutexmixin.dart';
import 'package:assignment_sem6/util/sort.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:assignment_sem6/util/uuid.dart';

class MemoryCommentDao extends CommentDao with MutexMixin {
  final Map<String, Comment> _comments = {};

  @override
  Future<void> init() async {
    for (int i = 0; i < 10; i++) {
      await insert(
        Comment(
          uuid: UUIDv4.generate(),
          creationTimestamp: Time.nowAsTimestamp(),
          creatorUUID: "2ff4e446-504e-4d5d-90e2-ce708f94d20e",
          postUUID: "4fa88a92-dac7-4cc9-96ee-6d8a698f9743",
          contents: "This is a comment!",
        ),
      );
    }
  }

  Future<void> _sortComments(Sort sort, List<Comment> posts) async =>
      posts.sort(
        (a, b) =>
            (sort == Sort.ascending ? 1 : -1) *
            a.creationTimestamp.compareTo(b.creationTimestamp),
      );

  @override
  Future<Comment?> findByUUID(String uuid) => safe(() async => _comments[uuid]);

  @override
  Future<Map<String, Comment>> findByUUIDs(Iterable<String> uuids) =>
      safe(() async => _comments.getAll(uuids));

  @override
  Future<List<Comment>> findOfCreator(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => safe(() async {
    List<Comment> comments =
        _comments.values
            .where((comment) => comment.creatorUUID == creatorUUID)
            .toList();
    if (comments.isEmpty) return List.empty();

    await _sortComments(sort, comments);

    return comments.takePage(page, limit);
  });

  @override
  Future<List<Comment>> findOfPost(
    String postUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => safe(() async {
    List<Comment> comments =
        _comments.values
            .where((comment) => comment.postUUID == postUUID)
            .toList();
    if (comments.isEmpty) return List.empty();

    await _sortComments(sort, comments);

    return comments.takePage(page, limit);
  });

  @override
  Future<List<Comment>> findAll() =>
      safe(() async => _comments.values.toList());

  @override
  Future<void> insert(Comment comment) => safe(() async {
    // To mimic unique constraints in a database
    if (_comments.containsKey(comment.uuid)) {
      throw ArgumentError('A comment with the same UUID already exists.');
    }

    _comments[comment.uuid] = comment;
  });

  @override
  Future<void> update(Comment comment) => safe(() async {
    if (!_comments.containsKey(comment.uuid)) {
      throw ArgumentError('No comment with that UUID exists.');
    }

    _comments[comment.uuid] = comment;
  });

  @override
  Future<bool> delete(String uuid) =>
      safe(() async => _comments.remove(uuid) != null);
}
