import 'package:assignment_sem6/data/dao/groupdao.dart';
import 'package:assignment_sem6/data/entity/impl/group.dart';
import 'package:assignment_sem6/data/repo/repository.dart';

abstract class GroupRepository extends Repository<Group, GroupDao> {
  const GroupRepository({required super.dao});

  Future<Group?> getByName(String name) => dao.findByName(name);
  Future<Map<String, Group>> getUserGroups(String userUuid) =>
      dao.getUserGroups(userUuid);
}
