import 'package:assignment_sem6/data/entity/impl/comment.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';

class CommentView {
  final Comment comment;
  final User? creator;

  CommentView({required this.comment, this.creator});
}
