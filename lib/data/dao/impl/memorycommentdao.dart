import 'package:assignment_sem6/data/dao/commentdao.dart';
import 'package:assignment_sem6/data/dao/memorydao.dart';
import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/extension/list.dart';
import 'package:assignment_sem6/util/sort.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:assignment_sem6/util/uuid.dart';

class MemoryCommentDao extends MemoryDao<Comment> implements CommentDao {
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

  Future<List<Comment>> _sortAndGroupComments(
    Sort sort,
    List<Comment> comments,
  ) async {
    comments.sort(
      (a, b) =>
          (sort == Sort.ascending ? 1 : -1) *
          a.creationTimestamp.compareTo(b.creationTimestamp),
    );

    final Map<String, CommentNode> commentMap = {};
    for (final c in comments) {
      commentMap[c.uuid] = CommentNode(c);
    }

    CommentNode? root = CommentNode(null);

    for (final comment in comments) {
      final node = commentMap[comment.uuid]!;

      if (comment.replyToUUID == null) {
        root.children.add(node);
      } else {
        final parentNode = commentMap[comment.replyToUUID];
        if (parentNode != null) {
          parentNode.children.add(node);
        } else {
          root.children.add(node);
        }
      }
    }

    List<Comment> result = [];
    void traverse(CommentNode node) {
      if (node.comment != null) {
        result.add(node.comment!);
      }
      for (final child in node.children) {
        traverse(child);
      }
    }

    traverse(root);

    return result;
  }

  @override
  Future<List<Comment>> findOfCreator(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => safe(() async {
    List<Comment> comments =
        memory.values
            .where((comment) => comment.creatorUUID == creatorUUID)
            .toList();
    if (comments.isEmpty) return List.empty();

    return (await _sortAndGroupComments(sort, comments)).takePage(page, limit);
  });

  @override
  Future<List<Comment>> findOfPost(
    String postUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => safe(() async {
    List<Comment> comments =
        memory.values.where((comment) => comment.postUUID == postUUID).toList();
    if (comments.isEmpty) return List.empty();

    return (await _sortAndGroupComments(sort, comments)).takePage(page, limit);
  });

  @override
  Future<bool> delete(String uuid) async {
    if (!await super.delete(uuid)) {
      return false;
    }

    // Remove all replies to this comment
    final all = await findAll();
    for (final comment in all) {
      if (comment.replyToUUID == uuid) {
        await delete(comment.uuid);
      }
    }

    return true;
  }
}

class CommentNode {
  final Comment? comment;
  final List<CommentNode> children = [];

  CommentNode(this.comment);
}
