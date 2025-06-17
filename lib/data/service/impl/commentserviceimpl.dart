import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/commentservice.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';

class CommentServiceImpl extends CommentService {
  CommentServiceImpl({required super.repository, required super.userService});

  @override
  Future<CommentView?> link(Comment? comment) async {
    if (comment == null) return null;
    return CommentView(
      comment: comment,
      creator: await userService.getByUUID(comment.creatorUUID),
    );
  }

  @override
  Future<Map<String, CommentView>> linkAll(Iterable<Comment> comments) async {
    Map<String, User> users = await userService.getByUUIDs(
      comments.map((comment) => comment.creatorUUID),
    );

    return {
      for (Comment comment in comments)
        comment.uuid: CommentView(
          comment: comment,
          creator: users[comment.creatorUUID],
        ),
    };
  }
}
