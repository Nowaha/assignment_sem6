import 'package:assignment_sem6/data/entity/impl/group.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/data/commentview.dart';

class PostView {
  final Post post;
  final User? creator;
  final Map<String, CommentView>? comments;
  final Map<String, Group>? groups;

  PostView({required this.post, this.creator, this.comments, this.groups});
}
