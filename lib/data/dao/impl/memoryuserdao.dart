import 'dart:async';

import 'package:assignment_sem6/data/dao/memorydao.dart';
import 'package:assignment_sem6/data/dao/userdao.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/extension/iterable.dart';
import 'package:assignment_sem6/extension/map.dart';
import 'package:assignment_sem6/mixin/streammixin.dart';

class MemoryUserDao extends MemoryDao<User>
    with StreamMixin<User>
    implements UserDao {
  @override
  Future<void> init() async {}

  @override
  Future<User?> findByUsername(String username) =>
      safe(() async => _findByUsername(username));
  User? _findByUsername(String username) => memory.values.firstWhereOrNull(
    (user) => user.username.toLowerCase() == username.toLowerCase(),
  );

  @override
  Future<Map<String, User>> findByUUIDs(Iterable<String> uuids) =>
      safe(() async => memory.getAll(uuids));

  @override
  Future<User?> findByEmail(String email) =>
      safe(() async => _findByEmail(email));
  User? _findByEmail(String email) => memory.values.firstWhereOrNull(
    (user) => user.email.toLowerCase() == email.toLowerCase(),
  );

  @override
  Future<void> insert(User entity) => safe(() async {
    // To mimic unique constrains in a database
    if (internalFindByUUID(entity.username) != null) {
      throw ArgumentError("A user with the same username already exists.");
    }
    if (internalFindByUUID(entity.email) != null) {
      throw ArgumentError("A user with the same email address already exists.");
    }
    return internalInsert(entity);
  });

  @override
  void dispose() {
    controller.close();
  }
}
