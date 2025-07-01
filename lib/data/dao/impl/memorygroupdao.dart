import 'package:assignment_sem6/data/dao/groupdao.dart';
import 'package:assignment_sem6/data/dao/memorydao.dart';
import 'package:assignment_sem6/data/entity/impl/group.dart';
import 'package:assignment_sem6/extension/entityiterable.dart';
import 'package:assignment_sem6/extension/iterable.dart';
import 'package:flutter/material.dart';

class MemoryGroupDao extends MemoryDao<Group> implements GroupDao {
  @override
  Future<void> init() async {
    await ensureEveryoneGroupExists();
  }

  @override
  Future<void> ensureEveryoneGroupExists() async {
    if (internalFindByUUID(Group.everyoneUUID) != null) {
      return;
    }

    await insert(
      Group(
        uuid: Group.everyoneUUID,
        creationTimestamp: DateTime.now().millisecondsSinceEpoch,
        name: "Everyone",
        color: Colors.grey,
      ),
    );
  }

  @override
  Future<Group?> findByName(String name) => safe(
    () async => memory.values.firstWhereOrNull((group) => group.name == name),
  );

  @override
  Future<void> update(Group entity) {
    if (entity.uuid == Group.everyoneUUID) {
      throw ArgumentError("Cannot update the 'Everyone' group.", "uuid");
    }
    return super.update(entity);
  }

  @override
  Future<bool> delete(String uuid) {
    if (uuid == Group.everyoneUUID) {
      throw ArgumentError("Cannot delete the 'Everyone' group.", "uuid");
    }
    return super.delete(uuid);
  }

  @override
  Future<Map<String, Group>> getUserGroups(String userUuid) async =>
      memory.values
          .where(
            (group) =>
                group.members.contains(userUuid) ||
                group.uuid == Group.everyoneUUID,
          )
          .toUuidMap();

  @override
  Future<Map<String, Group>> findByNames(Iterable<String> names) async {
    print(names);
    return memory.values
        .where((group) => names.contains(group.name))
        .toUuidMap();
  }
}
