import 'dart:ui';

import 'package:assignment_sem6/data/entity/impl/group.dart';
import 'package:assignment_sem6/data/repo/grouprepository.dart';
import 'package:assignment_sem6/data/repo/userrepository.dart';
import 'package:assignment_sem6/data/service/data/groupview.dart';
import 'package:assignment_sem6/data/service/service.dart';

abstract class GroupService
    extends LinkedService<Group, GroupView, GroupRepository> {
  final UserRepository userRepository;
  const GroupService({required super.repository, required this.userRepository});

  Future<Map<String, Group>> getUserGroups(String userUuid);
  Future<Map<String, GroupView>> getUserGroupsLinked(String userUuid) async =>
      linkAll((await repository.getUserGroups(userUuid)).values);

  Future<bool> existsByName(String name);

  Future<Group> createNewGroup({
    required String name,
    required Color color,
    List<String> members = const [],
  });

  Future<void> addMember(String groupUuid, String userUuid);
  Future<void> removeMember(String groupUuid, String userUuid);
}
