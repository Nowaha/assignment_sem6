import 'package:assignment_sem6/data/entity/impl/group.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';

class GroupView {
  final Group group;
  final Map<String, User> members;

  const GroupView({required this.group, required this.members});
}
