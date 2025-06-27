import 'package:assignment_sem6/data/dao/userdao.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/repo/singlestreamrepository.dart';

abstract class UserRepository extends SingleStreamRepository<User, UserDao> {
  UserRepository({required super.dao});
  Future<User?> getByUsername(String username);
  Future<User?> getByEmail(String email);
}
