import 'package:assignment_sem6/data/dao/singlestreamdao.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';

abstract class UserDao implements SingleStreamDao<User> {
  Future<User?> findByUsername(String username);
  Future<User?> findByEmail(String email);
}
