import 'package:assignment_sem6/data/dao/dao.dart';
import 'package:assignment_sem6/data/entity/impl/group.dart';

abstract class GroupDao extends Dao<Group> {
  Future<void> ensureEveryoneGroupExists();
  Future<Group?> findByName(String name);
  Future<Map<String, Group>> getUserGroups(String userUuid);
}
