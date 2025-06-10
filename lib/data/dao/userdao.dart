import 'package:assignment_sem6/data/dao/dao.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';

abstract class UserDao implements Dao<User> {
  Future<User?> findByUsername(String username);
  Future<User?> findByEmail(String email);
}
