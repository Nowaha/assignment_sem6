import 'package:assignment_sem6/data/dao/userdao.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/extension/iterable.dart';
import 'package:assignment_sem6/mixin/mutexmixin.dart';

class MemoryUserDao extends UserDao with MutexMixin {
  final Map<String, User> _users = {};

  @override
  Future<Iterable<User>> findAll() => safe(() async => _users.values);

  @override
  Future<User?> findByUUID(String uuid) => safe(() async => _findByUUID(uuid));
  User? _findByUUID(String uuid) => _users[uuid];

  @override
  Future<User?> findByUsername(String username) =>
      safe(() async => _findByUsername(username));
  User? _findByUsername(String username) =>
      _users.values.firstWhereOrNull((user) => user.username == username);

  @override
  Future<User?> findByEmail(String email) =>
      safe(() async => _findByEmail(email));
  User? _findByEmail(String email) =>
      _users.values.firstWhereOrNull((user) => user.email == email);

  @override
  Future<void> insert(User user) => safe(() async {
    // To mimic unique constrains in a database
    if (_findByUUID(user.uuid) != null) {
      throw ArgumentError('A user with the same UUID already exists.');
    }
    if (_findByUUID(user.username) != null) {
      throw ArgumentError('A user with the same username already exists.');
    }
    if (_findByUUID(user.email) != null) {
      throw ArgumentError('A user with the same email address already exists.');
    }

    _users[user.uuid] = user;
  });

  @override
  Future<void> update(User user) => safe(() async {
    if (_findByUUID(user.uuid) == null) {
      throw ArgumentError("No user with that UUID exists.");
    }

    _users[user.uuid] = user;
  });

  @override
  Future<bool> delete(String uuid) =>
      safe(() async => _users.remove(uuid) != null);
}
