import 'dart:ui';

import 'package:assignment_sem6/data/entity/impl/group.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/data/groupview.dart';
import 'package:assignment_sem6/data/service/groupservice.dart';
import 'package:assignment_sem6/extension/entityiterable.dart';
import 'package:assignment_sem6/util/validation.dart';

class GroupServiceImpl extends GroupService {
  const GroupServiceImpl({
    required super.repository,
    required super.userRepository,
  });

  @override
  Future<GroupView?> link(Group? entity) async {
    if (entity == null) return null;

    if (entity.uuid == Group.everyoneUUID) {
      return GroupView(
        group: entity,
        members: (await userRepository.getAll()).toUuidMap(),
      );
    }

    return GroupView(
      group: entity,
      members: await userRepository.getByUUIDs(entity.members),
    );
  }

  @override
  Future<Map<String, GroupView>> linkAll(Iterable<Group> entities) async {
    bool anyWantAll = entities.any((group) => group.uuid == Group.everyoneUUID);
    Map<String, User> users =
        anyWantAll
            ? (await userRepository.getAll()).toUuidMap()
            : await userRepository.getByUUIDs(
              entities.expand((group) => group.members).toSet(),
            );

    return {
      for (Group group in entities)
        group.uuid: GroupView(
          group: group,
          members: group.members.fold<Map<String, User>>({}, (map, userUuid) {
            map[userUuid] = users[userUuid]!;
            return map;
          }),
        ),
    };
  }

  @override
  Future<Map<String, Group>> getUserGroups(String userUuid) =>
      repository.getUserGroups(userUuid);

  @override
  Future<Map<String, GroupView>> getUserGroupsLinked(String userUuid) async {
    Map<String, Group> groups = await repository.getUserGroups(userUuid);
    return linkAll(groups.values);
  }

  @override
  Future<bool> existsByName(String name) async =>
      await repository.getByName(name) != null;

  @override
  Future<Group> createNewGroup({
    required String name,
    required Color color,
    List<String> members = const [],
  }) async {
    if (Validation.isValidGroupName(name) != GroupNameValidationResult.valid) {
      throw ArgumentError("Group name invalid.", "name");
    }

    if (await existsByName(name)) {
      throw ArgumentError("Group with name '$name' already exists.", "name");
    }

    final Group group = Group.create(
      name: name,
      color: color,
      members: members,
    );
    await repository.add(group);
    return group;
  }

  @override
  Future<void> addMember(String groupUuid, String userUuid) async {
    Group? group = await repository.getByUUID(groupUuid);
    if (group == null) {
      throw ArgumentError("Group with UUID $groupUuid does not exist.");
    }

    List<String> members = List.from(group.members);
    if (members.contains(userUuid)) {
      throw ArgumentError(
        "User with UUID $userUuid is already a member of the group.",
      );
    }

    group.copyWith(members: [...group.members, userUuid]);
    await repository.update(group);
  }

  @override
  Future<void> removeMember(String groupUuid, String userUuid) async {
    Group? group = await repository.getByUUID(groupUuid);
    if (group == null) {
      throw ArgumentError("Group with UUID $groupUuid does not exist.");
    }

    List<String> members = List.from(group.members);
    if (!members.contains(userUuid)) {
      throw ArgumentError(
        "User with UUID $userUuid is not a member of the group.",
      );
    }

    group.copyWith(members: members..remove(userUuid));
    await repository.update(group);
  }
}
